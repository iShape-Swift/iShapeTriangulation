//
//  PlainShape+DelaunayTriangulation.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import iGeometry

public extension PlainShape {
    
    private struct Edge {
        let a: Int            // vertex index
        let b: Int            // vertex index
        let neighbor: Int     // prev triangle index
    }

    private struct TriangleStack {
        
        private var edges: [Edge]
        private var triangles: [Delaunay.Triangle]
        private var counter: Int
        
        init(count: Int) {
            self.counter = 0
            self.edges = Array<Edge>()
            self.edges.reserveCapacity(8)
            self.triangles = Array<Delaunay.Triangle>(repeating: .init(), count: count)
        }
        
        mutating func getTriangles() -> [Delaunay.Triangle] {
            if counter != triangles.count {
                self.triangles.removeLast(triangles.count - counter)
            }
            return self.triangles
        }
        
        mutating func reset() {
            self.edges.removeAll(keepingCapacity: true)
        }
        
        mutating func add(a: Vertex, b: Vertex, c: Vertex) {
            guard a.index != b.index && a.index != c.index && b.index != c.index else {
                // ignore triangle with tween vertices
                return
            }
            
            var triangle = Delaunay.Triangle(
                index: counter,
                a: a,
                b: b,
                c: c
            )
            
            if let ac = self.pop(a: a.index, b: c.index) {
                var neighbor = triangles[ac.neighbor]
                neighbor.neighbors.a = triangle.index
                triangle.neighbors.b = neighbor.index
                self.triangles[neighbor.index] = neighbor
            }
            
            if let ab = self.pop(a: a.index, b: b.index) {
                var neighbor = triangles[ab.neighbor]
                neighbor.neighbors.a = triangle.index
                triangle.neighbors.c = neighbor.index
                self.triangles[neighbor.index] = neighbor
            }
            
            self.edges.append(Edge(a: b.index, b: c.index, neighbor: triangle.index)) // bc is always slice
            
            self.triangles[triangle.index] = triangle
            
            self.counter += 1
        }
        
        private mutating func pop(a: Index, b: Index) -> Edge? {
            let last = self.edges.count - 1
            var i = 0
            while i <= last {
                let e = self.edges[i]
                if (e.a == a || e.a == b) && (e.b == a || e.b == b) {
                    if i != last {
                        self.edges[i] = self.edges[last]
                    }
                    self.edges.removeLast()
                    return e
                }
                i += 1
            }
            return nil
        }
    }

    func delaunay(maxEdge: Int64 = 0, extraPoints: [IntPoint]? = nil) throws -> Delaunay {
        let layout: MonotoneLayout
        do {
            layout = try self.split(maxEdge: maxEdge, extraPoints: extraPoints)
        } catch SplitError.unusedPoint {
            let validation = self.validate()
            throw DelaunayError.notValidPath(validation)
        }
            
        let holesCount = self.layouts.count
        let totalCount = layout.pathCount + 2 * layout.extraCount + holesCount * 2 - 2
        
        var triangleStack = TriangleStack(count: totalCount)
        
        var links = layout.links
        for index in layout.indices {
            PlainShape.triangulate(index: index, links: &links, triangleStack: &triangleStack)
            triangleStack.reset()
        }
        
        var triangles = triangleStack.getTriangles()
        
        var sliceBuffer = SliceBuffer(vertexCount: links.count, slices: layout.slices)
        sliceBuffer.addConections(triangles: &triangles)
        
        var delaunay: Delaunay
        if extraPoints == nil && maxEdge == 0 {
            delaunay = Delaunay(points: self.points, triangles: triangles)
        } else {
            var points = [IntPoint](repeating: .zero, count: layout.links.count)
            for link in layout.links {
                points[link.vertex.index] = link.vertex.point
            }
            delaunay = Delaunay(points: points, triangles: triangles)
        }

        delaunay.build()
        
        return delaunay
    }
    
