//
//  Delaunay+Triangle.swift
//  iGeometry
//
//  Created by Nail Sharipov on 28.04.2020.
//

import iGeometry

extension Delaunay {

    struct Triangle {
        
        let index: Index
        
        // a(0), b(1), c(2)
        var vertices: [Vertex]
        
        // BC - a(0), AC - b(1), AB - c(2)
        var neighbors: [Index]

        init() {
            self.index = null
            self.vertices = [.empty, .empty, .empty]
            self.neighbors = [null, null, null]
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex) {
            self.index = index
            self.vertices = [a, b, c]
            self.neighbors = [null, null, null]
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, bc: Index) {
            self.index = index
            self.vertices = [.empty, .empty, .empty]
            self.neighbors = [bc, null, null]
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, ac: Index, ab: Index) {
            self.index = index
            self.vertices = [a, b, c]
            self.neighbors = [null, ac, ab]
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, bc: Index, ac: Index, ab: Index) {
            self.index = index
            self.vertices = [a, b, c]
            self.neighbors = [bc, ac, ab]
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        @inline(__always)
        func vertex(neighbor: Index) -> Vertex {
            for i in 0...2 {
                if self.neighbors[i] == neighbor {
                    return self.vertices[i]
                }
            }
            assertionFailure("Neighbor is not present")
            return Vertex.empty
        }
        
        @inline(__always)
        func opposite(neighbor: Index) -> Index {
            for i in 0...2 {
                if self.neighbors[i] == neighbor {
                    return i
                }
            }
            assertionFailure("Neighbor is not present")
            return -1
        }
        
        @inline(__always)
        func index(index: Index) -> Index {
            for i in 0...2 {
                if self.vertices[i].index == index {
                    return i
                }
            }
            return -1
        }
        
        @inline(__always)
        mutating func updateOpposite(oldNeighbor: Index, newNeighbor: Index) {
            for i in 0...2 {
                if self.neighbors[i] == oldNeighbor {
                    self.neighbors[i] = newNeighbor
                    return
                }
            }
            assertionFailure("Neighbor is not present")
        }
        
        @inline(__always)
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
    
    public var trianglesIndices: [Int] {
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
