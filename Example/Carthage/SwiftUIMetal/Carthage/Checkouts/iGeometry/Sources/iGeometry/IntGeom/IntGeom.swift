//
//  IntGeom.swift
//  iGeometry
//
//  Created by Nail Sharipov on 23/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

public struct IntGeom {
    
    public static let defGeom = IntGeom()
    
    public static let maxBits = 31
    public let scale: Float
    public let invertScale: Float
    public let sqrInvertScale: Float
    
    public init(scale: Float = 10000) {
        self.scale = scale
        self.invertScale = 1 / scale
        self.sqrInvertScale = 1 / scale / scale
    }

    public func int(float: Float) -> Int64 {
        Int64((float * scale).rounded(.toNearestOrAwayFromZero))
    }
    
    public func sqrInt(float: Float) -> Int64 {
        Int64((float * scale * scale).rounded(.toNearestOrAwayFromZero))
    }
    
    public func int(point: Point) -> IntPoint {
        IntPoint(x: Int64((point.x * scale).rounded(.toNearestOrAwayFromZero)), y: Int64((point.y * scale).rounded(.toNearestOrAwayFromZero)))
    }
    
    public func int(points: [Point]) -> [IntPoint] {
        let n = points.count
        var array = Array<IntPoint>(repeating: .zero, count: n)
        var i = 0
        while i < n {
            let point = points[i]
            array[i] = IntPoint(x: Int64((point.x * scale).rounded(.toNearestOrAwayFromZero)), y: Int64((point.y * scale).rounded(.toNearestOrAwayFromZero)))
            i &+= 1
        }
        return array
    }
    
    public func int(paths: [[Point]]) -> [[IntPoint]] {
        let n = paths.count
        var array = [[IntPoint]]()
        array.reserveCapacity(n)
        var i = 0
        while i < n {
            array.append(self.int(points: paths[i]))
            i &+= 1
        }
        return array
    }
    
    public func float(int: Int64) -> Float {
        Float(int) * invertScale
    }
    
    public func sqrFloat(int: Int64) -> Float {
        Float(int) * sqrInvertScale
    }
    
    public func float(point: IntPoint) -> Point {
        Point(x: Float(point.x) * invertScale, y: Float(point.y) * invertScale)
    }
    
    public func float(points: [IntPoint]) -> [Point] {
        let n = points.count
        var array = Array<Point>(repeating: .zero, count: n)
        var i = 0
        while i < n {
            let point = points[i]
            array[i] = Point(x: Float(point.x) * invertScale, y: Float(point.y) * invertScale)
            i &+= 1
        }
        return array
    }
    
    public func float(paths: [[IntPoint]]) -> [[Point]] {
        let n = paths.count
        var array = [[Point]]()
        array.reserveCapacity(n)
        var i = 0
        while i < n {
            array.append(self.float(points: paths[i]))
            i &+= 1
        }
        return array
    }
}
