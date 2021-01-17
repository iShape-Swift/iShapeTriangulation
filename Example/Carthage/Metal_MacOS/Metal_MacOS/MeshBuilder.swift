//
//  MeshBuilder.swift
//  Metal_MacOS
//
//  Created by Nail Sharipov on 11.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import iGeometry
import iShapeTriangulation
import MetalKit

final class MeshBuilder {

    struct Mesh {
        let vertexBuffer: MTLBuffer
        let indexBuffer: MTLBuffer
        let count: Int
    }
    
    private var k: Float = 0
    private var d: Float = 0.005
    private let n = 1024
    private let radius: Float = 0.6
    private let triangulator = Triangulator(iGeom: .defGeom)

    func next(device: MTLDevice) -> Mesh {
        if k < -0.5 {
            d = 0.005
        } else if k > 0.5 {
            d = -0.005
        }
        
        k += d
        
        let da0 = 2 * Float.pi / Float(n)
        let da1 = 16 * Float.pi / Float(n)
        let delta = k * radius

        var hull = Array<Point>(repeating: .zero, count: n)

        var a0: Float = 0
        var a1: Float = 0

        for i in 0..<n {
            let r = radius + delta * sin(a1)
            let x = r * cos(a0)
            let y = r * sin(a0)
            a0 -= da0
            a1 -= da1
            hull[i] = Point(x: x, y: y)
        }

        var hole = Array<Point>(repeating: .zero, count: n)

        for i in 0..<n {
            let v = hull[n - i - 1]
            hole[i] = Point(x: 0.5 * v.x, y: 0.5 * v.y)
        }
        
        let points = hull + hole
        let indices = triangulator.triangulateDelaunay(points: points, hull: points[0..<hull.count], holes: [points[hull.count...]], extraPoints: nil).map( { uint16($0) })
        
        let vertexSize = points.count * MemoryLayout.size(ofValue: points[0])
        let vertexBuffer = device.makeBuffer(bytes: points, length: vertexSize, options: [.cpuCacheModeWriteCombined])!

        let indexSize = indices.count * MemoryLayout.size(ofValue: indices[0])
        let indexBuffer = device.makeBuffer(bytes: indices, length: indexSize, options: [.cpuCacheModeWriteCombined])!
        
        return Mesh(vertexBuffer: vertexBuffer, indexBuffer: indexBuffer, count: indices.count)
    }

}

