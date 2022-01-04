//
//  PlainShape+Tessellation.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 28.09.2020.
//

import iGeometry

public extension PlainShape {
    
    /// Tessellate polygon
    /// - Parameters:
    ///   - iGeom: iGeom
    ///   - maxEdge: maximal possible triangle edge
    ///   - maxArea: maximum possible triangle area, triangles with higher area will be splitted
    ///   - extraPoints: extra points (inside points)
    /// - Throws: `TessellationError`
    /// - Returns: Tessellation result
    mutating func tessellate(iGeom: IntGeom, maxEdge: Float, maxArea: Float? = nil, extraPoints: [IntPoint]? = nil) throws -> Delaunay {
        let iEdge = iGeom.int(float: maxEdge)
        var delaunay: Delaunay
        do {
            delaunay = try self.delaunay(maxEdge: iEdge, extraPoints: extraPoints)
        } catch DelaunayError.notValidPath(let validation) {
            throw TessellationError.notValidPath(validation)
        }

        let area: Float
        if let maxArea = maxArea {
            area = maxArea
        } else {
            area = 0.4 * maxEdge * maxEdge
        }
 
        delaunay.tessellate(iGeom: iGeom, maxArea: area)
        
        return delaunay
    }
}
