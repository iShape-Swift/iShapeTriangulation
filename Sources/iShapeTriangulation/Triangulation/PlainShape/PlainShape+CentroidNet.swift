//
//  PlainShape+CentroidNet.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 28.09.2020.
//


import iGeometry

public extension PlainShape {
    
    /// Make CentroidNet for polygon
    /// - Parameters:
    ///   - iGeom: iGeom
    ///   - onlyConvex: if true only convex polygons will be present in result, the nonconvex polygons will be splitted into convex polygons
    ///   - maxEdge: maximal possible triangle edge for tessellation
    ///   - maxArea: maximum possible triangle area, triangles with higher area will be splitted
    ///   - minArea: the polygons with lower area will be not included
    ///   - extraPoints: extra points (inside points)
    /// - Returns: array of polygons in a clock-wise-direction
    func makeCentroidNet(iGeom: IntGeom, onlyConvex: Bool, maxEdge: Float, maxArea max: Float? = nil, minArea: Float = 0, extraPoints: [IntPoint]? = nil) -> [[IntPoint]] {
        let iEdge = iGeom.int(float: maxEdge)
        var delaunay = self.delaunay(maxEdge: iEdge, extraPoints: extraPoints)
        let maxArea: Float
        if let max = max {
            maxArea = max
        } else {
            maxArea = 0.4 * maxEdge * maxEdge
        }
        
        delaunay.tessellate(iGeom: iGeom, maxArea: maxArea)

        let iMinArea = iGeom.sqrInt(float: minArea)
        
        let centroidNet = delaunay.makeCentroidNet(minArea: iMinArea, onlyConvex: onlyConvex)

        return centroidNet
    }
}
