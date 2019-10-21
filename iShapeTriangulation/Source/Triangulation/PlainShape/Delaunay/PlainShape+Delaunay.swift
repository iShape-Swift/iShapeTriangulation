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
        static let empty = Edge(a: -1, b: -1, neighbor: -1, number: -1)
        let a: Index            // vertex index
        let b: Index            // vertex index
        let neighbor: Index     // prev triangle index
        let number: Index       // edge index 0 - a(bc), 1 - b(ac), 2 - c(ab)
        
        var isEmpty: Bool {
            return neighbor == -1
        }
        
        var isNotEmpty: Bool {
            return neighbor >= 0
        }
    }
    
    private struct EdgeBuffer {
        private var e0 = Edge.empty
        private var e1 = Edge.empty
        
        mutating func push(slice: Edge) {
            #if iShapeTest
            if !(e0.isEmpty || e1.isEmpty) {
                assertionFailure("cannot be full")
            }
            #endif
            if e0.isEmpty {
                e0 = slice
            } else {
                e1 = slice
            }
        }
        
        mutating func pop(a: Index, b: Index) -> Edge {
            let isFirst = (e0.a == a || e0.a == b) && (e0.b == a || e0.b == b)
            let e: Edge
            if isFirst {
                e = e0
                e0 = .empty
            } else {
                e = e1
                e1 = .empty
            }
            
            return e
        }
    }
    
    func triangulateDelaunay() -> [Int] {
        let layout = self.split()
        
        let vertexCount = self.points.count
        
        let totalCount = vertexCount &+ ((self.layouts.count - 2) << 1)
        
        var triangles = Array<Delaunay.Triangle>(repeating: .init(), count: totalCount)
        var counter = 0
        var links = layout.links
        var slices = layout.slices
        for index in layout.indices {
            PlainShape.triangulate(index: index, counter: &counter, links: &links, triangles: &triangles, slices: &slices)
        }
        
        var sliceBuffer = SliceBuffer(vertexCount: vertexCount, slices: slices)
        sliceBuffer.addConections(triangles: &triangles)
        
        var delaunay = Delaunay(triangles: triangles)
        delaunay.build()
        
        return delaunay.indices
    }
    
    /*
     private func triangulate(index: Int, counter: inout Int, links: [Link], triangles: inout [Delaunay.Triangle]) {
     
     var c = links[index]
     
     var a0 = links[c.next]
     var b0 = links[c.prev]
     
     var edgeBuffer = EdgeBuffer()
     
     repeat {
     let aBit0 = a0.vertex.point.bitPack
     let bBit0 = b0.vertex.point.bitPack
     
     if bBit0 < aBit0 {
     let b1 = links[b0.prev]
     let bBit1 = b1.vertex.point.bitPack
     if bBit1 < aBit0 && PlainShape.isCCW_or_Line(a: c.vertex.point, b: b1.vertex.point, c: b0.vertex.point) {
     if c.next != b0.this {
     // in middle
     
     let slice = edgeBuffer.pop(a: c.vertex.index, b: b0.vertex.index)
     
     triangles[counter] = Delaunay.Triangle(
     index: counter,
     a: b1.vertex,
     b: b0.vertex,
     c: c.vertex,
     bc: slice.neighbor
     )
     if slice.isNotEmpty {
     var neighbor = triangles[slice.neighbor]
     neighbor.neighbors[slice.number] = counter
     triangles[slice.neighbor] = neighbor
     }
     edgeBuffer.push(slice: Edge(a: c.vertex.index, b: b1.vertex.index, neighbor: counter, number: 1))
     } else {
     // on border
     
     triangles[counter] = Delaunay.Triangle(
     index: counter,
     a: b0.vertex,
     b: c.vertex,
     c: b1.vertex
     )
     
     edgeBuffer.push(slice: Edge(a: c.vertex.index, b: b1.vertex.index, neighbor: counter, number: 0))
     }
     
     counter &+= 1
     
     b0 = b1
     
     continue
     }
     } else {
     let a1 = links[a0.next]
     let aBit1 = a1.vertex.point.bitPack
     if aBit1 < bBit0 && PlainShape.isCCW_or_Line(a: c.vertex.point, b: a0.vertex.point, c: a1.vertex.point) {
     if c.next != a0.this {
     // in middle
     
     let slice = edgeBuffer.pop(a: c.vertex.index, b: a0.vertex.index)
     
     triangles[counter] = Delaunay.Triangle(
     index: counter,
     a: a1.vertex,
     b: c.vertex,
     c: a0.vertex,
     bc: slice.neighbor
     )
     if slice.isNotEmpty {
     var neighbor = triangles[slice.neighbor]
     neighbor.neighbors[slice.number] = counter
     triangles[slice.neighbor] = neighbor
     }
     
     edgeBuffer.push(slice: Edge(a: c.vertex.index, b: a1.vertex.index, neighbor: counter, number: 2))
     } else {
     // on border
     
     triangles[counter] = Delaunay.Triangle(
     index: counter,
     a: a0.vertex,
     b: a1.vertex,
     c: c.vertex
     )
     
     edgeBuffer.push(slice: Edge(a: c.vertex.index, b: a1.vertex.index, neighbor: counter, number: 0))
     }
     
     counter &+= 1
     
     a0 = a1
     
     continue
     }
     }
     
     if c.next == a0.this || c.prev == b0.this {
     if c.next == a0.this {
     // c - a0 edge on board
     
     let slice = edgeBuffer.pop(a: c.vertex.index, b: b0.vertex.index)
     
     triangles[counter] = Delaunay.Triangle(
     index: counter,
     a: a0.vertex,
     b: b0.vertex,
     c: c.vertex,
     bc: slice.neighbor
     )
     if slice.isNotEmpty {
     var neighbor = triangles[slice.neighbor]
     neighbor.neighbors[slice.number] = counter
     triangles[slice.neighbor] = neighbor
     }
     
     edgeBuffer.push(slice: Edge(a: b0.vertex.index, b: a0.vertex.index, neighbor: counter, number: 2))
     } else {
     // c - b0 edge on board
     
     let slice = edgeBuffer.pop(a: c.vertex.index, b: a0.vertex.index)
     
     triangles[counter] = Delaunay.Triangle(
     index: counter,
     a: b0.vertex,
     b: c.vertex,
     c: a0.vertex,
     bc: slice.neighbor
     )
     if slice.isNotEmpty {
     var neighbor = triangles[slice.neighbor]
     neighbor.neighbors[slice.number] = counter
     triangles[slice.neighbor] = neighbor
     }
     
     edgeBuffer.push(slice: Edge(a: a0.vertex.index, b: b0.vertex.index, neighbor: counter, number: 1))
     }
     } else {
     // all triangle's edges inside
     
     let sliceA = edgeBuffer.pop(a: c.vertex.index, b: b0.vertex.index)
     let sliceB = edgeBuffer.pop(a: c.vertex.index, b: a0.vertex.index)
     
     triangles[counter] = Delaunay.Triangle(
     index: counter,
     a: c.vertex,
     b: a0.vertex,
     c: b0.vertex,
     ac: sliceA.neighbor,
     ab: sliceB.neighbor
     )
     
     if sliceA.isNotEmpty {
     var neighbor = triangles[sliceA.neighbor]
     neighbor.neighbors[sliceA.number] = counter
     triangles[sliceA.neighbor] = neighbor
     }
     
     if sliceB.isNotEmpty {
     var neighbor = triangles[sliceB.neighbor]
     neighbor.neighbors[sliceB.number] = counter
     triangles[sliceB.neighbor] = neighbor
     }
     
     edgeBuffer.push(slice: Edge(a: a0.vertex.index, b: b0.vertex.index, neighbor: counter, number: 0))
     }
     
     if bBit0 < aBit0 {
     c = b0
     b0 = links[b0.prev]
     } else {
     c = a0
     a0 = links[a0.next]
     }
     
     counter &+= 1
     
     } while a0.this != b0.this
     
     var neighbors = triangles[counter &- 1].neighbors
     for i in 0...2 {
     let neighbor = neighbors[i]
     neighbors[i] = neighbor < counter ? neighbor : -1
     }
     triangles[counter &- 1].neighbors = neighbors
     }
     */
    
    
    private static func triangulate(index: Int, counter: inout Int, links: inout [Link], triangles: inout [Delaunay.Triangle], slices: inout [Slice]) {
        
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
                    triangles[counter] = Delaunay.Triangle(
                        index: counter,
                        a: c.vertex,
                        b: a0.vertex,
                        c: b0.vertex
                    )
                    counter += 1
                    
                    slices.append(Slice(a: a0.vertex.index, b: b0.vertex.index))
                    
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
                        
                        repeat {
                            let isCCW = PlainShape.isCCW_or_Line(a: cx.vertex.point, b: ax0.vertex.point, c: ax1.vertex.point)
                            if isCCW {
                                triangles[counter] = Delaunay.Triangle(
                                    index: counter,
                                    a: cx.vertex,
                                    b: ax0.vertex,
                                    c: ax1.vertex
                                )
                                counter += 1
                                
                                slices.append(Slice(a: cx.vertex.index, b: ax1.vertex.index))
                                
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
                            } else {
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
                            let isCCW = PlainShape.isCCW_or_Line(a: cx.vertex.point, b: bx1.vertex.point, c: bx0.vertex.point)
                            if isCCW {
                                triangles[counter] = Delaunay.Triangle(
                                    index: counter,
                                    a: cx.vertex,
                                    b: bx1.vertex,
                                    c: bx0.vertex
                                )
                                counter += 1
                                
                                slices.append(Slice(a: cx.vertex.index, b: bx1.vertex.index))
                                
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
                            } else {
                                cx = bx0
                                bx0 = bx1
                                bx1 = links[bx1.prev]
                            }
                        } while bx1.vertex.point.bitPack <= aBit1
                    }
                    
                    triangles[counter] = Delaunay.Triangle(
                        index: counter,
                        a: c.vertex,
                        b: a0.vertex,
                        c: b0.vertex
                    )
                    counter += 1
                    
                    slices.append(Slice(a: a0.vertex.index, b: b0.vertex.index))
                    
                    a0 = links[a0.this]
                    b0 = links[b0.this]
                    
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
                }
        }
    }
    
    private static func isCCW_or_Line(a: IntPoint, b: IntPoint, c: IntPoint) -> Bool {
        let m0 = (c.y &- a.y) &* (b.x &- a.x)
        let m1 = (b.y &- a.y) &* (c.x &- a.x)
        
        return m0 <= m1
    }
}


