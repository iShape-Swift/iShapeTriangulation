//
//  Triangulator.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 28/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import Foundation
import iGeometry

public struct Triangulator {
    
    public let iGeom: IntGeom
    
    /// Creates a new triangulator with the specified precision
    /// - Parameter precision: The minimum required precision. It's a minimum linear distance after which points will be recognized as the same.
    /// For example with precision = 0.1 points (1; 1), (1; 0.05) will be equal
    /// Keep in mind that your maximum point length depend on this value by the formula: precision * 10^9
    /// For example:
    /// with precision = 0.1 your maximum allowed point is (100kk, 100kk)
    /// with precision = 0.0001 your maximum allowed point is (100k, 100k)
    /// with precision = 0.0000001 your maximum allowed point is (100, 100)
    /// If your broke this rule, the calculation will be undefinied
    public init(precision: CGFloat = 0.0001) {
        self.iGeom = IntGeom(scale: Float(1 / precision))
    }
    
    
    /// Makes plain triangulation for polygon
    /// - Parameter points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    /// - Parameter hull: range of the hull vertices in points array
    /// - Parameter holes: array of ranges for all holes
    /// - Parameter extraPoints: extra points for tessellation
    public func triangulate(points: [CGPoint], hull: ArraySlice<CGPoint>, holes: [ArraySlice<CGPoint>]?, extraPoints: [CGPoint]?) -> [Int] {
        let shape = PlainShape(iGeom: iGeom, points: points, hull: hull, holes: holes)
        if let ePoints = extraPoints {
            let iPoints = iGeom.int(points: ePoints.toPoints())
            return shape.triangulate(extraPoints: iPoints)
        }  else {
            return shape.triangulate(extraPoints: nil)
        }
    }
    
    /// Makes Delaunay triangulation for polygon
    /// - Parameter points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    /// - Parameter hull: range of the hull vertices in points array
    /// - Parameter holes: array of ranges for all holes
    /// - Parameter extraPoints: extra points for tessellation
    public func triangulateDelaunay(points: [CGPoint], hull: ArraySlice<CGPoint>, holes: [ArraySlice<CGPoint>]?, extraPoints: [CGPoint]?) -> [Int] {
        let shape = PlainShape(iGeom: iGeom, points: points, hull: hull, holes: holes)
        if let ePoints = extraPoints {
            let iPoints = iGeom.int(points: ePoints.toPoints())
            return shape.delaunay(extraPoints: iPoints).trianglesIndices
        }  else {
            return shape.delaunay(extraPoints: nil).trianglesIndices
        }
    }
    
    /// Break into convex polygons
    /// - Parameters:
    ///   - points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    ///   - hull: range of the hull vertices in points array
    ///   - holes: array of ranges for all holes
    ///   - extraPoints: extra points for tessellation
    public func polygonate(points: [CGPoint], hull: ArraySlice<CGPoint>, holes: [ArraySlice<CGPoint>]?, extraPoints: [CGPoint]?) -> [Int] {
        let shape = PlainShape(iGeom: iGeom, points: points, hull: hull, holes: holes)
        if let ePoints = extraPoints {
            let iPoints = iGeom.int(points: ePoints.toPoints())
            return shape.delaunay(extraPoints: iPoints).convexPolygonsIndices
        }  else {
            return shape.delaunay(extraPoints: nil).convexPolygonsIndices
        }
    }

    public struct TessellationResult {
        let indices: [Int]
        let extraPoints: [CGPoint]
    }

    /// Makes Delaunay triangulation for polygon
    /// - Parameter points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    /// - Parameter hull: range of the hull vertices in points array
    /// - Parameter holes: array of ranges for all holes
    /// - Parameter maxAngle: max possible triangle angle, must be in range (1...0.5)*pi
    /// - Parameter maxEdge: max possible triangle edge belong to the polygon edge
    /// - Parameter minEdge: min possible triangle edge
    public func tessellate(points: [CGPoint], hull: ArraySlice<CGPoint>, holes: [ArraySlice<CGPoint>]?, maxAngle: Float, maxEdge: CGFloat, minEdge: CGFloat) -> TessellationResult {
        var shape = PlainShape(iGeom: iGeom, points: points, hull: hull, holes: holes)
        shape.modify(maxEgeSize: iGeom.int(float: Float(maxEdge)))
        var delaunay = shape.delaunay()
        let vertices = delaunay.tessellate(maxAngle: maxAngle, minEdge: iGeom.int(float: Float(minEdge)))
        let indices = delaunay.trianglesIndices
        let extraPoints = vertices.map({ iGeom.float(point: $0.point).toCGPoint })
        return TessellationResult(indices: indices, extraPoints: extraPoints)
    }

}
