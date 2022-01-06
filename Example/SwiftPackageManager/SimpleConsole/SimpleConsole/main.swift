//
//  main.swift
//  SimpleConsole
//
//  Created by Nail Sharipov on 06.01.2022.
//

import iGeometry
import iShapeTriangulation

// plain

print("plain:")

let path = [
    // vertices listed in clockwise direction
    Point(x: 0, y: 20),       // 0
    Point(x: 8, y: 10),       // 1
    Point(x: 7, y: 6),        // 2
    Point(x: 9, y: 1),        // 3
    Point(x: 13, y: -1),      // 4
    Point(x: 17, y: 1),       // 5
    Point(x: 26, y: -7),      // 6
    Point(x: 14, y: -15),     // 7
    Point(x: 0, y: -18),      // 8
    Point(x: -14, y: -15),    // 9
    Point(x: -25, y: -7),     // 10
    Point(x: -18, y: 0),      // 11
    Point(x: -16, y: -3),     // 12
    Point(x: -13, y: -4),     // 13
    Point(x: -8, y: -2),      // 14
    Point(x: -6, y: 2),       // 15
    Point(x: -7, y: 6),       // 16
    Point(x: -10, y: 8)       // 17
]

let triangulator = Triangulator()
if let triangles = try? triangulator.triangulateDelaunay(points: path) {
    for i in 0..<triangles.count / 3 {
        let ai = triangles[3 * i]
        let bi = triangles[3 * i + 1]
        let ci = triangles[3 * i + 2]
        print("triangle \(i): (\(ai), \(bi), \(ci))")
    }
}

// delaunay

print("delaunay:")

let hole = [
    // vertices listed in counterclockwise direction
    Point(x: 2, y: 0),    // 18
    Point(x: -2, y: -2),  // 19
    Point(x: -4, y: -5),  // 20
    Point(x: -2, y: -9),  // 21
    Point(x: 2, y: -11),  // 22
    Point(x: 5, y: -9),   // 23
    Point(x: 7, y: -5),   // 24
    Point(x: 5, y: -2)    // 25
]

let points = path + hole
if let triangles = try? triangulator.triangulateDelaunay(points: points, hull: points[0..<path.count], holes: [points[path.count..<points.count]], extraPoints: nil) {
    for i in 0..<triangles.count / 3 {
        let ai = triangles[3 * i]
        let bi = triangles[3 * i + 1]
        let ci = triangles[3 * i + 2]
        print("triangle \(i): (\(ai), \(bi), \(ci))")
    }
}


