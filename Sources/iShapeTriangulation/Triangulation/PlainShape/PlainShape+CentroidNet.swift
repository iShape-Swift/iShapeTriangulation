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
    ///   - extraPoints: extra points (inside points)
    ///   - onlyConvex: if true only convex polygons will be present in result
    ///   - minEdge: minimal possible triangle edge for tesselation
    ///   - maxEdge: maximal possible triangle edge for tesselation
    /// - Returns: array of polygons in a clock-wise-direction
    func makeCentroidNet(extraPoints: [IntPoint]? = nil, onlyConvex: Bool, minEdge: Int64, maxEdge: Int64 = 0, method: Delaunay.SplitMethod = .byEquilateralTriangle) -> [[IntPoint]] {
        var shape = self

        if maxEdge > 0 {
            shape.modify(maxEgeSize: maxEdge)
        }

        var delaunay = shape.delaunay(extraPoints: extraPoints)
        
        _ = delaunay.tessellate(minEdge: minEdge, maxAngle: 0.55 * Float.pi, mergeAngle: 0.7 * Float.pi, method: method)
        let centroidNet = delaunay.makeCentroidNet(onlyConvex: onlyConvex)

        return centroidNet
    }
}
