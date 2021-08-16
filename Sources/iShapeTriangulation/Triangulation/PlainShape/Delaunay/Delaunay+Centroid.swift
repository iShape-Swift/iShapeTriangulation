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

    func makeCentroidNet(minArea: Int64 = 0, onlyConvex: Bool = false) -> [[IntPoint]] {
        let n = self.triangles.count
        
        var details = [Detail](repeating: Detail(center: .zero, count: 0), count: n)
        for i in 0..<n {
            let triangle = self.triangles[i]
            var count = 0
            if triangle.neighbors.a >= 0 {
                count += 1
            }

            if triangle.neighbors.b >= 0 {
                count += 1
            }

            if triangle.neighbors.c >= 0 {
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
                        
                        if minArea == 0 || path.area > minArea  {
                            result.append(path)
                        }
                    } else {
                        var path = [IntPoint]()
                        path.reserveCapacity(8)

                        // first going in a counterclockwise direction
                        var current = triangle
                        var k = j
                        var right = (k &+ 2) % 3
                        var prev = triangle.neighbors[right]
                        while prev >= 0 {
                            let prevTriangle = self.triangles[prev]
                            let ni = prevTriangle.opposite(neighbor: current.index)
                            let edgeMiddle = prevTriangle.middle(index: ni)
                            path.append(edgeMiddle)
                            
                            k = prevTriangle.index(index: v.index)
                            if k < 0 {
                                break
                            }
                            current = prevTriangle
                            path.append(details[prev].center)
                            
                            right = (k &+ 2) % 3
                            prev = current.neighbors[right]
                        }
                        
                        var left = (k &+ 1) % 3
                        let lastPrevPair = current.vertices[left].point
                        path.append(lastPrevPair.center(point: v.point))

                        path.reverse()
                        
                        path.append(detail.center)
                        
                        // now going in a clockwise direction
                        current = triangle
                        k = j
                        left = (k &+ 1) % 3
                        var next = triangle.neighbors[left]
                        while next >= 0 {
                            let nextTriangle = self.triangles[next]
                            let ni = nextTriangle.opposite(neighbor: current.index)
                            let edgeMiddle = nextTriangle.middle(index: ni)
                            path.append(edgeMiddle)
                            k = nextTriangle.index(index: v.index)
                            if k < 0 {
                                break
                            }
                            current = nextTriangle
                            path.append(details[next].center)
                            left = (k &+ 1) % 3
                            next = current.neighbors[left]
                        }
                        right = (k &+ 2) % 3
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
                                    if minArea == 0 || subPath.area > minArea  {
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

                            if minArea == 0 || subPath.area > minArea  {
                                result.append(subPath)
                            }
                        } else {
                            path.append(v.point)
                            if minArea == 0 || path.area > minArea  {
                                result.append(path)
                            }
                        }
                    }
                } else {
                    var path = [IntPoint]()
                    path.reserveCapacity(16)
                    let start = i
                    var next = start
                    
                    repeat {
                        let t = self.triangles[next]
                        let center = details[next].center
                        path.append(center)
                        
                        let vIndex = t.index(index: v.index)
                        let nextIndex = (vIndex + 1) % 3
                        
                        let edgeMiddle = t.middle(index: nextIndex)
                        path.append(edgeMiddle)

                        next = t.neighbors[nextIndex]
                    } while next != start && next >= 0

                    if minArea == 0 || path.area > minArea  {
                        result.append(path)
                    }
                }
                
            }
        }

        return result
    }
}


private extension Delaunay.Triangle {
    
    @inline(__always)
    var center: IntPoint {
        let a = self.vertices.a.point
        let b = self.vertices.b.point
        let c = self.vertices.c.point
        return IntPoint(x: (a.x &+ b.x &+ c.x) / 3, y: (a.y &+ b.y &+ c.y) / 3)
    }
    
    @inline(__always)
    func middle(index: Int)  -> IntPoint {
        switch index {
        case 0:
            return (vertices.b.point + vertices.c.point).middle
        case 1:
            return (vertices.a.point + vertices.c.point).middle
        default:
            return (vertices.a.point + vertices.b.point).middle
        }
    }
}

private extension IntPoint {

    @inline(__always)
    var middle: IntPoint {
        IntPoint(x: x >> 1, y: y >> 1)
    }
    
    @inline(__always)
    func center(point: IntPoint) -> IntPoint {
        (self + point).middle
    }
}
