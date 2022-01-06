//
//  IntShape.swift
//  iGeometry
//
//  Created by Nail Sharipov on 23/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

public struct IntShape {
    
    public static let empty = IntShape(hull: [], holes: [])
    
    public var hull: [IntPoint]
    public var holes: [[IntPoint]]
    
    public init(shape: Shape, iGeom: IntGeom = .defGeom) {
        self.hull = iGeom.int(points: shape.hull)
        self.holes = iGeom.int(paths: shape.holes)
    }
    
    public init(plainShape: PlainShape) {
        let hullLayout = plainShape.layouts[0]
        self.hull = Array(plainShape.points[0...hullLayout.end])
        
        let holesCount = plainShape.layouts.count - 1
        var holes = [[IntPoint]]()
        holes.reserveCapacity(holesCount)
        if holesCount > 0 {
            for i in 0..<holesCount {
                let layout = plainShape.layouts[i + 1]
                holes.append(Array(plainShape.points[layout.begin...layout.end]))
            }
        }
        
        self.holes = holes
    }
    
    public init(hull: [IntPoint], holes: [[IntPoint]]) {
        self.hull = hull
        self.holes = holes
    }
    
}
