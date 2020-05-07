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
    public func triangulate(points: [CGPoint], hull: ArraySlice<CGPoint>?, holes: [ArraySlice<CGPoint>]?) -> [Int] {
        let shape = PlainShape(iGeom: iGeom, points: points, hull: hull, holes: holes)
        return shape.triangulate()
    }
    
    /// Makes Delaunay triangulation for polygon
    /// - Parameter points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    /// - Parameter hull: range of the hull vertices in points array
    /// - Parameter holes: array of ranges for all holes
    public func triangulateDelaunay(points: [CGPoint], hull: ArraySlice<CGPoint>?, holes: [ArraySlice<CGPoint>]?) -> [Int] {
        let shape = PlainShape(iGeom: iGeom, points: points, hull: hull, holes: holes)
        return shape.delaunay().trianglesIndices
    }
    
    /// Break into convex polygons
    /// - Parameters:
    ///   - points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    ///   - hull: range of the hull vertices in points array
    ///   - holes: array of ranges for all holes
    public func polygonate(points: [CGPoint], hull: ArraySlice<CGPoint>?, holes: [ArraySlice<CGPoint>]?) -> [Int] {
        let shape = PlainShape(iGeom: iGeom, points: points, hull: hull, holes: holes)
        return shape.delaunay().convexPolygonsIndices
    }

}

public extension PlainShape {

    /// Data to represent complex shape
    /// - Parameters:
    ///   - precision: The minimum required precision. It's a minimum linear distance after which points will be recognized as the same.
    ///   - points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    ///   - hull: range of the hull vertices in points array
    ///   - holes: array of ranges for all holes
    init(precision: CGFloat = 0.0001, points: [CGPoint], hull: ArraySlice<CGPoint>?, holes: [ArraySlice<CGPoint>]?) {
        self.init(iGeom: IntGeom(scale: Float(1 / precision)), points: points, hull: hull, holes: holes)
    }
    
    /// Data to represent complex shape
    /// - Parameters:
    ///   - iGeom: Int <-> Float converter
    ///   - points: Linear array of all your polygon vertices. All hull's vertices must be list in clockwise order. All holes vertices must be list in counterclockwise order.
    ///   - hull: range of the hull vertices in points array
    ///   - holes: array of ranges for all holes
    init(iGeom: IntGeom, points: [CGPoint], hull: ArraySlice<CGPoint>?, holes: [ArraySlice<CGPoint>]?) {
        let intPoints = iGeom.int(points: points.toPoints())

        var layouts = [PlainShape.Layout]()

        if let hull = hull, let holes = holes {
            layouts.reserveCapacity(holes.count + 1)
            layouts.append(PlainShape.Layout(begin: 0, length: hull.endIndex, isClockWise: true))
            for hole in holes {
                let length = hole.endIndex - hole.startIndex
                layouts.append(PlainShape.Layout(begin: hole.startIndex, length: length, isClockWise: false))
            }
        } else {
            layouts.append(PlainShape.Layout(begin: 0, length: intPoints.count, isClockWise: true))
        }
        self.init(points: intPoints, layouts: layouts)
    }

}
