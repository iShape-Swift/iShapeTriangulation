//
//  PlainShape+Monotone.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

extension PlainShape {
    
    struct Link {
        static let empty = Link(prev: null, this: null, next: null, vertex: .empty)
        
        var prev: Index
        let this: Index
        var next: Index
        
        let vertex: Vertex
    }
    
    struct MonotoneLayout {
        let links: [Link]
        let slices: [Slice]
        let indices: [Int]
    }
    
    private enum LinkNature: String {
        case start
        case merge
        case split
        case end
        case simple
    }
    
    private struct ShapeNavigator {
        let iPoints: [IntPoint]
        let links: [Link]
        let natures: [LinkNature]
    }

    private struct Sub {
        var next: Link      // top branch
        var prev: Link      // bottom branch
        
        init(node: Link) {
            self.next = node
            self.prev = node
        }
        
        init(next: Link, prev: Link) {
            self.next = next
            self.prev = prev
        }
    }
    
    private struct DualSub {
        var nextSub: Sub    // top branch
        var prevSub: Sub    // bottom branch
    }
    
    private struct Bridge {
        var a: Link
        var b: Link
        var slice: Slice {
            return Slice(a: a.vertex.index, b: b.vertex.index)
        }
    }
    
    func split() -> MonotoneLayout {
        
        let navigator = self.navigator
        
        var links = navigator.links
        let natures = navigator.natures
        let sortIndices = navigator.iPoints.sortIndices
        
        let n = sortIndices.count
        
        var subs = [Sub]()
        var dSubs = [DualSub]()
        var indices = Array<Int>()
        indices.reserveCapacity(16)
        var slices = Array<Slice>()
        slices.reserveCapacity(16)
        
        var i: Int = 0
        var j: Int
        
        nextNode:
            while i < n {
                let sortIndex = sortIndices[i]
                let node = links[sortIndex]
                let nature = natures[sortIndex]
                
                switch nature {
                    
                case .start:
                    subs.append(Sub(node: node))
                    i += 1
                    continue nextNode
                case .merge:
                    
                    var newNextSub: Sub?
                    var newPrevSub: Sub?
                    
                    j = 0
                    
                    while j < dSubs.count {
                        
                        let dSub = dSubs[j]
                        
                        if dSub.nextSub.next.next == node.this {
                            let a = node.this
                            let b = dSub.prevSub.next.this
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: bridge.a.this))
                            slices.append(bridge.slice)
                            
                            let prevSub = Sub(next: links[a], prev: dSub.prevSub.prev)
                            
                            if let nextSub = newNextSub {
                                dSubs[j] = DualSub(nextSub: nextSub, prevSub: prevSub)
                                
                                i += 1
                                continue nextNode
                            }
                            
                            dSubs.exclude(index: j)
                            
                            newPrevSub = prevSub
                            continue
                        } else if dSub.prevSub.prev.prev == node.this {
                            
                            let a = dSub.nextSub.prev.this
                            let b = node.this
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: bridge.a.this))
                            slices.append(bridge.slice)

                            let nextSub = Sub(next: dSub.nextSub.next, prev: links[b])
                            
                            if let prevSub = newPrevSub {
                                dSubs[j] = DualSub(nextSub: nextSub, prevSub: prevSub)
                                
                                i += 1
                                continue nextNode
                            }
                            
                            dSubs.exclude(index: j)
                            
                            newNextSub = nextSub
                            continue
                        }
                        
