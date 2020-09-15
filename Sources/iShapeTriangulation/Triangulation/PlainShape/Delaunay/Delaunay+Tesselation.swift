//
//  Delaunay+Tessellation.swift
//  iGeometry
//
//  Created by Nail Sharipov on 15.07.2020.
//

import Darwin
import iGeometry

public extension Delaunay {

    mutating func tessellate(maxAngle: Float, minEdge: Int64) -> [Vertex] {
        guard .pi > maxAngle && 0.5 * .pi <= maxAngle else {
            return []
        }
        var extraPoints = [Vertex]()
        let initExtraCount = self.pathCount + self.extraCount
        var extraPointsIndex = initExtraCount
        
        var i = 0
        
        let maxCos = cos(maxAngle)
        let sqrCos = maxCos * maxCos
        let sqrMinEdge = minEdge * minEdge
        
        var unprocessed = IndexBuffer(count: self.triangles.count)
        
        while unprocessed.hasNext {
            let i = unprocessed.next()
            let triangle = self.triangles[i]
            
            let a = triangle.vertices[0]
            let b = triangle.vertices[1]
            let c = triangle.vertices[2]

            let ab = a.point.sqrDistance(point: b.point)
            let ca = c.point.sqrDistance(point: a.point)
            let bc = b.point.sqrDistance(point: c.point)
            
            guard ab > sqrMinEdge || ca > sqrMinEdge || bc > sqrMinEdge else {
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
                continue
            }
            
            let j = triangle.neighbors[k]
            guard j >= 0 && sCos > sqrCos else {
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

//        while i < self.triangles.count {
//            let triangle = self.triangles[i]
//
//            let a = triangle.vertices[0]
//            let b = triangle.vertices[1]
//            let c = triangle.vertices[2]
//
//            let ab = a.point.sqrDistance(point: b.point)
//            let ca = c.point.sqrDistance(point: a.point)
//            let bc = b.point.sqrDistance(point: c.point)
//
//            guard ab > sqrMinEdge || ca > sqrMinEdge || bc > sqrMinEdge else {
//                i += 1
//                continue
//            }
//
//            let k: Int
//            let aa = Float(bc)
//            let bb = Float(ca)
//            let cc = Float(ab)
//            let sCos: Float
//
//            if ab >= bc + ca {
//                // c, ab
//                k = 2
//                let l = aa + bb - cc
//                sCos = l * l / (4 * aa * bb)
//            } else if bc >= ca + ab {
//                // a, bc
//                k = 0
//                let l = bb + cc - aa
//                sCos = l * l / (4 * bb * cc)
//            } else if ca >= bc + ab {
//                // b, ca
//                k = 1
//                let l = aa + cc - bb
//                sCos = l * l / (4 * aa * cc)
//            } else {
//                i += 1
//                continue
//            }
//
//            let j = triangle.neighbors[k]
//            guard sCos > sqrCos else {
//                i += 1
//                continue
//            }
//
//            if j >= 0 {
//
//                let p = triangle.circumscribedCenter
////                let p = triangle.extraPoint(index: k)
//                let neighbor = self.triangles[j]
//
//                guard neighbor.isContain(p: p) else {
//                    i += 1
//                    continue
//                }
//
//                let k_next = (k + 1) % 3
//                let k_prev = (k + 2) % 3
//
//                let l = neighbor.opposite(neighbor: i)
//
//                let l_next = (l + 1) % 3
//                let l_prev = (l + 2) % 3
//
//                let vertex = Vertex(index: extraPointsIndex, point: p)
//                extraPoints.append(vertex)
//
//                let n = self.triangles.count
//                extraPointsIndex += 1
//
//                var t0 = triangle
//                t0.vertices[k_prev] = vertex
//                t0.neighbors[k_next] = n
//                self.triangles[i] = t0
//                assert(IntTriangle.isCCW_or_Line(a: t0.vertices[0].point, b: t0.vertices[1].point, c: t0.vertices[2].point), "Triangle's points are not clock-wise ordered")
//
//                var t1 = neighbor
//                t1.vertices[l_next] = vertex
//                t1.neighbors[l_prev] = n + 1
//                self.triangles[j] = t1
//                assert(IntTriangle.isCCW_or_Line(a: t1.vertices[0].point, b: t1.vertices[1].point, c: t1.vertices[2].point), "Triangle's points are not clock-wise ordered")
//
//                let t2Neighbor = triangle.neighbors[k_next]
//                let t2 = Triangle(
//                    index: n,
//                    a: triangle.vertices[k],
//                    b: vertex,
//                    c: triangle.vertices[k_prev],
//                    bc: n + 1,
//                    ac: t2Neighbor,
//                    ab: i
//                )
//
//                if t2Neighbor >= 0 {
//                    self.triangles[t2Neighbor].updateOpposite(oldNeighbor: i, newNeighbor: n)
//                }
//
//                self.triangles.append(t2)
//
//                let t3Neighbor = neighbor.neighbors[l_prev]
//                let t3 = Triangle(
//                   index: n + 1,
//                   a: neighbor.vertices[l],
//                   b: neighbor.vertices[l_next],
//                   c: vertex,
//                   bc: n,
//                   ac: j,
//                   ab: t3Neighbor
//                )
//
//                if t3Neighbor >= 0 {
//                    self.triangles[t3Neighbor].updateOpposite(oldNeighbor: j, newNeighbor: n + 1)
//                }
//
//                self.triangles.append(t3)
//
//                let minIndex = self.fix(indices: [i, j, n, n + 1])
//                if minIndex < i {
//                    i = minIndex
//                }
//                if i > j {
//                    i = j
//                }
//            } else {
//                // border triangle
//
//                let k_next = (k + 1) % 3
//                let k_prev = (k + 2) % 3
//
//                let aVertex = triangle.vertices[k]
//
//                let isPathCount = aVertex.index < (self.pathCount + self.extraCount)
//
//                if !isPathCount {
//                    let last = triangle.neighbors[k_prev]
//                    var next = triangle.neighbors[k_next]
//                    var prevIndex = triangle.index
//                    var family = [Int]()
//                    family.reserveCapacity(8)
//                    while next >= 0 && next != last {
//                        family.append(next)
//                        let nextTriangle = self.triangles[next]
//                        next = nextTriangle.adjacentNeighbor(vertex: aVertex.index, neighbor: prevIndex)
//                        prevIndex = nextTriangle.index
//                    }
//
//                    let isMovable = next == last
//                    if isMovable {
//                        family.append(next)
//                        let a = aVertex.point
//                        let b = triangle.vertices[k_next].point
//                        let c = triangle.vertices[k_prev].point
//                        let ca = a - c
//                        let cb = b - c
//
//                        let nAB = Delaunay.projectionAonB(a: ca, b: cb)
//                        let p = c + nAB
//                        let vIx = aVertex.index - initExtraCount
//                        let newVertex = Vertex(index: aVertex.index, point: p)
//                        extraPoints[vIx] = newVertex
//
//                        for index in family {
//                            self.triangles[index].update(vertex: newVertex)
//                        }
//
//                        let first = family[0]
//                        self.triangles[first].updateOpposite(oldNeighbor: triangle.index, newNeighbor: -1)
//                        self.triangles[last].updateOpposite(oldNeighbor: triangle.index, newNeighbor: -1)
//
//                        if self.triangles.count - 1 != triangle.index {
//                            let lastTriangle = self.triangles[self.triangles.count - 1]
//
//                            let nA = lastTriangle.neighbors[0]
//                            if nA >= 0 {
//                                self.triangles[nA].updateOpposite(oldNeighbor: lastTriangle.index, newNeighbor: triangle.index)
//                            }
//                            let nB = lastTriangle.neighbors[1]
//                            if nB >= 0 {
//                                self.triangles[nB].updateOpposite(oldNeighbor: lastTriangle.index, newNeighbor: triangle.index)
//                            }
//                            let nC = lastTriangle.neighbors[2]
//                            if nC >= 0 {
//                                self.triangles[nC].updateOpposite(oldNeighbor: lastTriangle.index, newNeighbor: triangle.index)
//                            }
//                            self.triangles[triangle.index] = Triangle(
//                                index: triangle.index,
//                                a: lastTriangle.vertices[0],
//                                b: lastTriangle.vertices[1],
//                                c: lastTriangle.vertices[2],
//                                bc: nA,
//                                ac: nB,
//                                ab: nC
//                            )
//                        }
//
//                        self.triangles.removeLast()
//
//                        continue
//                    }
//                }
//
//                // immovable case
//                // split by normal
//
////                let prev = triangle.vertices[k_prev].point
////                let next = triangle.vertices[k_next].point
////
////                let p = IntPoint(x: (prev.x + next.x) / 2, y: (prev.y + next.y) / 2)
//
//                let a = aVertex.point
//                let b = triangle.vertices[k_next].point
//                let c = triangle.vertices[k_prev].point
//                let ca = a - c
//                let cb = b - c
//
//                let nAB = Delaunay.projectionAonB(a: ca, b: cb)
//                let p = c + nAB
//
//                let vertex = Vertex(index: extraPointsIndex, point: p)
//                extraPoints.append(vertex)
//
//                let n = self.triangles.count
//                extraPointsIndex += 1
//
//                var t0 = triangle
//                t0.vertices[k_next] = vertex
//                t0.neighbors[k_prev] = n
//                self.triangles[i] = t0
//
//                let t1Neighbor = triangle.neighbors[k_prev]
//
//                let t1 = Triangle(
//                    index: n,
//                    a: triangle.vertices[k],
//                    b: triangle.vertices[k_next],
//                    c: vertex,
//                    bc: -1,
//                    ac: i,
//                    ab: t1Neighbor
//                )
//                self.triangles.append(t1)
//
//                if t1Neighbor >= 0 {
//                    var n1 = self.triangles[t1Neighbor]
//                    n1.updateOpposite(oldNeighbor: i, newNeighbor: n)
//                    self.triangles[t1Neighbor] = n1
//                }
//
//                #if DEBUG
//                t0.test_IsCCW_or_Line()
//                t1.test_IsCCW_or_Line()
//                #endif
//
//                let minIndex = self.fix(indices: [i, n])
//                if minIndex < i {
//                    i = minIndex
//                }
//            }
//        }

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
    
}
