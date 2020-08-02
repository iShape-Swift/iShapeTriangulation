//
//  Delaunay+Polygon.swift
//  iGeometry
//
//  Created by Nail Sharipov on 29.04.2020.
//

import Foundation
import iGeometry

extension Delaunay {
    
    private struct Polygon {
        
        struct Edge {
            let triangleIndex: Int
            let neighbor: Int
            let a: Int
            let b: Int
        }

        var edges: [Edge]
        private var links: [PlainShape.Link]
        
        var indices: [Int] {
            let n = self.links.count
            
            var result = [Int](repeating: 0, count: n + 1)
            result[0] = n
            var link = self.links[0]
            var i = 1
            repeat {
                result[i] = link.vertex.index
                link = self.links[link.next]
                i += 1
            } while i <= n

            return result
        }
        
        mutating func add(edge: Edge, triangle: Triangle) -> Bool {
            let v = triangle.vertex(neighbor: edge.triangleIndex)

            // a0 -> a1 -> p

            var link_a1 = self.links[edge.a]
            let va0 = self.links[link_a1.prev].vertex
            let va1 = link_a1.vertex
            
            let aa = va1.point - va0.point
            let ap = v.point - va1.point
            
            let apa = aa.crossProduct(point: ap)
            if apa > 0 {
                return false
            }
            
            // b0 <- b1 <- p
            
            var link_b1 = self.links[edge.b]
            let vb0 = self.links[link_b1.next].vertex
            let vb1 = link_b1.vertex
            
            let bb = vb0.point - vb1.point
            let bp = vb1.point - v.point
            
            let bpb = bp.crossProduct(point: bb)
            if bpb > 0 {
                return false
            }

            let linkIndex = self.links.count
            let link_p = PlainShape.Link(prev: link_a1.this, this: linkIndex, next: link_b1.this, vertex: v)
            
            link_a1.next = linkIndex
            link_b1.prev = linkIndex
            
            self.links.append(link_p)
            self.links[link_a1.this] = link_a1
            self.links[link_b1.this] = link_b1

            let n0 = triangle.neighbor(vertex: vb1.index)
            if n0 >= 0 {
                let edge = Edge(triangleIndex: triangle.index, neighbor: n0, a: edge.a, b: linkIndex)
                self.edges.append(edge)
            }
            
            let n1 = triangle.neighbor(vertex: va1.index)
            if n1 >= 0 {
                let edge = Edge(triangleIndex: triangle.index, neighbor: n1, a: linkIndex, b: edge.b)
                self.edges.append(edge)
            }

            return true
        }

        init(triangle: Triangle) {
            self.links = [
                PlainShape.Link(prev: 2, this: 0, next: 1, vertex: triangle.vertices[0]),
                PlainShape.Link(prev: 0, this: 1, next: 2, vertex: triangle.vertices[1]),
                PlainShape.Link(prev: 1, this: 2, next: 0, vertex: triangle.vertices[2])
            ]
            
            self.edges = [Edge]()
            self.edges.reserveCapacity(3)
            
            let ab = triangle.neighbors[2]
            if ab >= 0 {
                self.edges.append(Edge(triangleIndex: triangle.index, neighbor: ab, a: 0, b: 1))
            }
            
            let bc = triangle.neighbors[0]
            if bc >= 0 {
                self.edges.append(Edge(triangleIndex: triangle.index, neighbor: bc, a: 1, b: 2))
            }
            
            let ca = triangle.neighbors[1]
            if ca >= 0 {
                self.edges.append(Edge(triangleIndex: triangle.index, neighbor: ca, a: 2, b: 0))
            }
        }

    }
    
    public var convexPolygonsIndices: [Int] {
        var result = Array<Int>()
        let n = self.triangles.count
        result.reserveCapacity(4 * n)
        
        var visited = [Bool](repeating: false, count: n)
        
        for i in 0..<n where !visited[i] {
            let first = self.triangles[i]
            visited[i] = true
            var polygon = Polygon(triangle: first)

            while !polygon.edges.isEmpty {
                let edge = polygon.edges.removeLast()
                if visited[edge.neighbor] {
                    continue
                }
                let next = self.triangles[edge.neighbor]
                if polygon.add(edge: edge, triangle: next) {
                    visited[edge.neighbor] = true
                }
            }
            
            result.append(contentsOf: polygon.indices)
        }

        return result
    }

}