                        j += 1
                        
                    }   //  while dSubs
                    
                    j = 0
                    
                    while j < subs.count {
                        var sub = subs[j]
                        
                        if sub.next.next == node.this {
                            sub.next = node
                            subs.exclude(index: j)
                            
                            if let nextSub = newNextSub {
                                dSubs.append(DualSub(nextSub: nextSub, prevSub: sub))
                                
                                i += 1
                                continue nextNode
                            }
                            
                            newPrevSub = sub
                            continue
                            
                        } else if sub.prev.prev == node.this {
                            sub.prev = node
                            subs.exclude(index: j)
                            
                            if let prevSub = newPrevSub {
                                dSubs.append(DualSub(nextSub: sub, prevSub: prevSub))
                                
                                i += 1
                                continue nextNode
                            }
                            
                            newNextSub = sub
                            continue
                        }
                        
                        j += 1
                    }
                case .split:
                    
                    j = 0
                    
                    while j < subs.count {
                        let sub = subs[j]
                        
                        let pA = sub.next.vertex.point
                        let pB = links[sub.next.next].vertex.point
                        let pC = links[sub.prev.prev].vertex.point
                        let pD = sub.prev.vertex.point
                        
                        let p = node.vertex.point
                        
                        if PlainShape.isTetragonContain(p: p, a: pA, b: pB, c: pC, d: pD) {
                            let a0 = sub.next.this
                            let a1 = sub.prev.this
                            let b = node.this
                            
                            if pA.x > pD.x {
                                let bridge = self.connect(a: a0, b: b, links: &links)
                                subs.append(Sub(next: bridge.b, prev: links[a1]))
                                slices.append(bridge.slice)
                            } else {
                                let bridge = self.connect(a: a1, b: b, links: &links)
                                subs.append(Sub(next: bridge.b, prev: bridge.a))
                                slices.append(bridge.slice)
                            }
                            subs[j] = Sub(next: links[a0], prev: links[b])
                            
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                    }
                    
                    j = 0
                    
                    while j < dSubs.count {
                        
                        let dSub = dSubs[j]
                        let pA = dSub.nextSub.next.vertex.point
                        let pB = links[dSub.nextSub.next.next].vertex.point
                        let pC = links[dSub.prevSub.prev.prev].vertex.point
                        let pD = dSub.prevSub.prev.vertex.point
                        
                        let p = node.vertex.point
                        
                        if PlainShape.isTetragonContain(p: p, a: pA, b: pB, c: pC, d: pD) {
                            let a = dSub.nextSub.prev.this
                            let b = node.this
                            let bridge = self.connect(a: a, b: b, links: &links)
                            subs.append(Sub(next: dSub.nextSub.next, prev: links[b]))
                            subs.append(Sub(next: bridge.b, prev: dSub.prevSub.prev))
                            slices.append(bridge.slice)
                            dSubs.exclude(index: j)
                            
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                        
                    }   //  while dSubs
                    
                case .end:
                    
                    j = 0
                    
                    while j < subs.count {
                        let sub = subs[j]
                        
                        // second condition is useless because it repeats the first
                        if sub.next.next == node.this /* || sub.prev.prev.index == node.this */{
                            indices.append(links.findStart(index: node.this))
                            subs.exclude(index: j)
                            
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                    }
                    
                    j = 0
                    
                    while j < dSubs.count {
                        
                        let dSub = dSubs[j]
                        
                        // second condition is useless because it repeats the first
                        if dSub.nextSub.next.next == node.this /*|| dSub.prevSub.prev.prev.index == node.this*/ {
                            
                            let a = dSub.nextSub.prev.this
                            let b = node.this
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: a))
                            indices.append(links.findStart(index: bridge.a.this))
                            slices.append(bridge.slice)
                            
                            dSubs.exclude(index: j)
                            
                            // goto next node
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                        
                }   //  while dSubs
                case .simple:
                    
                    j = 0
                    
                    while j < subs.count {
                        var sub = subs[j]
                        
                        if sub.next.next == node.this {
                            sub.next = node
                            subs[j] = sub
                            
                            i += 1
                            continue nextNode
                        } else if sub.prev.prev == node.this {
                            sub.prev = node
                            subs[j] = sub
                            
                            // goto next node
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                    }
                    
                    j = 0
                    
                    while j < dSubs.count {
                        
                        let dSub = dSubs[j]
                        
                        if dSub.nextSub.next.next == node.this {
                            
                            let a = dSub.nextSub.prev.this
                            let b = node.this
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: node.this))
                            slices.append(bridge.slice)
                            
                            let newSub = Sub(next: bridge.b, prev: dSub.prevSub.prev)
                            subs.append(newSub)
                            
                            dSubs.exclude(index: j)
                            
                            // goto next node
                            i += 1
                            continue nextNode
                        } else if dSub.prevSub.prev.prev == node.this {
                            
                            let a = node.this
                            let b = dSub.prevSub.next.this
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: node.this))
                            slices.append(bridge.slice)
                            
                            let newSub = Sub(next: links[dSub.nextSub.next.this], prev: bridge.a)
                            subs.append(newSub)
                            
                            dSubs.exclude(index: j)
                            
                            // goto next node
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                        
                    }   //  while dSubs
                }   // switch
                
                assertionFailure("unused \(nature.rawValue) point detected")
        }
        
        return MonotoneLayout(links: links, slices: slices, indices: indices)
    }
    
    private func connect(a ai: Index, b bi: Index, links: inout[Link]) -> Bridge {
        let aLink = links[ai]
        let bLink = links[bi]
        
        links[ai].prev = bi
        links[bi].next = ai
        
        let count = links.count
        
        let newLinkA = Link(
            prev: aLink.prev,
            this: count,
            next: count + 1,
            vertex: aLink.vertex
        )
        links.append(newLinkA)
        links[aLink.prev].next = count
        
        let newLinkB = Link(
            prev: count,
            this: count + 1,
            next: bLink.next,
            vertex: bLink.vertex
        )
        links.append(newLinkB)
        links[bLink.next].prev = count + 1
        
        return Bridge(a: newLinkA, b: newLinkB)
    }
    
    private var navigator: ShapeNavigator {
        let n = self.points.count
        var iPoints = Array<IntPoint>(repeating: .zero, count: n)
        var links = Array<Link>(repeating: .empty, count: n)
        var natures = Array<LinkNature>(repeating: .simple, count: n)
        
        for layout in self.layouts {
            var prev = layout.end - 1
            var this = layout.end
            var next = layout.begin
            
            var a = self.points[prev]
            var b = self.points[this]
            var A = a.bitPack
            var B = b.bitPack
            
            while next <= layout.end {
                let c = points[next]
                let C = c.bitPack
                
                var nature: LinkNature = .simple
                
                let isCCW = PlainShape.isCCW(a: a, b: b, c: c)
                
                // TODO reverse condition
                if layout.isHole {
                    if A > B && B < C {
                        if isCCW {
                            nature = .start
                        } else {
                            nature = .split
                        }
                    }
                    
                    if A < B && B > C {
                        if isCCW {
                            nature = .end
                        } else {
                            nature = .merge
                        }
                    }
                    
                } else {
                    if A > B && B < C {
                        if isCCW {
                            nature = .start
                        } else {
                            nature = .split
                        }
                    }
                    
                    if A < B && B > C {
                        if isCCW {
                            nature = .end
                        } else {
                            nature = .merge
                        }
                    }
                }
                
                iPoints[this] = b
                links[this] = Link(prev: prev, this: this, next: next, vertex: Vertex(index: this, point: b))
                natures[this] = nature
                
                a = b
                b = c
                
                A = B
                B = C
                
                prev = this
                this = next
                
                next += 1
            }
        }
        
        return ShapeNavigator(iPoints: iPoints, links: links, natures: natures)
    }
    
    private static func isCCW(a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let m0 = (c.y - a.y) * (b.x - a.x)
        let m1 = (b.y - a.y) * (c.x - a.x)
        
        return m0 < m1
    }
    
    private static func sign(a: IntPoint, b: IntPoint, c: IntPoint) -> Int64 {
        return (a.x - c.x) * (b.y - c.y) - (b.x - c.x) * (a.y - c.y)
    }
    
    private static func isTriangleContain(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        
        let d1 = PlainShape.sign(a: p, b: a, c: b)
        let d2 = PlainShape.sign(a: p, b: b, c: c)
        let d3 = PlainShape.sign(a: p, b: c, c: a)
        
        let has_neg = d1 < 0 || d2 < 0 || d3 < 0
        let has_pos = d1 > 0 || d2 > 0 || d3 > 0
        
        return !(has_neg && has_pos)
    }
    
    private static func isTetragonContain(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint, d: IntPoint) -> Bool {
        return PlainShape.isTriangleContain(p: p, a: a, b: b, c: c) || PlainShape.isTriangleContain(p: p, a: a, b: c, c: d)
    }

}

