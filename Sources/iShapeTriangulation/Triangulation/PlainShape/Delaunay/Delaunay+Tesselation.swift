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
        
        private let sqrMaxCos: Float
        private let sqrMergeCos: Float
        private let sqrMinEdge: Int64
        
        init(minEdge: Int64, maxAngle: Float, mergeAngle: Float) {
            let maxCos = cos(maxAngle)
            self.sqrMaxCos = maxCos * maxCos
            
            let mergeCos = cos(mergeAngle)
            self.sqrMergeCos = mergeCos * mergeCos

            self.sqrMinEdge = minEdge * minEdge
        }

        @inline(__always)
        func testRegular(triangle: Triangle) -> Int {
            let a = triangle.vertices[0]
            let b = triangle.vertices[1]
            let c = triangle.vertices[2]

            let ab = a.point.sqrDistance(point: b.point)
            let ca = c.point.sqrDistance(point: a.point)
            let bc = b.point.sqrDistance(point: c.point)
            
            guard ab > sqrMinEdge || ca > sqrMinEdge || bc > sqrMinEdge else {
                return -1
            }
            
            let k: Int
            let aa = Float(bc)
            let bb = Float(ca)
            let cc = Float(ab)
            let sCos: Float
            
            if ab >= bc + ca {
                // c, ab
                k = 2
                let l = aa + bb - cc
                sCos = l * l / (4 * aa * bb)
            } else if bc >= ca + ab {
                // a, bc
                k = 0
                let l = bb + cc - aa
                sCos = l * l / (4 * bb * cc)
            } else if ca >= bc + ab {
                // b, ca
                k = 1
                let l = aa + cc - bb
                sCos = l * l / (4 * aa * cc)
            } else {
                return -1
            }
            
            if sCos > self.sqrMaxCos {
                return k
            }
            
            return -1
        }
    
        @inline(__always)
        func testMerge(triangle: Triangle) -> Int {
            let a = triangle.vertices[0]
            let b = triangle.vertices[1]
            let c = triangle.vertices[2]

            let ab = a.point.sqrDistance(point: b.point)
            let ca = c.point.sqrDistance(point: a.point)
            let bc = b.point.sqrDistance(point: c.point)
            
            let k: Int
            let aa = Float(bc)
            let bb = Float(ca)
            let cc = Float(ab)
            let sCos: Float
            
            if ab >= bc + ca {
                // c, ab
                k = 2
                let l = aa + bb - cc
                sCos = l * l / (4 * aa * bb)
            } else if bc >= ca + ab {
                // a, bc
                k = 0
                let l = bb + cc - aa
                sCos = l * l / (4 * bb * cc)
            } else if ca >= bc + ab {
                // b, ca
                k = 1
                let l = aa + cc - bb
                sCos = l * l / (4 * aa * cc)
            } else {
                return -1
            }
            
            if sCos > self.sqrMergeCos {
                return k
            }
            
            return -1
        }
    }
    
    
    mutating func tessellate(minEdge: Int64, maxAngle: Float, mergeAngle: Float) -> [Vertex] {
        let isAnglesInRange = .pi > maxAngle && 0.5 * .pi <= maxAngle && .pi > mergeAngle && 0.5 * .pi <= mergeAngle
        assert(isAnglesInRange, "angles must be in range 0.5*pi..<pi")
        guard isAnglesInRange else {
            return []
        }
        
        var extraPoints = [Vertex]()
        let initExtraCount = self.pathCount + self.extraCount
        var extraPointsIndex = initExtraCount
        
        let validator = Validator(minEdge: minEdge, maxAngle: maxAngle, mergeAngle: mergeAngle)
        
        var unprocessed = IndexBuffer(count: self.triangles.count)

        repeat {
        
            while unprocessed.hasNext {
                let i = unprocessed.next()
                let triangle = self.triangles[i]

                let k = validator.testRegular(triangle: triangle)

                guard k >= 0 else {
                    continue
                }
                
                let j = triangle.neighbors[k]
                
                guard j >= 0 else {
                    continue
                }
                
                let p = triangle.circumscribedCenter
//                let p = triangle.extraPoint(index: k)
                let neighbor = self.triangles[j]
                
                guard neighbor.isContain(p: p) else {
                    continue
                }
                
                let k_next = (k + 1) % 3
                let k_prev = (k + 2) % 3
                
                let l = neighbor.opposite(neighbor: i)

                let l_next = (l + 1) % 3
                let l_prev = (l + 2) % 3
                
                let vertex = Vertex(index: extraPointsIndex, isExtra: true, point: p)
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
                unprocessed.add(index: t2.index)

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
                unprocessed.add(index: t3.index)

                self.fix(indices: [i, j, n, n + 1], indexBuffer: &unprocessed)
            }
            
            // test all bordered triangles

            var i = 0
            
            while i < triangles.count {
                let triangle = self.triangles[i]

                let k = validator.testMerge(triangle: triangle)

                guard k >= 0 else {
                    i += 1
                    continue
                }
                
                let j = triangle.neighbors[k]
                
                guard j < 0 else {
                    i += 1
                    continue
                }

                let k_next = (k + 1) % 3
                let k_prev = (k + 2) % 3

                let aVertex = triangle.vertices[k]

                let isPathCount = aVertex.index < (self.pathCount + self.extraCount)

                // is this vertex a new Vertex (added while tessellating)
                if !isPathCount {
                    let last = triangle.neighbors[k_prev]
                    var next = triangle.neighbors[k_next]
                    
                    guard last >= 0 && next >= 0 else {
                        i += 1
                        continue
                    }

                    var prevIndex = triangle.index
                    var family = [Int]()
                    family.reserveCapacity(8)
                    while next >= 0 && next != last {
                        family.append(next)
                        let nextTriangle = self.triangles[next]
                        next = nextTriangle.adjacentNeighbor(vertex: aVertex.index, neighbor: prevIndex)
                        prevIndex = nextTriangle.index
                    }

                    let isMovable = next == last
                    if isMovable {
                        family.append(next)
                        let a = aVertex.point
                        let b = triangle.vertices[k_next].point
                        let c = triangle.vertices[k_prev].point
                        let ca = a - c
                        let cb = b - c

                        let nAB = Delaunay.projectionAonB(a: ca, b: cb)
                        let p = c + nAB
                        let vIx = aVertex.index - initExtraCount
                        let newVertex = Vertex(index: aVertex.index, isExtra: false, point: p)
                        extraPoints[vIx] = newVertex

                        for index in family {
                            self.triangles[index].update(vertex: newVertex)
                        }

                        let first = family[0]
                        self.triangles[first].updateOpposite(oldNeighbor: triangle.index, newNeighbor: -1)
                        self.triangles[last].updateOpposite(oldNeighbor: triangle.index, newNeighbor: -1)

                        if self.triangles.count - 1 != triangle.index {
                            let lastTriangle = self.triangles[self.triangles.count - 1]

                            let nA = lastTriangle.neighbors[0]
                            if nA >= 0 {
                                self.triangles[nA].updateOpposite(oldNeighbor: lastTriangle.index, newNeighbor: triangle.index)
                            }
                            let nB = lastTriangle.neighbors[1]
                            if nB >= 0 {
                                self.triangles[nB].updateOpposite(oldNeighbor: lastTriangle.index, newNeighbor: triangle.index)
                            }
                            let nC = lastTriangle.neighbors[2]
                            if nC >= 0 {
                                self.triangles[nC].updateOpposite(oldNeighbor: lastTriangle.index, newNeighbor: triangle.index)
                            }
                            
                            self.triangles[triangle.index] = Triangle(
                                index: triangle.index,
                                a: lastTriangle.vertices[0],
                                b: lastTriangle.vertices[1],
                                c: lastTriangle.vertices[2],
                                bc: nA,
                                ac: nB,
                                ab: nC
                            )
                            
                            if let index = family.firstIndex(where: { $0 == lastTriangle.index }) {
                                family[index] = triangle.index
                            }
                        }

                        self.triangles.removeLast()
                        
                        unprocessed.decrease()
                        
                        self.fix(indices: family, indexBuffer: &unprocessed)
                    }
                }
                
                i += 1
            } // while

        } while unprocessed.hasNext
        
        self.extraCount += extraPoints.count
        
        return extraPoints
    }
    
    private static func projectionAonB(a: IntPoint, b: IntPoint) -> IntPoint {
        let k = Double(a.x * b.x + a.y * b.y) / Double(b.x * b.x + b.y * b.y)
        let x = Int64(k * Double(b.x))
        let y = Int64(k * Double(b.y))
        return IntPoint(x: x, y: y)
    }

}

