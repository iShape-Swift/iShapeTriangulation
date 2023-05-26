//
//  PlainShape+Monotone.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import iGeometry

extension PlainShape {
    
    struct Link {
        static let empty = Link(prev: null, this: null, next: null, vertex: .empty)
        
        var prev: Index
        let this: Index
        var next: Index
        
        let vertex: Vertex
    }
    
    enum SplitError: Error {
        case unusedPoint
    }
    
    struct MonotoneLayout {
        let pathCount: Int
        let extraCount: Int
        let links: [Link]
        let slices: [Slice]
        let indices: [Int]
    }

    private struct Sub {
        var next: Link      // top branch
        var prev: Link      // bottom branch
        
        @inline(__always)
        var isEmpty: Bool {
            return next.this == prev.this
        }
        
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
        var next: Link    // top branch
        var middle: Index
        var prev: Link    // bottom branch
        
        init(next: Link, middle: Index, prev: Link) {
            self.next = next
            self.middle = middle
            self.prev = prev
        }
        
        init(nextSub: Sub, prevSub: Sub) {
            self.next = nextSub.next
            self.middle = nextSub.prev.this
            self.prev = prevSub.prev
        }
    }
    
    private struct Bridge {
        var a: Link
        var b: Link
        @inline(__always)
        var slice: Slice {
            return Slice(a: a.vertex.index, b: b.vertex.index)
        }
    }
    
    func split(maxEdge: Int64, extraPoints: [IntPoint]?) throws -> MonotoneLayout {
        
        let navigator = self.createNavigator(maxEdge: maxEdge, extraPoints: extraPoints)
        
        var links = navigator.links
        let natures = navigator.natures
        let sortIndices = navigator.sortIndices
        
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
                    
                case .extra:
                    j = 0
                    
                    while j < dSubs.count {
                        
                        let dSub = dSubs[j]
                        let pA = dSub.next.vertex.point
                        let pB = links[dSub.next.next].vertex.point
                        let pC = links[dSub.prev.prev].vertex.point
                        let pD = dSub.prev.vertex.point

                        let p = node.vertex.point

                        if PlainShape.isTetragonContain(p: p, a: pA, b: pB, c: pC, d: pD) {
                            let hand = links[dSub.middle]
                             slices.append(Slice(a: hand.vertex.index, b: node.vertex.index))
                             _ = self.connectExtraPrev(hand: hand.this, node: node.this, links: &links)
                             
                            dSubs[j] = DualSub(
                                 next: links[dSub.next.this],
                                 middle: node.this,
                                 prev: links[dSub.prev.this]
                             )

                            i += 1
                            continue nextNode
                        }

                        j += 1

                    }   //  while dSubs
                    
                    j = 0
                    
                    while j < subs.count {
                        let sub = subs[j]
                        
                        let pA = sub.next.vertex.point
                        let pB = links[sub.next.next].vertex.point
                        let pC = links[sub.prev.prev].vertex.point
                        let pD = sub.prev.vertex.point
                        
                        let p = node.vertex.point
                        
                        if PlainShape.isTetragonContain(p: p, a: pA, b: pB, c: pC, d: pD) {
                            if !sub.isEmpty {
                                if pA.x > pD.x {
                                    let hand = sub.next
                                    slices.append(Slice(a: hand.vertex.index, b: node.vertex.index))
                                    let newHandIndex = self.connectExtraNext(hand: hand.this, node: node.this, links: &links)
                                    dSubs.append(
                                        DualSub(
                                            next: links[newHandIndex],
                                            middle: node.this,
                                            prev: links[sub.prev.this]
                                        )
                                    )
                                } else {
                                    let hand = sub.prev
                                    slices.append(Slice(a: hand.vertex.index, b: node.vertex.index))
                                    let newHandIndex = self.connectExtraPrev(hand: hand.this, node: node.this, links: &links)
                                    dSubs.append(
                                        DualSub(
                                            next: links[sub.next.this],
                                            middle: node.this,
                                            prev: links[newHandIndex]
                                        )
                                    )
                                }
                            } else {
                                let hand = links[sub.next.this]
                                slices.append(Slice(a: hand.vertex.index, b: node.vertex.index))
                                let newPrev = self.connectExtraPrev(hand: hand.this, node: node.this, links: &links)
                                dSubs.append(
                                    DualSub(
                                       next: links[hand.this],
                                       middle: node.this,
                                       prev: links[newPrev]
                                    )
                                )
                            }
                            subs.exclude(index: j)
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                    }
                    
                case .merge:
                    
                    var newNextSub: Sub?
                    var newPrevSub: Sub?
                    
                    j = 0
                    
                    while j < dSubs.count {
                        
                        let dSub = dSubs[j]
                        
                        if dSub.next.next == node.this {
                            let a = node.this
                            let b = dSub.middle
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: bridge.a.this))
                            slices.append(bridge.slice)
                            
                            let prevSub = Sub(next: links[a], prev: dSub.prev)
                            
                            if let nextSub = newNextSub {
                                dSubs[j] = DualSub(nextSub: nextSub, prevSub: prevSub)
                                
                                i += 1
                                continue nextNode
                            }
                            
                            dSubs.exclude(index: j)
                            
                            newPrevSub = prevSub
                            continue
                        } else if dSub.prev.prev == node.this {
                            
                            let a = dSub.middle
                            let b = node.this
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: bridge.a.this))
                            slices.append(bridge.slice)

