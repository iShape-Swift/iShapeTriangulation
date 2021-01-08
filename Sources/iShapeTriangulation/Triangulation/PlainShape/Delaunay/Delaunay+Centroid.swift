//
//  Delaunay+Centroid.swift
//  iGeometry
//
//  Created by Nail Sharipov on 20.05.2020.
//

import iGeometry

extension Delaunay {
    
    private struct Detail {
        let center: IntPoint
        let count: Int
    }
    
    public func getCenters(intGeom: IntGeom) -> [Point] {
        let n = self.triangles.count
        var points = [Point]()
        points.reserveCapacity(n)
        
        for triangle in self.triangles {
            let center = triangle.center
            points.append(intGeom.float(point: center))
        }

        return points
    }

    func makeCentroidNet(minArea: Int64 = 0, onlyConvex: Bool = false) -> [[IntPoint]] {
        let n = self.triangles.count
        
        var details = [Detail](repeating: Detail(center: .zero, count: 0), count: n)
        for i in 0..<n {
            let triangle = self.triangles[i]
            var count = 0
            for j in 0...2 where triangle.neighbors[j] >= 0 {
                count += 1
            }
            details[i] = Detail(center: triangle.center, count: count)
        }

        var visitedIndex = Array<Bool>(repeating: false, count: self.points.count)
        var result = [[IntPoint]]()

        for i in 0..<n {
            let triangle = self.triangles[i]
            let detail = details[i]
            for j in 0...2 {
                let v = triangle.vertices[j]
                guard !visitedIndex[v.index] else {
                    continue
                }
                visitedIndex[v.index] = true
                
                if v.nature.isPath {
                    if detail.count == 1 && triangle.neighbors[j] >= 0 {
                        let path: [IntPoint]
                        switch j {
                        case 0: // a
                            let ab = v.point.center(point: triangle.vertices.b.point)
                            let ca = v.point.center(point: triangle.vertices.c.point)
                            path = [v.point, ab, detail.center, ca]
                        case 1: // b
                            let bc = v.point.center(point: triangle.vertices.c.point)
                            let ab = v.point.center(point: triangle.vertices.a.point)
                            path = [v.point, bc, detail.center, ab]
                        default: // c
                            let ca = v.point.center(point: triangle.vertices.a.point)
                            let bc = v.point.center(point: triangle.vertices.b.point)
                            path = [v.point, ca, detail.center, bc]
                        }
                        
                        if path.area > minArea  {
                            result.append(path)
                        }
                    } else {
                        var path = [IntPoint]()
                        path.reserveCapacity(8)

                        // first going in a counterclockwise direction
                        var current = triangle
                        var k = triangle.index(index: v.index)
                        var right = (k + 2) % 3
                        var prev = triangle.neighbors[right]
                        while prev >= 0 {
                            let prevTriangle = self.triangles[prev]
                            k = prevTriangle.index(index: v.index)
                            if k < 0 {
                                break
                            }
                            current = prevTriangle
                            path.append(details[prev].center)
                            
                            right = (k + 2) % 3
                            prev = current.neighbors[right]
                        }
                        
                        var left = (k + 1) % 3
                        let lastPrevPair = current.vertices[left].point
                        path.append(lastPrevPair.center(point: v.point))

                        path.reverse()
                        
                        path.append(details[i].center)
                        
                        // now going in a clockwise direction
                        current = triangle
                        k = triangle.index(index: v.index)
                        left = (k + 1) % 3
                        var next = triangle.neighbors[left]
                        while next >= 0 {
                            let nextTriangle = self.triangles[next]
                            k = nextTriangle.index(index: v.index)
                            if k < 0 {
                                break
                            }
                            current = nextTriangle
                            path.append(details[next].center)
                            left = (k + 1) % 3
                            next = current.neighbors[left]
                        }
                        right = (k + 2) % 3
                        let lastNextPair = current.vertices[right].point
                        path.append(lastNextPair.center(point: v.point))
                        
                        if onlyConvex {
                            // split path into convex subpath
                            let c = v.point
                            var p0 = path[0]
                            var v0 = p0 - c
                            var d0 = v0
                            var subPath = [c, path[0]]
                            for t in 1..<path.count {
                                let p1 = path[t]
                                let d1 = p1 - p0
                                let v1 = p1 - c
                                if v0.crossProduct(point: v1) <= 0 && d0.crossProduct(point: d1) <= 0 {
                                    subPath.append(p1)
                                } else {
                                    if subPath.area > minArea  {
                                        result.append(subPath)
                                    }
                                    subPath.removeAll()
                                    subPath.append(c)
                                    subPath.append(p0)
                                    subPath.append(p1)
                                    v0 = p0 - c
                                }
                                p0 = p1
                                d0 = d1
                            }

                            if subPath.area > minArea  {
                                result.append(subPath)
                            }
                        } else {
                            path.append(v.point)
                            if path.area > minArea  {
                                result.append(path)
                            }
                        }
                    }
                } else {
                    var path = [IntPoint]()
                    path.reserveCapacity(8)
                    let start = i
                    var next = start
                    repeat {
                        let t = self.triangles[next]
                        let center = details[next].center
                        path.append(center)
                        let index = (t.index(index: v.index) + 1) % 3;
                        next = t.neighbors[index]
                    } while next != start && next>=0
                    
                    if path.area > minArea  {
                        result.append(path)
                    }
                }
                
            }
        }

        return result
    }

    @inline(__always)
    private static func cross(a0: IntPoint, a1: IntPoint, b0: IntPoint, b1: IntPoint) -> IntPoint {
        let dxA = a0.x - a1.x
        let dyB = b0.y - b1.y
        let dyA = a0.y - a1.y
        let dxB = b0.x - b1.x
        
        let divider = dxA * dyB - dyA * dxB
        
        if divider != 0 {
            let xyA = Double(a0.x * a1.y - a0.y * a1.x)
            let xyB = Double(b0.x * b1.y - b0.y * b1.x)
            
            let invert_divider: Double = 1.0 / Double(divider)
            
            let x = xyA * Double(b0.x - b1.x) - Double(a0.x - a1.x) * xyB
            let y = xyA * Double(b0.y - b1.y) - Double(a0.y - a1.y) * xyB

            let cx = x * invert_divider
            let cy = y * invert_divider

            return IntPoint(x: Int64(cx.rounded(.toNearestOrAwayFromZero)), y: Int64(cy.rounded(.toNearestOrAwayFromZero)))
        } else {
            return IntPoint(x: (a0.x + a1.x) / 2, y: (a0.y + a1.y) / 2)
        }
    }
    
}

private extension Delaunay.Triangle {
    
    @inline(__always)
    var center: IntPoint {
        let a = self.vertices.a.point
        let b = self.vertices.b.point
        let c = self.vertices.c.point
        return IntPoint(x: (a.x + b.x + c.x) / 3, y: (a.y + b.y + c.y) / 3)
    }
}

private extension IntPoint {
    
    @inline(__always)
    func center(point: IntPoint) -> IntPoint {
        return IntPoint(x: (self.x + point.x) / 2, y: (self.y + point.y) / 2)
    }
}
