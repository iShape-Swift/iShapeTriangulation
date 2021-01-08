//
//  Delaunay.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

#if DEBUG
import Foundation
#endif

import iGeometry

public struct Delaunay {

    public internal (set) var points: [IntPoint]
    var triangles: [Triangle]
    
    init(points: [IntPoint], triangles: [Triangle]) {
        self.points = points
        self.triangles = triangles
    }
    
    mutating func build() {
        let count = triangles.count
        var visitMarks = Array<Bool>(repeating: false, count: count)
        var visitIndex = 0

        var origin = [0]
        origin.reserveCapacity(16)

        var buffer = Array<Int>()
        buffer.reserveCapacity(16)

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
                            
                            let tna = triangle.neighbors.a
                            if tna >= 0 && tna != neighbor.index {
                                buffer.append(tna)
                            }
                            
                            let tnb = triangle.neighbors.b
                            if tnb >= 0 && tnb != neighbor.index {
                                buffer.append(tnb)
                            }
                            
                            let tnc = triangle.neighbors.c
                            if tnc >= 0 && tnc != neighbor.index {
                                buffer.append(tnc)
                            }
                            
                            let nna = neighbor.neighbors.a
                            if nna >= 0 && nna != triangle.index {
                                buffer.append(nna)
                            }
                            
                            let nnb = neighbor.neighbors.b
                            if nnb >= 0 && nnb != triangle.index {
                                buffer.append(nnb)
                            }
                            
                            let nnc = neighbor.neighbors.c
                            if nnc >= 0 && nnc != triangle.index {
                                buffer.append(nnc)
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
    
    mutating func fix(indices: [Int], indexBuffer: inout IndexBuffer) {
        var origin = indices

        var buffer = Array<Int>()
        buffer.reserveCapacity(16)

        while origin.count > 0 {
            buffer.removeAll(keepingCapacity: true)
            for i in origin {
                var triangle = self.triangles[i]
                for k in 0...2 {
                    let neighborIndex = triangle.neighbors[k]
                    if neighborIndex >= 0 {
                        var neighbor = triangles[neighborIndex]
                        if self.swap(abc: triangle, pbc: neighbor) {
                            indexBuffer.add(index: triangle.index)
                            indexBuffer.add(index: neighbor.index)
                            
                            triangle = self.triangles[triangle.index]
                            neighbor = self.triangles[neighbor.index]

                            let tna = triangle.neighbors.a
                            if tna >= 0 && tna != neighbor.index {
                                buffer.append(tna)
                            }
                            
                            let tnb = triangle.neighbors.b
                            if tnb >= 0 && tnb != neighbor.index {
                                buffer.append(tnb)
                            }
                            
                            let tnc = triangle.neighbors.c
                            if tnc >= 0 && tnc != neighbor.index {
                                buffer.append(tnc)
                            }
                            
                            let nna = neighbor.neighbors.a
                            if nna >= 0 && nna != triangle.index {
                                buffer.append(nna)
                            }
                            
                            let nnb = neighbor.neighbors.b
                            if nnb >= 0 && nnb != triangle.index {
                                buffer.append(nnb)
                            }
                            
                            let nnc = neighbor.neighbors.c
                            if nnc >= 0 && nnc != triangle.index {
                                buffer.append(nnc)
                            }
                        }
                    }
                }
            }
            origin = buffer
        }
    }
    
    @inline(__always)
    private mutating func swap(abc: Triangle, pbc: Triangle) -> Bool {
        let pi = pbc.opposite(neighbor: abc.index)
        let p = pbc.vertices[pi]
        
        let ai: Int
        let bi: Int
        let ci: Int
        let a: Vertex  // opposite a-p
        let b: Vertex  // edge bc
        let c: Vertex
        
        ai = abc.opposite(neighbor: pbc.index)
        switch ai {
        case 0:
            bi = 1
            ci = 2
            a = abc.vertices.a
            b = abc.vertices.b
            c = abc.vertices.c
        case 1:
            bi = 2
            ci = 0
            a = abc.vertices.b
            b = abc.vertices.c
            c = abc.vertices.a
        default:
            bi = 0
            ci = 1
            a = abc.vertices.c
            b = abc.vertices.a
            c = abc.vertices.b
        }
        
        let isPrefect = Delaunay.isDelaunay(p0: p.point, p1: c.point, p2: a.point, p3: b.point)

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
                    c: p,
                    bc: bp,                     // a - bp
                    ac: pbc.index,              // p - ap
                    ab: ab                      // b - ab
                )

                acp = Triangle(
                    index: pbc.index,
                    a: a,
                    b: p,
                    c: c,
                    bc: cp,                     // a - cp
                    ac: ac,                     // p - ac
                    ab: abc.index               // b - ap
                )
            } else {
                abp = Triangle(
                    index: abc.index,
                    a: a,
                    b: p,
                    c: b,
                    bc: bp,                     // a - bp
                    ac: ab,                     // p - ab
                    ab: pbc.index               // b - ap
                )

                acp = Triangle(
                    index: pbc.index,
                    a: a,
                    b: c,
                    c: p,
                    bc: cp,                     // a - cp
                    ac: abc.index,              // p - ap
                    ab: ac                      // b - ac
                )
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
    
    @inline(__always)
    static func isDelaunay(p0: IntPoint, p1: IntPoint, p2: IntPoint, p3: IntPoint) -> Bool {
//        #if DEBUG
//        self.debugDelaunay(p0: p0, p1: p1, p2: p2, p3: p3)
//        #endif
        
        let x01 = p0.x &- p1.x
        let x03 = p0.x &- p3.x
        let x12 = p1.x &- p2.x
        let x32 = p3.x &- p2.x
        
        let y01 = p0.y &- p1.y
        let y03 = p0.y &- p3.y
        let y12 = p1.y &- p2.y
        let y23 = p2.y &- p3.y
        
        let cosA = x01 &* x03 &+ y01 &* y03
        let cosB = x12 &* x32 &- y12 &* y23
        
        if cosA < 0 && cosB < 0 {
            return false
        }
        
        if cosA >= 0 && cosB >= 0 {
            return true
        }
        
        // we can not just compare
        // sinA * cosB + cosA * sinB ? 0
        // cause we need weak Delaunay condition
        
        let sinA = x01 &* y03 &- x03 &* y01
        let sinB = x12 &* y23 &+ x32 &* y12

        let sl01 = x01 &* x01 &+ y01 &* y01
        let sl03 = x03 &* x03 &+ y03 &* y03
        let sl12 = x12 &* x12 &+ y12 &* y12
        let sl23 = x32 &* x32 &+ y23 &* y23
        
        let max0 = Double(sl01 > sl03 ? sl01 : sl03)
        let max1 = Double(sl12 > sl23 ? sl12 : sl23)
        
        
        let dSinA = Double(sinA)
        let dCosA = Double(cosA)
        let dSinB = Double(sinB)
        let dCosB = Double(cosB)

        let sinAB = (dSinA * dCosB + dCosA * dSinB) / (max0 * max1)

        return sinAB < 0.001
    }
    
    #if DEBUG
        // P, C, A, B
        private static func debugDelaunay(p0: IntPoint, p1: IntPoint, p2: IntPoint, p3: IntPoint) {
            let p = IntGeom.defGeom.float(point: p0)
            let c = IntGeom.defGeom.float(point: p1)
            let a = IntGeom.defGeom.float(point: p2)
            let b = IntGeom.defGeom.float(point: p3)
            
            let A = (b - c).length
            let B = (c - a).length
            let C = (a - b).length
            
            let CP = (p - c).length
            let BP = (p - b).length

            // CPB
            let cos_alpha = (BP * BP + CP * CP - A * A) / (2 * BP * CP)
            
            // CAB
            let cos_beta = (B * B + C * C - A * A) / (2 * B * C)
            
            let toAngle = 180 / Float.pi
            let alpha = acos(cos_alpha)*toAngle
            let beta = acos(cos_beta)*toAngle
            let al = String(format: "%.2f", alpha)
            let be = String(format: "%.2f", beta)
            let su = String(format: "%.2f", beta + alpha)
            
            print("alpha: \(al), beta: \(be), sum: \(su)")
        }

    #endif
}
#if DEBUG

private extension Point {
    
    var length: Float {
        return (x * x + y * y).squareRoot()
    }
}

private func +(left: Point, right: Point) -> Point {
    return Point(x: left.x + right.x, y: left.y + right.y)
}

private func -(left: Point, right: Point) -> Point {
    return Point(x: left.x - right.x, y: left.y - right.y)
}

private func *(left: Float, right: Point) -> Point {
    return Point(x: left * right.x, y: left * right.y)
}

private func /(left: Point, right: Float) -> Point {
    return Point(x: left.x / right, y: left.y / right)
}
#endif
