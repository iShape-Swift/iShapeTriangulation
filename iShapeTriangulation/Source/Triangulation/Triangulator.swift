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
    
    public init(precision: CGFloat = 0.0001) {
        self.iGeom = IntGeom(scale: Float(1 / precision))
    }
    
    public func triangulate(points: [CGPoint], hull: ArraySlice<CGPoint>?, holes: [ArraySlice<CGPoint>]?) -> [Int] {
        
        let intPoints = iGeom.int(points: points.toPoints())

        var layouts = [PlainShape.Layout]()

        if let hull = hull, let holes = holes {
            layouts.reserveCapacity(holes.count + 1)
            layouts.append(PlainShape.Layout(begin: 0, end: hull.endIndex - 1, isHole: false))
            for hole in holes {
                layouts.append(PlainShape.Layout(begin: hole.startIndex , end: hole.endIndex - 1, isHole: true))
            }
        } else {
            layouts.append(PlainShape.Layout(begin: 0, end: intPoints.count - 1, isHole: false))
        }

        let shape = PlainShape(points: intPoints, layouts: layouts)
        
        return shape.triangulate()
    }
    
    public func triangulateDelaunay(points: [CGPoint], hull: ArraySlice<CGPoint>?, holes: [ArraySlice<CGPoint>]?) -> [Int] {
        let intPoints = iGeom.int(points: points.toPoints())

        var layouts = [PlainShape.Layout]()

        if let hull = hull, let holes = holes {
            layouts.reserveCapacity(holes.count + 1)
            layouts.append(PlainShape.Layout(begin: 0, end: hull.endIndex - 1, isHole: false))
            for hole in holes {
                layouts.append(PlainShape.Layout(begin: hole.startIndex , end: hole.endIndex - 1, isHole: true))
            }
        } else {
            layouts.append(PlainShape.Layout(begin: 0, end: intPoints.count - 1, isHole: false))
        }

        let shape = PlainShape(points: intPoints, layouts: layouts)
        
        return shape.triangulateDelaunay()
    }
    
    public func triangulate(points: [Point], hull: ArraySlice<Point>?, holes: [ArraySlice<Point>]?) -> [Int] {
        let intPoints = iGeom.int(points: points)

        var layouts = [PlainShape.Layout]()

        if let hull = hull, let holes = holes {
            layouts.reserveCapacity(holes.count + 1)
            layouts.append(PlainShape.Layout(begin: 0, end: hull.endIndex - 1, isHole: false))
            for hole in holes {
                layouts.append(PlainShape.Layout(begin: hole.startIndex , end: hole.endIndex - 1, isHole: true))
            }
        } else {
            layouts.append(PlainShape.Layout(begin: 0, end: intPoints.count - 1, isHole: false))
        }

        let shape = PlainShape(points: intPoints, layouts: layouts)
        
        return shape.triangulate()
    }
    
    public func triangulateDelaunay(points: [Point], hull: ArraySlice<Point>?, holes: [ArraySlice<Point>]?) -> [Int] {
        let intPoints = iGeom.int(points: points)

        var layouts = [PlainShape.Layout]()

        if let hull = hull, let holes = holes {
            layouts.reserveCapacity(holes.count + 1)
            layouts.append(PlainShape.Layout(begin: 0, end: hull.endIndex - 1, isHole: false))
            for hole in holes {
                layouts.append(PlainShape.Layout(begin: hole.startIndex , end: hole.endIndex - 1, isHole: true))
            }
        } else {
            layouts.append(PlainShape.Layout(begin: 0, end: intPoints.count - 1, isHole: false))
        }

        let shape = PlainShape(points: intPoints, layouts: layouts)
        
        return shape.triangulateDelaunay()
    }

}
