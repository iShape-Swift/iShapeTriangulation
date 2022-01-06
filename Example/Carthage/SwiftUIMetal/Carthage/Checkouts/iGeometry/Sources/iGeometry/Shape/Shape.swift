//
//  Shape.swift
//  iGeometry
//
//  Created by Nail Sharipov on 23/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

public struct Shape {
    
    public static let empty = Shape(hull: [], holes: [])
    
    public var hull: [Point]
    public var holes: [[Point]]
    
    public init(shape: IntShape, iGeom: IntGeom = .defGeom) {
        self.hull = iGeom.float(points: shape.hull)
        self.holes = iGeom.float(paths: shape.holes)
    }
    
    public init(hull: [Point], holes: [[Point]]) {
        self.hull = hull
        self.holes = holes
    }
}