private extension Delaunay.Triangle {
    
    @inline(__always)
    var circumscribedCenter: IntPoint {
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

        return IntPoint(x: Int64(x.rounded(.toNearestOrAwayFromZero)), y: Int64(y.rounded(.toNearestOrAwayFromZero)))
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
    
    @inline(__always)
    func extraPoint(index: Int) -> IntPoint {
        let a = self.vertices[index].point
        let b = self.vertices[(index + 2) % 3].point
        let c = self.vertices[(index + 1) % 3].point

        
        let ab = a - b
        let ca = c - a
        if ab.magnitude > ca.magnitude {
            let r = a + ca.ccwRotate60
            return r
        } else {
            let r = a - ab.cwRotate60
            return r
        }
        
    }
    
#if DEBUG
    func test_IsCCW_or_Line() {
        let a = self.vertices[0].point
        let b = self.vertices[1].point
        let c = self.vertices[2].point
        assert(IntTriangle.isCCW_or_Line(a: a, b: b, c: c), "Triangle's points are not clock-wise ordered")
    }
#endif
}

private extension IntPoint {
    var magnitude: Int64 {
        return x * x + y * y
    }

    private static let sin60: Double = 0.5 * Double(3).squareRoot()
    private static let cos60: Double = 0.5
    
    var cwRotate60: IntPoint {
        let dx = Double(self.x)
        let dy = Double(self.y)
        let x = dx * IntPoint.cos60 - dy * IntPoint.sin60
        let y = dx * IntPoint.sin60 + dy * IntPoint.cos60

        return IntPoint(x: Int64(x.rounded(.toNearestOrAwayFromZero)), y: Int64(y.rounded(.toNearestOrAwayFromZero)))
    }
    
    var ccwRotate60: IntPoint {
        let dx = Double(self.x)
        let dy = Double(self.y)
        
        let x = dx * IntPoint.cos60 + dy * IntPoint.sin60
        let y = -dx * IntPoint.sin60 + dy * IntPoint.cos60
        return IntPoint(x: Int64(x.rounded(.toNearestOrAwayFromZero)), y: Int64(y.rounded(.toNearestOrAwayFromZero)))
    }
    
    @inline(__always)
    func center(point: IntPoint) -> IntPoint {
        return IntPoint(x: (self.x + point.x) / 2, y: (self.y + point.y) / 2)
    }
}
