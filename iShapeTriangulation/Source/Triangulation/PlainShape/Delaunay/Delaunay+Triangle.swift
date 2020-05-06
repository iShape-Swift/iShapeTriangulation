//
//  Delaunay+Triangle.swift
//  iGeometry
//
//  Created by Nail Sharipov on 28.04.2020.
//

import Foundation
import iGeometry

extension Delaunay {

    struct Triangle {
        
        let index: Index
        
        // a(0), b(1), c(2)
        var vertices = Array<Vertex>(repeating: .empty, count: 3)
        
        // BC - a(0), AC - b(1), AB - c(2)
        var neighbors = Array<Index>(repeating: -1, count: 3)

        init() {
            self.index = -1
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex) {
            self.index = index
            self.vertices[0] = a
            self.vertices[1] = b
            self.vertices[2] = c
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, bc: Index) {
            self.index = index
            self.vertices[0] = a
            self.vertices[1] = b
            self.vertices[2] = c
            self.neighbors[0] = bc
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, ac: Index, ab: Index) {
            self.index = index
            self.vertices[0] = a
            self.vertices[1] = b
            self.vertices[2] = c
            self.neighbors[1] = ac
            self.neighbors[2] = ab
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        func vertex(neighbor: Index) -> Vertex {
            for i in 0...2 {
                if self.neighbors[i] == neighbor {
                    return self.vertices[i]
                }
            }
            assertionFailure("Neighbor is not present")
            return Vertex.empty
        }
        
        func opposite(neighbor: Index) -> Index {
            for i in 0...2 {
                if self.neighbors[i] == neighbor {
                    return i
                }
            }
            assertionFailure("Neighbor is not present")
            return -1
        }
        
        mutating func updateOpposite(oldNeighbor: Index, newNeighbor: Index) {
            for i in 0...2 {
                if self.neighbors[i] == oldNeighbor {
                    self.neighbors[i] = newNeighbor
                    return
                }
            }
            assertionFailure("Neighbor is not present")
        }
        
        func neighbor(vertex: Index) -> Index {
            for i in 0...2 {
                if self.vertices[i].index == vertex {
                    return self.neighbors[i]
                }
            }
            assertionFailure("Point is not present")
            return -1
        }
    }
    
    var trianglesIndices: [Int] {
        let n = triangles.count
        var result = Array<Int>(repeating: -1, count: 3 * n)
        var i = 0
        var j = 0
        repeat {
            let triangle = self.triangles[i]
            result[j] = triangle.vertices[0].index
            result[j + 1] = triangle.vertices[1].index
            result[j + 2] = triangle.vertices[2].index
            
            j += 3
            i += 1
        } while i < n
        
        return result
    }
}
