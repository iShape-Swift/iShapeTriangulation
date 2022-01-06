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
        var vertices: Array3d<Vertex>
        
        // BC - a(0), AC - b(1), AB - c(2)
        var neighbors: Array3d<Index>

        init() {
            self.index = null
            self.vertices = Array3d(.empty, .empty, .empty)
            self.neighbors = Array3d(null, null, null)
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex) {
            self.index = index
            self.vertices = Array3d(a, b, c)
            self.neighbors = Array3d(null, null, null)
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, bc: Index) {
            self.index = index
            self.vertices = Array3d(.empty, .empty, .empty)
            self.neighbors = Array3d(bc, null, null)
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, ac: Index, ab: Index) {
            self.index = index
            self.vertices = Array3d(a, b, c)
            self.neighbors = Array3d(null, ac, ab)
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        init(index: Index, a: Vertex, b: Vertex, c: Vertex, bc: Index, ac: Index, ab: Index) {
            self.index = index
            self.vertices = Array3d(a, b, c)
            self.neighbors = Array3d(bc, ac, ab)
            assert(IntTriangle.isCCW_or_Line(a: a.point, b: b.point, c: c.point), "Triangle's points are not clock-wise ordered")
        }
        
        @inline(__always)
        func vertex(neighbor: Index) -> Vertex {
            if neighbors.a == neighbor {
                return vertices.a
            } else if neighbors.b == neighbor {
                return vertices.b
            } else if neighbors.c == neighbor {
                return vertices.c
            }
            
            assertionFailure("Neighbor is not present")
            
            return Vertex.empty
        }
        
        @inline(__always)
        func opposite(neighbor: Index) -> Index {
            if neighbors.a == neighbor {
                return 0
            } else if neighbors.b == neighbor {
                return 1
            } else if neighbors.c == neighbor {
                return 2
            }
            assertionFailure("Neighbor is not present")
            
            return null
        }
        
        @inline(__always)
        func adjacentNeighbor(vertex: Index, neighbor: Index) -> Index {
            if vertices.a.index != vertex && neighbors.a != neighbor {
                return 0
            } else if vertices.b.index != vertex && neighbors.b != neighbor {
                return 1
            } else if vertices.c.index != vertex && neighbors.c != neighbor {
                return 2
            }

            assertionFailure("Neighbor is not present")
            return null
        }
        
        @inline(__always)
        func index(index: Index) -> Index {
            if vertices.a.index == index {
                return 0
            } else if vertices.b.index == index {
                return 1
            } else {
                return 2
            }
        }
        
        @inline(__always)
        mutating func updateOpposite(oldNeighbor: Index, newNeighbor: Index) {
            let index = self.opposite(neighbor: oldNeighbor)
            self.neighbors[index] = newNeighbor
        }
        
        @inline(__always)
        mutating func update(vertex: Vertex) {
            if vertices.a.index == vertex.index {
                vertices.a = vertex
            } else if vertices.b.index == vertex.index {
                vertices.b = vertex
            } else if vertices.c.index == vertex.index {
                vertices.c = vertex
            }
        }
        
        @inline(__always)
        func neighbor(vertex: Index) -> Index {
            if vertices.a.index == vertex {
                return self.neighbors.a
            } else if vertices.b.index == vertex {
                return self.neighbors.b
            } else if vertices.c.index == vertex {
                return self.neighbors.c
            }
            
            assertionFailure("Point is not present")
            
            return null
        }
    }
    
    public var trianglesIndices: [Int] {
        var result = Array<Int>(repeating: -1, count: 3 * triangles.count)
        var j = 0
        for triangle in triangles {
            result[j] = triangle.vertices.a.index
            result[j + 1] = triangle.vertices.b.index
            result[j + 2] = triangle.vertices.c.index
            j += 3
        }
        
        return result
    }

    struct Array3d<T> {
        
        var a: T
        var b: T
        var c: T
        
        fileprivate init (_ a: T, _ b: T, _ c: T) {
            self.a = a
            self.b = b
            self.c = c
        }
        
        @inline(__always)
        subscript(index: Int) -> T {
            get {
                switch index {
                    case 0:
                        return a
                    case 1:
                        return b
                    default:
                        return c
                }
            }
            set {
                switch index {
                    case 0:
                        a = newValue
                    case 1:
                        b = newValue
                    default:
                        c = newValue
                }
            }
        }
    }
}
