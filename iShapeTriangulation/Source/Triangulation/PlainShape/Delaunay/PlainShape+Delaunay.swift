//
//  PlainShape+DelaunayTriangulation.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
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
                triangles.removeLast(triangles.count - counter)
            }
            return triangles
        }
        
        mutating func reset() {
            edges.removeAll(keepingCapacity: true)
        }
        
        mutating func add(a: Vertex, b: Vertex, c: Vertex) {
            var triangle = Delaunay.Triangle(
                index: counter,
                a: a,
                b: b,
                c: c
            )
            
            if let ac = self.pop(a: a.index, b: c.index) {
                var neighbor = triangles[ac.neighbor]
                neighbor.neighbors[0] = triangle.index
                triangle.neighbors[1] = neighbor.index
                triangles[neighbor.index] = neighbor
            }
            
            if let ab = self.pop(a: a.index, b: b.index) {
                var neighbor = triangles[ab.neighbor]
                neighbor.neighbors[0] = triangle.index
                triangle.neighbors[2] = neighbor.index
                triangles[neighbor.index] = neighbor
            }
            
            self.edges.append(Edge(a: b.index, b: c.index, neighbor: triangle.index)) // bc is always slice
            
            triangles[triangle.index] = triangle
            
            counter += 1
        }
        
        mutating func updateLast() {
            if !edges.isEmpty {
                let e = edges[0]
                let triangleIndex = counter - 1
                if e.neighbor != triangleIndex {
                    var triangle = self.triangles[triangleIndex]
                    var neighbor = triangles[e.neighbor]
                    neighbor.neighbors[0] = triangle.index
                    triangle.neighbors[0] = neighbor.index
                    triangles[neighbor.index] = neighbor
                    triangles[triangle.index] = triangle
                }
            }
        }
        
        private mutating func pop(a: Index, b: Index) -> Edge? {
            let last = edges.count - 1
            var i = 0
            while i <= last {
                let e = edges[i]
                if (e.a == a || e.a == b) && (e.b == a || e.b == b) {
                    if i != last {
                        edges[i] = edges[last]
                    }
                    edges.removeLast()
                    return e
                }
                i += 1
            }
            return nil
        }
    }
    
    func triangulateDelaunay() -> [Int] {
        let layout = self.split()
        
        let vertexCount = self.points.count
        
        let totalCount = vertexCount &+ ((self.layouts.count - 2) << 1)
        
        var triangleStack = TriangleStack(count: totalCount)
        
        var links = layout.links
        for index in layout.indices {
            PlainShape.triangulate(index: index, links: &links, triangleStack: &triangleStack)
            triangleStack.reset()
        }
        
        var triangles = triangleStack.getTriangles()
        
        var sliceBuffer = SliceBuffer(vertexCount: vertexCount, slices: layout.slices)
        sliceBuffer.addConections(triangles: &triangles)
        
        var delaunay = Delaunay(triangles: triangles)
        delaunay.build()
        
        return delaunay.indices
    }
    
    private static func triangulate(index: Int, links: inout [Link], triangleStack: inout TriangleStack) {
        
        var c = links[index]
        
        var a0 = links[c.next]
        var b0 = links[c.prev]
        
        next_point:
            while a0.this != b0.this {
                let a1 = links[a0.next]
                let b1 = links[b0.prev]
                
                let aBit0 = a0.vertex.point.bitPack
                var aBit1 = a1.vertex.point.bitPack
                if aBit1 < aBit0 {
                    aBit1 = aBit0
                }
                
                let bBit0 = b0.vertex.point.bitPack
                var bBit1 = b1.vertex.point.bitPack
                if bBit1 < bBit0 {
                    bBit1 = bBit0
                }
                
                if aBit0 < bBit1 && bBit0 < aBit1 {
                    if c.vertex.index != a0.vertex.index && c.vertex.index != b0.vertex.index && a0.vertex.index != b0.vertex.index {
                        triangleStack.add(a: c.vertex, b: a0.vertex, c: b0.vertex)
                    }
                    
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
                    
                    var isModified = false
                    
                    if aBit1 < bBit1 {
                        var cx = c
                        var ax0 = a0
                        var ax1 = a1
                        
                        repeat {
                            let orientation = IntTriangle.getOrientation(a: cx.vertex.point, b: ax0.vertex.point, c: ax1.vertex.point)
                            switch orientation {
                            case .clockWise:
                                triangleStack.add(a: ax0.vertex, b: ax1.vertex, c: cx.vertex)
                                isModified = true
                                ax1.prev = cx.this
                                cx.next = ax1.this
                                links[cx.this] = cx
                                links[ax1.this] = ax1
                                if cx.this != c.this {
                                    ax0 = cx
                                    cx = links[cx.prev]
                                    break
                                } else {
                                    c = links[c.this]
                                    a0 = links[c.next]
                                    continue next_point
                                }
                            case .line:
                                if ax0.vertex.index != ax1.vertex.index && ax0.vertex.index != cx.vertex.index && ax1.vertex.index != cx.vertex.index {
                                    triangleStack.add(a: ax0.vertex, b: ax1.vertex, c: cx.vertex)
                                }
                                
                                isModified = true
                                ax1.prev = cx.this
                                cx.next = ax1.this
                                links[cx.this] = cx
                                links[ax1.this] = ax1
                                if cx.this != c.this {
                                    ax0 = cx
                                    cx = links[cx.prev]
                                    break
                                } else {
                                    c = links[c.this]
                                    a0 = links[c.next]
                                    continue next_point
                                }
                            case .counterClockWise:
                                cx = ax0
                                ax0 = ax1
                                ax1 = links[ax1.next]
                            }
                        } while ax1.vertex.point.bitPack <= bBit1
                    } else {
                        var cx = c
                        var bx0 = b0
                        var bx1 = b1
                        repeat {
                            let orientation = IntTriangle.getOrientation(a: cx.vertex.point, b: bx1.vertex.point, c: bx0.vertex.point)
                            switch orientation {
                            case .clockWise:
                                triangleStack.add(a: bx0.vertex, b: cx.vertex, c: bx1.vertex)
                                isModified = true
                                 bx1.next = cx.this
                                 cx.prev = bx1.this
                                 links[cx.this] = cx
                                 links[bx1.this] = bx1
                                 if cx.this != c.this {
                                     bx0 = cx
                                     cx = links[cx.next]
                                     break
                                 } else {
                                     c = links[c.this]
                                     b0 = links[c.prev]
                                     continue next_point
                                 }
                            case .line:
                                if bx0.vertex.index != cx.vertex.index && bx0.vertex.index != bx1.vertex.index && cx.vertex.index != bx1.vertex.index {
                                    triangleStack.add(a: bx0.vertex, b: cx.vertex, c: bx1.vertex)
                                }
                                isModified = true
                                bx1.next = cx.this
                                cx.prev = bx1.this
                                links[cx.this] = cx
                                links[bx1.this] = bx1
                                if cx.this != c.this {
                                    bx0 = cx
                                    cx = links[cx.next]
                                    break
                                } else {
                                    c = links[c.this]
                                    b0 = links[c.prev]
                                    continue next_point
                                }
                            case .counterClockWise:
                                cx = bx0
                                bx0 = bx1
                                bx1 = links[bx1.prev]
                            }
                        } while bx1.vertex.point.bitPack <= aBit1
                        
                    }
                    
                    if isModified {
                        a0 = links[a0.this]
                        b0 = links[b0.this]
                    } else {
                        if c.vertex.index != a0.vertex.index && c.vertex.index != b0.vertex.index && a0.vertex.index != b0.vertex.index {
                            triangleStack.add(a: c.vertex, b: a0.vertex, c: b0.vertex)
                        }

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
                    }
                    
                }
        } // while
        
        triangleStack.updateLast()
    }
    
}
