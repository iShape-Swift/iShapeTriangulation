//
//  PlainShape+SliceBuffer.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 22/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

extension PlainShape {

    struct Slice {
        let a: Index
        let b: Index
    }
    
    private struct Edge {
        static let empty = Edge(id: 0, edge: null, triangle: null)
        let id: Int
        var edge: Index
        var triangle: Index
        
        var isEmpty: Bool {
            return triangle == null
        }
    }
    
    struct SliceBuffer {
        
        private let vertexCount: Int
        private var edges: [Edge]
        private let vertexMarks: [Bool]
        
        init(vertexCount: Int, slices: [Slice]) {
            self.vertexCount = vertexCount
            var vertexMark = Array<Bool>(repeating: false, count: vertexCount)
            var edges = Array<Edge>(repeating: .empty, count: slices.count)
            for i in 0..<slices.count {
                let slice = slices[i]
                vertexMark[slice.a] = true
                vertexMark[slice.b] = true
                let id: Int
                if slice.a < slice.b {
                    id = slice.a &* vertexCount &+ slice.b
                } else {
                    id = slice.b &* vertexCount &+ slice.a
                }
                edges[i] = Edge(id: id, edge: null, triangle: null)
            }
            
            edges.sort(by: { return $0.id < $1.id })
            
            
            self.vertexMarks = vertexMark
            self.edges = edges
        }
        
        mutating func addConections(triangles: inout [Delaunay.Triangle]) {
            let n = triangles.count
            
            for i in 0..<n {
                var triangle = triangles[i]
                let a = triangle.vertices[0].index
                let b = triangle.vertices[1].index
                let c = triangle.vertices[2].index
                
                // TODO optimise a little
                
                var edgeIndex = self.find(a: a, b: b)
                if edgeIndex >= 0 {
                    var edge = self.edges[edgeIndex]
                    if edge.isEmpty {
                        edge.triangle = i
                        edge.edge = 2
                        self.edges[edgeIndex] = edge
                    } else {
                        triangle.neighbors[2] = edge.triangle
                        var neighbor = triangles[edge.triangle]
                        neighbor.neighbors[edge.edge] = i
                        triangles[edge.triangle] = neighbor
                        triangles[i] = triangle
                    }
                }
                
                edgeIndex = self.find(a: a, b: c)
                if edgeIndex >= 0 {
                    var edge = self.edges[edgeIndex]
                    if edge.isEmpty {
                        edge.triangle = i
                        edge.edge = 1
                        self.edges[edgeIndex] = edge
                    } else {
                        triangle.neighbors[1] = edge.triangle
                        var neighbor = triangles[edge.triangle]
                        neighbor.neighbors[edge.edge] = i
                        triangles[edge.triangle] = neighbor
                        triangles[i] = triangle
                    }
                }
                
                edgeIndex = self.find(a: b, b: c)
                if edgeIndex >= 0 {
                    var edge = self.edges[edgeIndex]
                    if edge.isEmpty {
                        edge.triangle = i
                        edge.edge = 0
                        self.edges[edgeIndex] = edge
                    } else {
                        triangle.neighbors[0] = edge.triangle
                        var neighbor = triangles[edge.triangle]
                        neighbor.neighbors[edge.edge] = i
                        triangles[edge.triangle] = neighbor
                        triangles[i] = triangle
                    }
                }
            }

        }

        private func find(a: Index, b: Index) -> Index {
            guard vertexMarks[a] && vertexMarks[b] else {
                return null
            }
            let id: Int
            if a < b {
                id = a &* vertexCount &+ b
            } else {
                id = b &* vertexCount &+ a
            }
            
            var left = 0
            var right = edges.count &- 1
            
            var k: Int = -1
            var e = edges[0].id
            repeat {
                if left &+ 1 < right {
                    k = (left &+ right) >> 1
                } else {
                    repeat {
                        if edges[left].id == id {
                            return left
                        }
                        left &+= 1
                    } while left <= right
                    return -1
                }

                e = edges[k].id
                if e > id {
                    right = k
                } else if e < id {
                    left = k
                } else {
                    return k
                }
            } while true
        }
    }

}
