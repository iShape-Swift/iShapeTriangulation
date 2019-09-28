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
    
    public static func triangulate(hull: [CGPoint], holes: [[CGPoint]], precision: CGFloat = 0.0001) -> [Int] {
        let iGeom = IntGeom(scale: Float(1 / precision))
        let shape = Shape(hull: hull.toPoints(), holes: holes.toPaths())
        let iShape = IntShape(shape: shape, iGeom: iGeom)
        let pShape = PlainShape(iShape: iShape)
        return pShape.triangulate()
    }

    public static func triangulateDelaunay(hull: [CGPoint], holes: [[CGPoint]], precision: CGFloat = 0.0001) -> [Int] {
        let iGeom = IntGeom(scale: Float(1 / precision))
        let shape = Shape(hull: hull.toPoints(), holes: holes.toPaths())
        let iShape = IntShape(shape: shape, iGeom: iGeom)
        let pShape = PlainShape(iShape: iShape)
        return pShape.triangulateDelaunay()
    }
    
    public static func triangulate(hull: [Point], holes: [[Point]], precision: Float = 0.0001) -> [Int] {
        let iGeom = IntGeom(scale: 1 / precision)
        let shape = Shape(hull: hull, holes: holes)
        let iShape = IntShape(shape: shape, iGeom: iGeom)
        let pShape = PlainShape(iShape: iShape)
        return pShape.triangulate()
    }

    public static func triangulateDelaunay(hull: [Point], holes: [[Point]], precision: Float = 0.0001) -> [Int] {
        let iGeom = IntGeom(scale: 1 / precision)
        let shape = Shape(hull: hull, holes: holes)
        let iShape = IntShape(shape: shape, iGeom: iGeom)
        let pShape = PlainShape(iShape: iShape)
        return pShape.triangulateDelaunay()
    }
}
