//
//  Delaunay+Tessellation.swift
//  iGeometry
//
//  Created by Nail Sharipov on 15.07.2020.
//

import Darwin
import iGeometry

extension Delaunay {

    private struct Validator {

        static let sqrMergeCos: Float = {
            let mergeCos = cos(0.8 * Float.pi)
            return mergeCos * mergeCos
        }()
        
        private let maxArea: Float
        private let iGeom: IntGeom
        
        init(iGeom: IntGeom, maxArea: Float) {
            self.iGeom = iGeom
            self.maxArea = 2 * maxArea
        }

        @inline(__always)
        func testRegular(triangle: Triangle) -> Int {
            let a = iGeom.float(point: triangle.vertices.a.point)
            let b = iGeom.float(point: triangle.vertices.b.point)
            let c = iGeom.float(point: triangle.vertices.c.point)

            let ab = a.sqrDistance(point: b)
            let ca = c.sqrDistance(point: a)
            let bc = b.sqrDistance(point: c)

            let s0 = a.x * (c.y - b.y) + b.x * (a.y - c.y) + c.x * (b.y - a.y)
            let s1: Float
            
            let k: Int
            let sCos: Float
            
            if ab >= bc + ca {
                // c, ab
                k = 2
                let l = bc + ca - ab
                sCos = l * l / (4 * bc * ca)
                s1 = s0 / (1 - sCos)
            } else if bc >= ca + ab {
                // a, bc
                k = 0
                let l = ca + ab - bc
                sCos = l * l / (4 * ca * ab)
                s1 = s0 / (1 - sCos)
            } else if ca >= bc + ab {
                // b, ca
                k = 1
                let l = bc + ab - ca
                sCos = l * l / (4 * bc * ab)
                s1 = s0 / (1 - sCos)
            } else {
                if ab >= bc && ab >= ca {
                    k = 2
                } else if bc >= ca {
                    k = 0
                } else {
                    k = 1
                }
                s1 = s0
            }

            if s1 > maxArea {
                return k
            }

            return -1
        }
        
        @inline(__always)
        static func sqrCos(a: IntPoint, b: IntPoint, c: IntPoint) -> Float {
            let ab = a.sqrDistance(point: b)
            let ca = c.sqrDistance(point: a)
            let bc = b.sqrDistance(point: c)

            guard ab >= bc &+ ca else {
                return 0
            }
            
            let aa = Float(bc)
            let bb = Float(ca)
            let cc = Float(ab)

            let l = aa + bb - cc
            return l * l / (4 * aa * bb)
        }
    }
    
