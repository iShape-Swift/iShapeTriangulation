//
//  Delaunay.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

struct Delaunay {

    struct Triangle {
        
        let index: Index
        
        // a(0), b(1), c(2)
        var vertices = Array<Vertex>(repeating: .empty, count: 3)
        
        // BC - a(0), AC - b(1), AB - c(2)
        var neighbors = Array<Index>(repeating: -1, count: 3)

        init() {
            self.index = -1
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex) {
            self.index = index
            self.vertices[0] = a
            self.vertices[1] = b
            self.vertices[2] = c
            #if iShapeTest
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
            #endif
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, bc: Index) {
            self.index = index
            self.vertices[0] = a
            self.vertices[1] = b
            self.vertices[2] = c
            self.neighbors[0] = bc
            #if iShapeTest
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
            #endif
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, ac: Index, ab: Index) {
            self.index = index
            self.vertices[0] = a
            self.vertices[1] = b
            self.vertices[2] = c
            self.neighbors[1] = ac
            self.neighbors[2] = ab
            #if iShapeTest
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
            #endif
        }
        
        fileprivate func opposite(neighbor: Index) -> Index {
            for i in 0...2 {
                if self.neighbors[i] == neighbor {
                    return i
                }
            }
            #if iShapeTest
            assertionFailure("Neighbor is not present")
            #endif
            return -1
        }
        
        fileprivate mutating func updateOpposite(oldNeighbor: Index, newNeighbor: Index) {
            for i in 0...2 {
                if self.neighbors[i] == oldNeighbor {
                    self.neighbors[i] = newNeighbor
                    return
                }
            }
            #if iShapeTest
            assertionFailure("Neighbor is not present")
            #endif
        }
        
        fileprivate func neighbor(vertex: Index) -> Index {
            for i in 0...2 {
                if self.vertices[i].index == vertex {
                    return self.neighbors[i]
                }
            }
            #if iShapeTest
            assertionFailure("Point is not present")
            #endif
            return -1
        }
    }
    
    private var triangles: [Triangle]
    
    var indices: [Int] {
        let n = triangles.count
        var result = Array<Int>(repeating: -1, count: 3 * n)
        var i = 0
        var j = 0
        repeat {
            let triangle = self.triangles[i]
            result[j] = triangle.vertices[0].index
            result[j + 1] = triangle.vertices[1].index
            result[j + 2] = triangle.vertices[2].index
            
            j += 3
            i += 1
        } while i < n
        
        return result
    }
    
    init(triangles: [Triangle]) {
        self.triangles = triangles
    }
    
    mutating func build() {
        let count = triangles.count
        var visitMarks = Array<Bool>(repeating: false, count: count)
        var visitIndex = 0
        
        var origin = Array<Int>()
        origin.reserveCapacity(4)
        
        var buffer = Array<Int>()
        buffer.reserveCapacity(4)
        
        origin.append(0)
        
        while origin.count > 0 {
            buffer.removeAll(keepingCapacity: true)
            for i in origin {
                var triangle = self.triangles[i]
                visitMarks[i] = true
                for k in 0...2 {
                    let neighborIndex = triangle.neighbors[k]
                    if neighborIndex >= 0 {
                        var neighbor = triangles[neighborIndex]
                        if self.swap(abc: triangle, pbc: neighbor) {
                            
                            triangle = self.triangles[triangle.index]
                            neighbor = self.triangles[neighbor.index]
                            
                            for j in 0...2 {
                                let ni = triangle.neighbors[j]
                                if ni >= 0 && ni != neighbor.index {
                                    buffer.append(ni)
                                }
                            }

                            for j in 0...2 {
                                let ni = neighbor.neighbors[j]
                                if ni >= 0 && ni != triangle.index {
                                    buffer.append(ni)
                                }
                            }
                        }
                    }
                }
            }
            if buffer.isEmpty && visitIndex < count {
                visitIndex &+= 1
                while visitIndex < count {
                    if visitMarks[visitIndex] == false {
                        buffer.append(visitIndex)
                        break
                    }
                    visitIndex &+= 1
                }   
            }
            origin = buffer
        }
    }
    