                            let nextSub = Sub(next: dSub.next, prev: links[b])
                            
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
                        let pA = dSub.next.vertex.point
                        let pB = links[dSub.next.next].vertex.point
                        let pC = links[dSub.prev.prev].vertex.point
                        let pD = dSub.prev.vertex.point
                        
                        let p = node.vertex.point
                        
                        if PlainShape.isTetragonContain(p: p, a: pA, b: pB, c: pC, d: pD) {
                            let a = dSub.middle
                            let b = node.this
                            let bridge = self.connect(a: a, b: b, links: &links)
                            subs.append(Sub(next: dSub.next, prev: links[b]))
                            subs.append(Sub(next: bridge.b, prev: dSub.prev))
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
                        if sub.next.next == node.this /* || sub.prev.index == node.this */{
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
                        if dSub.next.next == node.this /*|| dSub.prevSub.prev.index == node.this*/ {
                            
                            let a = dSub.middle
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
                        
                        if dSub.next.next == node.this {
                            
                            let a = dSub.middle
                            let b = node.this
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: node.this))
                            slices.append(bridge.slice)
                            
                            let newSub = Sub(next: bridge.b, prev: dSub.prev)
                            subs.append(newSub)
                            
                            dSubs.exclude(index: j)
                            
                            // goto next node
                            i += 1
                            continue nextNode
                        } else if dSub.prev.prev == node.this {
                            
                            let a = node.this
                            let b = dSub.middle
                            
                            let bridge = self.connect(a: a, b: b, links: &links)
                            indices.append(links.findStart(index: node.this))
                            slices.append(bridge.slice)
                            
                            let newSub = Sub(next: links[dSub.next.this], prev: bridge.a)
                            subs.append(newSub)
                            
                            dSubs.exclude(index: j)
                            
                            // goto next node
                            i += 1
                            continue nextNode
                        }
                        
                        j += 1
                        
                    }   //  while dSubs
                }   // switch
                
                throw SplitError.unusedPoint
        }
        
        let pathCount = navigator.pathCount
        let extraCount = navigator.extraCount
        
        return MonotoneLayout(pathCount: pathCount, extraCount: extraCount, links: links, slices: slices, indices: indices)
    }
    
    @inline(__always)
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

    @inline(__always)
    private func connectExtraPrev(hand iHand: Index, node iNode: Index, links: inout[Link]) -> Index {
        var handLink = links[iHand]
        var nodeLink = links[iNode]
        let iPrev = handLink.prev
        var prevLink = links[iPrev]
        
        let count = links.count
        
        let iNewHand = count
        
        let newHandLink = Link(
            prev: handLink.prev,
            this: iNewHand,
            next: iNode,
            vertex: handLink.vertex
        )
        links.append(newHandLink)

        handLink.prev = iNode
        nodeLink.next = iHand
        nodeLink.prev = iNewHand
        prevLink.next = iNewHand
        
        
        
        links[iNode] = nodeLink
        links[iHand] = handLink
        links[iPrev] = prevLink
        
        return iNewHand
    }
    
    @inline(__always)
    private func connectExtraNext(hand iHand: Index, node iNode: Index, links: inout[Link]) -> Index {
        var handLink = links[iHand]
        var nodeLink = links[iNode]
        let iNext = handLink.next
        var nextLink = links[iNext]
        
        let count = links.count
        
        let iNewHand = count
        
        let newHandLink = Link(
            prev: iNode,
            this: iNewHand,
            next: handLink.next,
            vertex: handLink.vertex
        )
        links.append(newHandLink)

        handLink.next = iNode
        nodeLink.prev = iHand
        nodeLink.next = iNewHand
        nextLink.prev = iNewHand

        links[iNode] = nodeLink
        links[iHand] = handLink
        links[iNext] = nextLink
        
        return iNewHand
    }

    static func isTetragonContain(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint, d: IntPoint) -> Bool {
        let ab = a - b
        let bc = b - c
        let cd = c - d
        let da = d - a

        let da_ab = da.crossProduct(point: ab)
        
        // dab
        if da_ab > 0 {
            let in_bcd = isTriangleContain(p: p, a: b, b: c, c: d)
            let not_dab = isTriangleNotContain(p: p, a: d, b: a, c: b)
            return in_bcd && not_dab
        }
        
        let ab_bc = ab.crossProduct(point: bc)
        
        // abc
        if ab_bc > 0 {
            let in_cda = isTriangleContain(p: p, a: c, b: d, c: a)
            let not_abc = isTriangleNotContain(p: p, a: a, b: b, c: c)
            return in_cda && not_abc
        }
        
        let bc_cd = bc.crossProduct(point: cd)
        
        // bcd
        if bc_cd > 0 {
            let in_dab = isTriangleContain(p: p, a: d, b: a, c: b)
            let not_bcd = isTriangleNotContain(p: p, a: b, b: c, c: d)
            return in_dab && not_bcd
        }
        
        let cd_da = cd.crossProduct(point: da)
        
        // cda
        if cd_da > 0 {
            let in_abc = isTriangleContain(p: p, a: a, b: b, c: c)
            let not_cda = isTriangleNotContain(p: p, a: c, b: d, c: a)
            return in_abc && not_cda
        }

        // convex
        
        let abc = isTriangleContain(p: p, a: a, b: b, c: c)
        let cda = isTriangleContain(p: p, a: c, b: d, c: a)
        return abc || cda
    }

    private static func isTriangleContain(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let q0 = (p - b).crossProduct(point: a - b)
        let q1 = (p - c).crossProduct(point: b - c)
        let q2 = (p - a).crossProduct(point: c - a)
        
        let has_neg = q0 < 0 || q1 < 0 || q2 < 0
        let has_pos = q0 > 0 || q1 > 0 || q2 > 0
        
        return !(has_neg && has_pos)
    }
    
    private static func isTriangleNotContain(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let q0 = (p - b).crossProduct(point: a - b)
        let q1 = (p - c).crossProduct(point: b - c)
        let q2 = (p - a).crossProduct(point: c - a)
        
        let has_neg = q0 <= 0 || q1 <= 0 || q2 <= 0
        let has_pos = q0 >= 0 || q1 >= 0 || q2 >= 0
        
        return has_neg && has_pos
    }
    
}

private extension Array {
    
    @inline(__always)
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
