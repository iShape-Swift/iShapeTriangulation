//
//  IntPoint+Math.swift
//  iGeometry
//
//  Created by Nail Sharipov on 04/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

public extension IntPoint {
    
    static func +(left: IntPoint, right: IntPoint) -> IntPoint {
        return IntPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func -(left: IntPoint, right: IntPoint) -> IntPoint {
        return IntPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    @inline(__always)
    func scalarMultiply(point: IntPoint) -> Int64 { // dot product
        return self.x * point.x + point.y * self.y
    }
    
    @inline(__always)
    func crossProduct(point: IntPoint) -> Int64 { // cross product
        return self.x * point.y - self.y * point.x
    }
    
    @inline(__always)
    func normal(iGeom: IntGeom) -> IntPoint {
        let p = iGeom.float(point: self)
        let l = (p.x * p.x + p.y * p.y).squareRoot()
        let k = 1 / l
        let x = k * p.x
        let y = k * p.y
        
        return iGeom.int(point: Point(x: x, y: y))
    }
    
    @inline(__always)
    func sqrDistance(point: IntPoint) -> Int64 {
        let dx = point.x - self.x
        let dy = point.y - self.y

        return dx * dx + dy * dy
    }
}
