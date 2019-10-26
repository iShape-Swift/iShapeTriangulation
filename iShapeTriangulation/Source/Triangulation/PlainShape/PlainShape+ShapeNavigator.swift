//
//  PlainShape+ShapeNavigator.swift
//  iGeometry
//
//  Created by Nail Sharipov on 03/10/2019.
//

import iGeometry

extension PlainShape {

    enum LinkNature: Int {
        case end = 0
        case start = 1
        case split = 2
        case merge = 3
        case simple = 4
    }
    
    struct ShapeNavigator {
        let iPoints: [IntPoint]
        let links: [Link]
        let natures: [LinkNature]
        let sortIndices: [Int]
    }
    
    
    var navigator: ShapeNavigator {
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
        
        // sort

        var dataList = Array<SortData>(repeating: SortData(index: 0, factor: 0, nature: 0), count: n)
        for i in 0..<n {
            let p = iPoints[i]
            dataList[i] = SortData(index: i, factor: p.bitPack, nature: natures[i].rawValue)
        }
        
        dataList.sort(by: {
            a, b in
            if a.factor != b.factor {
                return a.factor < b.factor
            } else if a.nature != b.nature {
                return a.nature < b.nature
            } else {
                return a.index < b.index
            }
        })
        
        var indices = Array<Int>(repeating: 0, count: n)
        var x1 = SortData(index: -1, factor: .min, nature: .min)
        var i = 0
        
        // filter same points
        while i < n {
            var x0 = dataList[i]
            indices[i] = x0.index
            if x0.factor == x1.factor {
                let index = links[x1.index].vertex.index
                repeat {
                    let link = links[x0.index]
                    links[x0.index] = Link(prev: link.prev, this: link.this, next: link.next, vertex: Vertex(index: index, point: link.vertex.point))
                    i += 1
                    if i < n {
                        x0 = dataList[i]
                        indices[i] = x0.index
                    } else {
                        break
                    }
                } while x0.factor == x1.factor
            }
            x1 = x0
            i += 1
        }

        return ShapeNavigator(iPoints: iPoints, links: links, natures: natures, sortIndices: indices)
    }
    
    private struct SortData {
        let index: Int
        let factor: Int64
        let nature: Int
    }

    private static func isCCW(a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let m0 = (c.y - a.y) * (b.x - a.x)
        let m1 = (b.y - a.y) * (c.x - a.x)
        
        return m0 < m1
    }
}