private extension Array {
    
    mutating func exclude(index: Int) {
        let lastIndex = self.count - 1
        if lastIndex != index {
            self[index] = self[lastIndex]
        }
        self.removeLast()
    }
    
}

private extension Array where Element == PlainShape.Link {
    
    func findStart(index: Int) -> Int {
        let this = self[index]
        var next = self[this.next]
        var prev = self[this.prev]
        
        var bit = this.vertex.point.bitPack
        var aBit = next.vertex.point.bitPack
        var bBit = prev.vertex.point.bitPack
        
        if aBit < bit {
            repeat {
                next = self[next.next]
                bit = aBit
                aBit = next.vertex.point.bitPack
            } while aBit < bit
            return next.prev
        } else if bBit < bit {
            repeat {
                prev = self[prev.prev]
                bit = bBit
                bBit = prev.vertex.point.bitPack
            } while bBit < bit
            return prev.next
        } else {
            return index
        }
    }
}

#if iShapeTest

struct DebugShape {
    let points: [IntPoint]
    let data: [String]
}

extension PlainShape.MonotoneLayout {

    var shapes: [DebugShape] {
        var shapes = Array<DebugShape>()
        for index in self.indices {
            
            var next = self.links[index]
            
            var points = Array<IntPoint>()
            var data = Array<String>()
            repeat {
                points.append(next.vertex.point)
                data.append(String(next.vertex.index))
                next = self.links[next.next]
            } while next.this != index

            shapes.append(DebugShape(points: points, data: data))
        }
        
        return shapes
    }

}

extension PlainShape {
    
    var pathes: [[Vertex]] {
        get {
            let navigator = self.navigator
            let links = navigator.links
            
            var pathes = [[Vertex]]()
            pathes.reserveCapacity(self.layouts.count)
            
            for split in self.layouts {
                var vertices = [Vertex]()
                vertices.reserveCapacity(navigator.iPoints.count)
                var next = links[split.begin]
                repeat {
                    vertices.append(next.vertex)
                    next = links[next.next]
                } while next.this != split.begin
                
                pathes.append(vertices)
            }
            
            return pathes
        }
    }
}

#endif