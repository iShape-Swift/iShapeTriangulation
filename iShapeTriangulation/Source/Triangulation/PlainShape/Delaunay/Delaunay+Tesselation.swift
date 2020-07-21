//
//  Delaunay+Tesselation.swift
//  iGeometry
//
//  Created by Nail Sharipov on 15.07.2020.
//

import Foundation
import iGeometry

public extension Delaunay {

    mutating func tessellate(maxAngle: Float, minEdge: Int64) -> [Vertex] {
        var extraPoints = [Vertex]()
        var extraPointsIndex = self.pathCount + self.extraCount
        
        var i = 0
        
        let maxCos = cos(maxAngle)
        let sqrCos = maxCos * maxCos
        let sqrMinEdge = minEdge * minEdge
        
        while i < self.triangles.count {
            let triangle = self.triangles[i]
            
            let a = triangle.vertices[0]
            let b = triangle.vertices[1]
            let c = triangle.vertices[2]

            let ab = a.point.sqrDistance(point: b.point)
            let ca = c.point.sqrDistance(point: a.point)
            let bc = b.point.sqrDistance(point: c.point)
            
            guard ab > sqrMinEdge || ca > sqrMinEdge || bc > sqrMinEdge else {
                i += 1
                continue
            }
            
            let k: Int
            let aa = Float(bc)
            let bb = Float(ca)
            let cc = Float(ab)
            let sCos: Float
            
            if ab >= bc + ca {
                // c, ab
                k = 2
                let l = (aa + bb - cc)
                sCos = l * l / (4 * aa * bb)
            } else if bc >= ca + ab {
                // a, bc
                k = 0
                let l = (bb + cc - aa)
                sCos = l * l / (4 * bb * cc)
            } else if ca >= ab + bc {
                // b, ca
                k = 1
                let l = (aa + cc - bb)
                sCos = l * l / (4 * aa * cc)
            } else {
                i += 1
                continue
            }
            
            let j = triangle.neighbors[k]
            guard j >= 0 && sCos > sqrCos else {
                i += 1
                continue
            }

            
            let p = triangle.circumscribedСenter
            let neighbor = self.triangles[j]
            
            guard neighbor.isContain(p: p) else {
                i += 1
                continue
            }
            
            let k_next = (k + 1) % 3
            let k_prev = (k + 2) % 3
            
            let l = neighbor.opposite(neighbor: i)

            let l_next = (l + 1) % 3
            let l_prev = (l + 2) % 3
            
            let vertex = Vertex(index: extraPointsIndex, point: p)
            extraPoints.append(vertex)
            
            let n = self.triangles.count
            extraPointsIndex += 1

            var t0 = triangle
            t0.vertices[k_prev] = vertex
            t0.neighbors[k_next] = n
            self.triangles[i] = t0
            assert(IntTriangle.isCCW_or_Line(a: t0.vertices[0].point, b: t0.vertices[1].point, c: t0.vertices[2].point), "Triangle's points are not clock-wise ordered")

            var t1 = neighbor
            t1.vertices[l_next] = vertex
            t1.neighbors[l_prev] = n + 1
            self.triangles[j] = t1
            assert(IntTriangle.isCCW_or_Line(a: t1.vertices[0].point, b: t1.vertices[1].point, c: t1.vertices[2].point), "Triangle's points are not clock-wise ordered")

            let t2Neighbor = triangle.neighbors[k_next]
            let t2 = Triangle(
                index: n,
                a: triangle.vertices[k],
                b: vertex,
                c: triangle.vertices[k_prev],
                bc: n + 1,
                ac: t2Neighbor,
                ab: i
            )

            if t2Neighbor >= 0 {
                self.triangles[t2Neighbor].updateOpposite(oldNeighbor: i, newNeighbor: n)
            }

            self.triangles.append(t2)

            let t3Neighbor = neighbor.neighbors[l_prev]
            let t3 = Triangle(
               index: n + 1,
               a: neighbor.vertices[l],
               b: neighbor.vertices[l_next],
               c: vertex,
               bc: n,
               ac: j,
               ab: t3Neighbor
            )

            if t3Neighbor >= 0 {
                self.triangles[t3Neighbor].updateOpposite(oldNeighbor: j, newNeighbor: n + 1)
            }

            self.triangles.append(t3)

            let minIndex = self.fix(indices: [i, j, n, n + 1])
            if minIndex < i {
                i = minIndex
            }
        }

        self.extraCount += extraPoints.count
        
        return extraPoints
    }
 
}

private extension Delaunay.Triangle {
    
    @inline(__always)
    var circumscribedСenter: IntPoint {
        let a = self.vertices[0].point
        let b = self.vertices[1].point
        let c = self.vertices[2].point
        let ax = Double(a.x)
        let ay = Double(a.y)
        let bx = Double(b.x)
        let by = Double(b.y)
        let cx = Double(c.x)
        let cy = Double(c.y)
        
        let d = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
        let aa = ax * ax + ay * ay
        let bb = bx * bx + by * by
        let cc = cx * cx + cy * cy
        let x = (aa * (by - cy) + bb * (cy - ay) + cc * (ay - by)) / d
        let y = (aa * (cx - bx) + bb * (ax - cx) + cc * (bx - ax)) / d

        return IntPoint(x: Int64(round(x)), y: Int64(round(y)))
    }

    @inline(__always)
    func isContain(p: IntPoint) -> Bool {
        let a = self.vertices[0].point
        let b = self.vertices[1].point
        let c = self.vertices[2].point
        
        let d1 = Delaunay.Triangle.sign(a: p, b: a, c: b)
        let d2 = Delaunay.Triangle.sign(a: p, b: b, c: c)
        let d3 = Delaunay.Triangle.sign(a: p, b: c, c: a)
        
        let has_neg = d1 < 0 || d2 < 0 || d3 < 0
        let has_pos = d1 > 0 || d2 > 0 || d3 > 0
        
        return !(has_neg && has_pos)
    }
    
    @inline(__always)
    private static func sign(a: IntPoint, b: IntPoint, c: IntPoint) -> Int64 {
        return (a.x - c.x) * (b.y - c.y) - (b.x - c.x) * (a.y - c.y)
    }
}