    mutating func tessellate(iGeom: IntGeom, maxArea: Float) {
        var extraPoints = [Vertex]()
        let originCount = self.points.count
        var extraPointsIndex = originCount
        
        let validator = Validator(iGeom: iGeom, maxArea: maxArea)
        
        var unprocessed = IndexBuffer(count: self.triangles.count)

        repeat {
        
            while unprocessed.hasNext {
                let i = unprocessed.next()
                let triangle = self.triangles[i]

                let k = validator.testRegular(triangle: triangle)

                guard k >= 0 else {
                    continue
                }
                
                let nIx = triangle.neighbors[k]
                
                guard nIx >= 0 else {
                    continue
                }

                let p = triangle.circumscribedCenter

                let neighbor = self.triangles[nIx]
                guard neighbor.isContain(p: p) else {
                    continue
                }
                
                let j = neighbor.opposite(neighbor: triangle.index)
                let j_next = (j &+ 1) % 3
                let j_prev = (j &+ 2) % 3

                if neighbor.neighbors[j_next] == -1 || neighbor.neighbors[j_prev] == -1 {
                    let nextCos = Validator.sqrCos(a: neighbor.vertices[j_prev].point, b: neighbor.vertices[j].point, c: p)
                    if nextCos > Validator.sqrMergeCos {
                        continue
                    }
                    
                    let prevCos = Validator.sqrCos(a: neighbor.vertices[j].point, b: neighbor.vertices[j_next].point, c: p)
                    if prevCos > Validator.sqrMergeCos {
                        continue
                    }
                }

                let k_next = (k &+ 1) % 3
                let k_prev = (k &+ 2) % 3
                
                let l = neighbor.opposite(neighbor: i)

                let l_next = (l &+ 1) % 3
                let l_prev = (l &+ 2) % 3
                
                let vertex = Vertex(index: extraPointsIndex, nature: .extraTessellated, point: p)
                extraPoints.append(vertex)
                
                let n = self.triangles.count
                extraPointsIndex &+= 1

                var t0 = triangle
                t0.vertices[k_prev] = vertex
                t0.neighbors[k_next] = n
                self.triangles[i] = t0
                assert(IntTriangle.isCCW_or_Line(a: t0.vertices.a.point, b: t0.vertices.b.point, c: t0.vertices.c.point), "Triangle's points are not clock-wise ordered")
                unprocessed.add(index: t0.index)
                
                var t1 = neighbor
                t1.vertices[l_next] = vertex
                t1.neighbors[l_prev] = n &+ 1
                self.triangles[nIx] = t1
                assert(IntTriangle.isCCW_or_Line(a: t1.vertices.a.point, b: t1.vertices.b.point, c: t1.vertices.c.point), "Triangle's points are not clock-wise ordered")
                unprocessed.add(index: t1.index)
                
                let t2Neighbor = triangle.neighbors[k_next]
                let t2 = Triangle(
                    index: n,
                    a: triangle.vertices[k],
                    b: vertex,
                    c: triangle.vertices[k_prev],
                    bc: n &+ 1,
                    ac: t2Neighbor,
                    ab: i
                )

                if t2Neighbor >= 0 {
                    self.triangles[t2Neighbor].updateOpposite(oldNeighbor: i, newNeighbor: n)
                }

                self.triangles.append(t2)
                unprocessed.add(index: t2.index)

                let t3Neighbor = neighbor.neighbors[l_prev]
                let t3 = Triangle(
                   index: n &+ 1,
                   a: neighbor.vertices[l],
                   b: neighbor.vertices[l_next],
                   c: vertex,
                   bc: n,
                   ac: nIx,
                   ab: t3Neighbor
                )

                if t3Neighbor >= 0 {
                    self.triangles[t3Neighbor].updateOpposite(oldNeighbor: nIx, newNeighbor: n &+ 1)
                }

                self.triangles.append(t3)
                unprocessed.add(index: t3.index)

                self.fix(indices: [i, nIx, n, n &+ 1], indexBuffer: &unprocessed)
            }
        } while unprocessed.hasNext
        
        self.points += extraPoints.map({ $0.point })
    }
}

private extension Delaunay.Triangle {
    
    @inline(__always)
    var circumscribedCenter: IntPoint {
        let a = self.vertices.a.point
        let b = self.vertices.b.point
        let c = self.vertices.c.point
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

        return IntPoint(x: Int64(x.rounded(.toNearestOrAwayFromZero)), y: Int64(y.rounded(.toNearestOrAwayFromZero)))
    }
    
    @inline(__always)
    private var area: Int64 {
        let a = self.vertices.a.point
        let b = self.vertices.b.point
        let c = self.vertices.c.point
        return (a.x &* (c.y &- b.y) &+ b.x &* (a.y &- c.y) &+ c.x &* (b.y &- a.y)) >> 1
    }

    @inline(__always)
    func isContain(p: IntPoint) -> Bool {
        let a = self.vertices.a.point
        let b = self.vertices.b.point
        let c = self.vertices.c.point
        
        let d1 = Delaunay.Triangle.sign(a: p, b: a, c: b)
        let d2 = Delaunay.Triangle.sign(a: p, b: b, c: c)
        let d3 = Delaunay.Triangle.sign(a: p, b: c, c: a)
        
        let has_neg = d1 < 0 || d2 < 0 || d3 < 0
        let has_pos = d1 > 0 || d2 > 0 || d3 > 0
        
        return !(has_neg && has_pos)
    }
    
    @inline(__always)
    private static func sign(a: IntPoint, b: IntPoint, c: IntPoint) -> Int64 {
        (a.x &- c.x) &* (b.y &- c.y) &- (b.x &- c.x) &* (a.y &- c.y)
    }
}
