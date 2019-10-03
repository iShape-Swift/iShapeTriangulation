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
        case merge
        case simple
    }
    
    struct ShapeNavigator {
        let iPoints: [IntPoint]
        let links: [Link]
        let natures: [LinkNature]

        private struct SortData {
            let index: Int
            let factor: Int64
        }
        
        var sortIndices: [Int] {
            let n = self.iPoints.count
            var dataList = Array<SortData>(repeating: SortData(index: 0, factor: 0), count: n)
            var i = 0
            while i < n {
                let p = self.iPoints[i]
                dataList[i] = SortData(index: i, factor: p.bitPack)
                i += 1
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
            i = 0
            while i < n {
                indices[i] = dataList[i].index
                i += 1
            }

            return indices
        }
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
        
        return ShapeNavigator(iPoints: iPoints, links: links, natures: natures)
    }
    
    private static func isCCW(a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let m0 = (c.y - a.y) * (b.x - a.x)
        let m1 = (b.y - a.y) * (c.x - a.x)
        
        return m0 < m1
    }
}
