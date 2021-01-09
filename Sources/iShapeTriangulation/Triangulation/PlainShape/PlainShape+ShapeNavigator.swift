//
//  PlainShape+ShapeNavigator.swift
//  iGeometry
//
//  Created by Nail Sharipov on 03/10/2019.
//

import iGeometry

extension PlainShape {

    enum LinkNature: Int {
        case end
        case start
        case split
        case extra
        case merge
        case simple
    }
    
    struct ShapeNavigator {
        let pathCount: Int
        let extraCount: Int
        let links: [Link]
        let natures: [LinkNature]
        let sortIndices: [Int]
    }
    
    func createNavigator(maxEdge: Int64, extraPoints: [IntPoint]?) -> ShapeNavigator {
        let splitLayout: SplitLayout
        if maxEdge == 0 {
            splitLayout = self.plain()
        } else {
            splitLayout = self.split(maxEgeSize: maxEdge)
        }
        
        let pathCount = splitLayout.nodes.count
        
        let n: Int
        if let extraPoints = extraPoints {
            n = pathCount + extraPoints.count
        } else {
            n = pathCount
        }

        var links = Array<Link>(repeating: .empty, count: n)
        var natures = Array<LinkNature>(repeating: .simple, count: n)
        
        for layout in splitLayout.layouts {
            var prev = layout.end - 1
            var this = layout.end
            var next = layout.begin
            
            var a = splitLayout.nodes[prev]
            var b = splitLayout.nodes[this]
            var A = a.point.bitPack
            var B = b.point.bitPack
            
            while next <= layout.end {
                let c = splitLayout.nodes[next]
                let C = c.point.bitPack
                
                var nature: LinkNature = .simple
                
                let isCCW = IntTriangle.isCCW(a: a.point, b: b.point, c: c.point)
                
                if layout.isClockWise {
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

                let verNature: Vertex.Nature = b.index < self.points.count ? .origin : .extraPath
                
                links[this] = Link(prev: prev, this: this, next: next, vertex: Vertex(index: b.index, nature: verNature, point: b.point))
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
        
        if let extraPoints = extraPoints {
            for i in 0..<extraPoints.count {
                let p = extraPoints[i]
                let j = i + pathCount
                links[j] = Link(prev: j, this: j, next: j, vertex: Vertex(index: j, nature: .extraInner, point: p))
                natures[j] = .extra
            }
        }

        // sort

        var dataList = Array<SortData>(repeating: SortData(index: 0, factor: 0), count: n)
        for i in 0..<n {
            let p = links[i].vertex.point
            dataList[i] = SortData(index: i, factor: p.bitPack)
        }
        
        dataList.sort(by: {
            a, b in
            if a.factor != b.factor {
                return a.factor < b.factor
            } else {
                let nFactorA = natures[a.index].rawValue
                let nFactorB = natures[b.index].rawValue
                
                return nFactorA < nFactorB
            }
        })
        
        var indices = Array<Int>(repeating: 0, count: n)
        
        // filter same points
        var b = SortData(index: -1, factor: .min)
        var i = 0

        while i < n {
            var a = dataList[i]
            indices[i] = a.index
            if a.factor == b.factor {
                let v = links[b.index].vertex
                repeat {
                    let link = links[a.index]
                    links[a.index] = Link(prev: link.prev, this: link.this, next: link.next, vertex: Vertex(index: v.index, nature: v.nature, point: link.vertex.point))
                    i += 1
                    if i < n {
                        a = dataList[i]
                        indices[i] = a.index
                    } else {
                        break
                    }
                } while a.factor == b.factor
            }
            b = a
            i += 1
        }
        
        let extraCount = extraPoints?.count ?? 0

        return ShapeNavigator(pathCount: pathCount, extraCount: extraCount, links: links, natures: natures, sortIndices: indices)
    }
    
    private struct SortData {
        let index: Int
        let factor: Int64
    }

    private struct Node {
        let point: IntPoint
        let index: Int
    }
    
    private struct SplitLayout {
        let layouts: [Layout]
        let nodes: [Node]
    }

    private func split(maxEgeSize: Int64) -> SplitLayout {
        let originalCount = self.points.count
        
        var nodes = [Node]()
        nodes.reserveCapacity(originalCount)
        
        var layouts = [Layout]()
        layouts.reserveCapacity(originalCount)
        
        let sqrMaxSize = maxEgeSize * maxEgeSize
        
        var begin = 0
        var originalIndex = 0
        var extraIndex = originalCount

        for layout in self.layouts {
            let last = layout.end
            var a = self.points[last]
            var length = 0
            
            for i in layout.begin...last {
                let b = self.points[i]
                let dx = b.x - a.x
                let dy = b.y - a.y
                let sqrSize = dx * dx + dy * dy
                if sqrSize > sqrMaxSize {
                    let l = Int64(Double(sqrSize).squareRoot())
                    let s = Int(l / maxEgeSize)
                    let ds = Double(s)
     
                    let sx = Double(dx) / ds
                    let sy = Double(dy) / ds
                    var fx: Double = 0
                    var fy: Double = 0
                    for _ in 1..<s {
                        fx += sx
                        fy += sy
                        
                        let x = a.x + Int64(fx)
                        let y = a.y + Int64(fy)
                        nodes.append(Node(point: IntPoint(x: x, y: y), index: extraIndex))
                        extraIndex += 1
                    }
                    length += s - 1
                }
                length += 1
                nodes.append(Node(point: b, index: originalIndex))
                originalIndex += 1
                a = b
            }
            layouts.append(Layout(begin: begin, length: length, isClockWise: layout.isClockWise))
            begin += length
        }
        return SplitLayout(layouts: layouts, nodes: nodes)
    }
    
    private func plain() -> SplitLayout {
        var nodes = [Node]()
        nodes.reserveCapacity(self.points.count)
        var index = 0
        for p in self.points {
            nodes.append(Node(point: p, index: index))
            index += 1
        }

        return SplitLayout(layouts: self.layouts, nodes: nodes)
    }
}