    private static func triangulate(index: Int, links: inout [Link], triangleStack: inout TriangleStack) {
        var c = links[index]
        
        var a0 = links[c.next]
        var b0 = links[c.prev]
        
        while a0.this != b0.this {
            let a1 = links[a0.next]
            let b1 = links[b0.prev]
            
            var aBit0 = a0.vertex.point.bitPack
            var aBit1 = a1.vertex.point.bitPack
            if aBit1 < aBit0 {
                aBit1 = aBit0
            }
            
            var bBit0 = b0.vertex.point.bitPack
            var bBit1 = b1.vertex.point.bitPack
            if bBit1 < bBit0 {
                bBit1 = bBit0
            }
            
            if aBit0 <= bBit1 && bBit0 <= aBit1 {
                triangleStack.add(a: c.vertex, b: a0.vertex, c: b0.vertex)
                
                a0.prev = b0.this
                b0.next = a0.this
                links[a0.this] = a0
                links[b0.this] = b0
                
                if bBit0 < aBit0 {
                    c = b0
                    b0 = b1
                } else {
                    c = a0
                    a0 = a1
                }
            } else {
                if aBit1 < bBit1 {
                    var cx = c
                    var ax0 = a0
                    var ax1 = a1
                    var ax1Bit: Int64 = .min
                    repeat {
                        let isCCW_or_Line = IntTriangle.isCCW_or_Line(a: cx.vertex.point, b: ax0.vertex.point, c: ax1.vertex.point)
                        
                        if isCCW_or_Line {
                            triangleStack.add(a: ax0.vertex, b: ax1.vertex, c: cx.vertex)
                            
                            ax1.prev = cx.this
                            cx.next = ax1.this
                            links[cx.this] = cx
                            links[ax1.this] = ax1
                            
                            if cx.this != c.this {
                                // move back
                                ax0 = cx
                                cx = links[cx.prev]
                            } else {
                                // move forward
                                ax0 = ax1
                                ax1 = links[ax1.next]
                            }
                        } else {
                            cx = ax0
                            ax0 = ax1
                            ax1 = links[ax1.next]
                        }
                        ax1Bit = ax1.vertex.point.bitPack
                    } while ax1Bit < bBit0
                } else {
                    var cx = c
                    var bx0 = b0
                    var bx1 = b1
                    var bx1Bit: Int64 = .min
                    repeat {
                        let isCCW_or_Line = IntTriangle.isCCW_or_Line(a: cx.vertex.point, b: bx1.vertex.point, c: bx0.vertex.point)
                        if isCCW_or_Line {
                            triangleStack.add(a: bx0.vertex, b: cx.vertex, c: bx1.vertex)
                            
                            bx1.next = cx.this
                            cx.prev = bx1.this
                            links[cx.this] = cx
                            links[bx1.this] = bx1
                            
                            if cx.this != c.this {
                                // move back
                                bx0 = cx
                                cx = links[cx.next]
                            } else {
                                // move forward
                                bx0 = bx1
                                bx1 = links[bx0.prev]
                            }
                        } else {
                            cx = bx0
                            bx0 = bx1
                            bx1 = links[bx1.prev]
                        }
                        bx1Bit = bx1.vertex.point.bitPack
                    } while bx1Bit < aBit0
                }
                
                c = links[c.this]
                a0 = links[c.next]
                b0 = links[c.prev]
                
                aBit0 = a0.vertex.point.bitPack
                bBit0 = b0.vertex.point.bitPack
                
                triangleStack.add(a: c.vertex, b: a0.vertex, c: b0.vertex)
                
                a0.prev = b0.this
                b0.next = a0.this
                links[a0.this] = a0
                links[b0.this] = b0
                
                if bBit0 < aBit0 {
                    c = b0
                    b0 = links[b0.prev]
                } else {
                    c = a0
                    a0 = links[a0.next]
                }
                
            } //while
        }
    }
    
}