    private mutating func swap(abc: Triangle, pbc: Triangle) -> Bool {
        let pi = pbc.opposite(neighbor: abc.index)
        let p = pbc.vertices[pi]
        
        let ai = abc.opposite(neighbor: pbc.index)
        let bi = (ai + 1) % 3
        let ci = (ai + 2) % 3
        
        let a = abc.vertices[ai]  // opposite a-p
        let b = abc.vertices[bi]  // edge bc
        let c = abc.vertices[ci]
        
        let isPrefect = Delaunay.isPrefect(p: p.point, a: c.point, b: a.point, c: b.point)
        
        if isPrefect {
            return false
        } else {
            let isABP_CCW = IntTriangle.isCCW(a: a.point, b: b.point, c: p.point)
            
            let bp = pbc.neighbor(vertex: c.index)
            let cp = pbc.neighbor(vertex: b.index)
            let ab = abc.neighbors[ci]
            let ac = abc.neighbors[bi]

            // abc -> abp
            var abp: Triangle
            
            // pbc -> acp
            var acp: Triangle

            if isABP_CCW {
                abp = Triangle(
                    index: abc.index,
                    a: a,
                    b: b,
                    c: p
                )
                
                abp.neighbors[0] = bp           // a - bp
                abp.neighbors[1] = pbc.index    // b - ap
                abp.neighbors[2] = ab           // p - ab

                acp = Triangle(
                    index: pbc.index,
                    a: a,
                    b: p,
                    c: c
                )

                acp.neighbors[0] = cp           // a - cp
                acp.neighbors[1] = ac           // p - ac
                acp.neighbors[2] = abc.index    // c - ap
            } else {
                abp = Triangle(
                    index: abc.index,
                    a: a,
                    b: p,
                    c: b
                )
                
                abp.neighbors[0] = bp           // a - bp
                abp.neighbors[1] = ab           // p - ab
                abp.neighbors[2] = pbc.index    // b - ap

                acp = Triangle(
                    index: pbc.index,
                    a: a,
                    b: c,
                    c: p
                )

                acp.neighbors[0] = cp           // a - cp
                acp.neighbors[1] = abc.index    // c - ap
                acp.neighbors[2] = ac           // p - ac
            }
            
            // fix neighbor's link
            // ab, cp did't change neighbor
            // bc -> ap, so no changes
            
            // ac (abc) is now edge of acp
            let acIndex = abc.neighbors[bi] // b - angle
            if acIndex >= 0 {
                var neighbor = self.triangles[acIndex]
                neighbor.updateOpposite(oldNeighbor: abc.index, newNeighbor: acp.index)
                self.triangles[acIndex] = neighbor
            }

            // bp (pbc) is now edge of abp
            let bpIndex = pbc.neighbor(vertex: c.index) // c - angle
            if bpIndex >= 0 {
                var neighbor = self.triangles[bpIndex]
                neighbor.updateOpposite(oldNeighbor: pbc.index, newNeighbor: abp.index)
                self.triangles[bpIndex] = neighbor
            }
            
            self.triangles[abc.index] = abp
            self.triangles[pbc.index] = acp
            
            return true
        }
    }
    
    private static func isPrefect(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let isPABccw = IntTriangle.isCCW(a: p, b: a, c: b)
        let isPCBccw = IntTriangle.isCCW(a: p, b: c, c: b)
        if isPABccw != isPCBccw {
            return Delaunay.isDelaunay(p: p, a: a, b: b, c: c)
        } else {
            return true
        }
    }
    
    // @inline(__always)
    private static func isDelaunay(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        
        let bax = a.x - b.x
        let bay = a.y - b.y
        let bcx = c.x - b.x
        let bcy = c.y - b.y
        
        let pcx = c.x - p.x
        let pcy = c.y - p.y
        let pax = a.x - p.x
        let pay = a.y - p.y
        
        let cosAlfa = pax * pcx + pay * pcy
        let cosBeta = bax * bcx + bay * bcy
        
        if cosAlfa < 0 && cosBeta < 0 {
            return false
        } else {
            let sinAlfa = pay * pcx - pax * pcy
            let sinBeta = bax * bcy - bay * bcx
            
            return Float(sinAlfa) * Float(cosBeta) + Float(cosAlfa) * Float(sinBeta) >= -0.00001
        }
    }
}

#if iShapeTest

extension Delaunay {
    
    struct Circle {
        let center: Point
        let radius: Float
    }

    public static func circumscribedСircleCenter(a: Point, b: Point, c: Point) -> Circle {
        let d = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
        let x = ((a.x * a.x + a.y * a.y) * (b.y - c.y) + (b.x * b.x + b.y * b.y) * (c.y - a.y) + (c.x * c.x + c.y * c.y) * (a.y - b.y)) / d
        let y = ((a.x * a.x + a.y * a.y) * (c.x - b.x) + (b.x * b.x + b.y * b.y) * (a.x - c.x) + (c.x * c.x + c.y * c.y) * (b.x - a.x)) / d
        
        let r = sqrt((a.x - x) * (a.x - x) + (a.y - y) * (a.y - y))
        
        return Circle(center: Point(x: x, y: y), radius: r)
    }
    
    public static func verefy(p: IntPoint, a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        return Delaunay.isPrefect(p: p, a: a, b: b, c: c)
    }
}
#endif
