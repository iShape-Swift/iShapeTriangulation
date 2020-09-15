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
            var vertex = Vertex.empty
            self.neighbors.withUnsafeBufferPointer { buffer in
                for i in 0...2 {
                    if buffer[i] == neighbor {
                        vertex = self.vertices[i]
                        return
                    }
                }
                assertionFailure("Neighbor is not present")
            }
            
            return vertex
        }
        
        @inline(__always)
        func opposite(neighbor: Index) -> Index {
            var index = null
            self.neighbors.withUnsafeBufferPointer { buffer in
                for i in 0...2 {
                    if buffer[i] == neighbor {
                        index = i
                        return
                    }
                }
                assertionFailure("Neighbor is not present")
            }
            
            return index
        }
        
        @inline(__always)
        func adjacentNeighbor(vertex: Index, neighbor: Index) -> Index {
            for i in 0...2 {
                let ni = neighbors[i]
                if self.vertices[i].index != vertex && ni != neighbor {
                    return ni
                }
            }
            assertionFailure("Neighbor is not present")
            return null
        }
        
        @inline(__always)
        func index(index: Index) -> Index {
            var j = null
            self.vertices.withUnsafeBufferPointer { buffer in
                for i in 0...2 {
                    if buffer[i].index == index {
                        j = i
                        return
                    }
                }
            }

            return j
        }
        
        @inline(__always)
        mutating func updateOpposite(oldNeighbor: Index, newNeighbor: Index) {
            let index = self.opposite(neighbor: oldNeighbor)
            self.neighbors[index] = newNeighbor
        }
        
        @inline(__always)
        mutating func update(vertex: Vertex) {
            for i in 0...2 {
                if self.vertices[i].index == vertex.index {
                    self.vertices[i] = vertex
                    return
                }
            }
        }
        
        @inline(__always)
        func neighbor(vertex: Index) -> Index {
            var index = null
            self.vertices.withUnsafeBufferPointer { buffer in
                for i in 0...2 {
                    if buffer[i].index == vertex {
                        index = self.neighbors[i]
                        return
                    }
                }
                assertionFailure("Point is not present")
            }

            return index
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
