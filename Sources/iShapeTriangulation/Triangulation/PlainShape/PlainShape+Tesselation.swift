//
//  PlainShape+Tesselation.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 28.09.2020.
//

import iGeometry

public extension PlainShape {
    
    struct Tessellation {
        public let indices: [Int]
        public let extraPoints: [IntPoint]
    }
    
    /// Tesselate polygon
    /// - Parameters:
    ///   - extraPoints: extra points (inside points)
    ///   - minEdge: minimal possible triangle edge
    ///   - maxEdge: maximal possible triangle edge
    ///   - maxAngle: maximal possible triangle angle
    ///   - mergeAngle: maximal possible triangle angle for border triangle
    /// - Returns: Tessellation result
    mutating func tessellate(extraPoints: [IntPoint]? = nil, minEdge: Int64, maxEdge: Int64 = 0, maxAngle: Float = 0.55 * Float.pi, mergeAngle: Float = 0.65 * Float.pi) -> Tessellation {
        if maxEdge > 0 {
            self.modify(maxEgeSize: maxEdge)
        }
        
        var delaunay = self.delaunay(extraPoints: extraPoints)

        let vertices = delaunay.tessellate(minEdge: minEdge, maxAngle: maxAngle, mergeAngle: mergeAngle)
        let indices = delaunay.trianglesIndices
        let newPoints = vertices.map({ $0.point })
        
        return Tessellation(indices: indices, extraPoints: newPoints)
    }
}
