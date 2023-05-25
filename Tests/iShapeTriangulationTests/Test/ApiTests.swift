//
//  ApiTests.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 14.05.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

import XCTest
import iGeometry
import iShapeTriangulation

final class ApiTests: XCTestCase {
    
    func test_00() throws {
        
        let shape = PlainShape(
            hull: [
                // hule vertices list in clockwise direction
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 5),
                Point(x: 10, y: -5),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10),
                Point(x: -10, y: -5),
                Point(x: -10, y: 5),
            ],
            holes: [
                // holes vertices list in counterclockwise direction
                [
                    Point(x: -5, y: 0),
                    Point(x: 0, y: -5),
                    Point(x: 5, y: 0),
                    Point(x: 0, y: 5)
                ]
            ]
        )
        
        let delaunay = try shape.delaunay()
        
        let triangles = delaunay.trianglesIndices

        for i in 0..<triangles.count / 3 {
            let ai = triangles[3 * i]
            let bi = triangles[3 * i + 1]
            let ci = triangles[3 * i + 2]
            print("triangle \(i): (\(ai), \(bi), \(ci))")
        }
        
        
        XCTAssertEqual(triangles.compare(array: [6, 7, 8, 6, 8, 5, 7, 0, 8, 8, 0, 11, 11, 0, 1, 11, 1, 10, 8, 9, 5, 5, 9, 4, 9, 10, 4, 2, 10, 1, 10, 3, 4, 2, 3, 10]), true)
        
        let polygons = delaunay.convexPolygonsIndices
        
        var i = 0
        var j = 0
        while i < polygons.count {
            let n = polygons[i]
            var result = polygons[i + 1...i + n].reduce("", { $0 + "\($1), " })
            result.removeLast(2)
            print("polygon \(j): (\(result))")
            i += n + 1
            j += 1
        }
        
        
        XCTAssertEqual(polygons.compare(array: [6, 6, 7, 8, 9, 4, 5, 5, 7, 0, 1, 11, 8, 5, 11, 1, 2, 3, 10, 4, 9, 10, 3, 4]), true)
    }
   
    
    func test_01() {
        let triangulator = Triangulator()
        let points = [
            Point(x: -10, y: -10),
            Point(x: 10, y: -10),
            Point(x: 10, y: 10),
            Point(x: -10, y: 10)
        ]
        do {
            _ = try triangulator.triangulate(points: points)
        } catch TriangulationError.notValidPath(let validation) {
            switch validation {
            case .valid:
                XCTFail()
            case .hasSamePoints(_, _):
                XCTFail()
            case .hullIsNotClockWise:
                break
            case .holeIsNotCounterClockWise(_):
                XCTFail()
            case .hullIsSelfIntersecting(_, _):
                XCTFail()
            case .holeIsSelfIntersecting(_, _):
                XCTFail()
            case .hullIsIntersectingHole(_, _):
                XCTFail()
            case .holeIsIntersectingHole(_, _):
                XCTFail()
            }
        } catch {
            XCTFail()
        }
    }
    
}
