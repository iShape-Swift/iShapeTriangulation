//
//  TriangulatorTests.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 29/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import XCTest
import iShapeTriangulation

final class TriangulatorTests: XCTestCase {

    func test_0() {
        let points = [
            CGPoint(x: -5, y: 10),
            CGPoint(x: 5, y: 10),
            CGPoint(x: 10, y: 5),
            CGPoint(x: 10, y: -5),
            CGPoint(x: 5, y: -10),
            CGPoint(x: -5, y: -10),
            CGPoint(x: -10, y: -5),
            CGPoint(x: -10, y: 5),
            

            CGPoint(x: -5, y: 0),
            CGPoint(x: 0, y: -5),
            CGPoint(x: 5, y: 0),
            CGPoint(x: 0, y: 5),
        ]
        
        let hule = points[0...7]
        let hole = points[8...11]
        
        let triangles = Triangulator().triangulateDelaunay(points: points, hull: hule, holes: [hole])
        
        let template = [
            6, 7, 8,
            6, 8, 5,
            0, 8, 7,
            11, 8, 0,
            1, 11, 0,
            1, 10, 11,
            8, 9, 5,
            4, 5, 9,
            10, 4, 9,
            2, 10, 1,
            10, 3, 4,
            2, 3, 10
        ]
        
        XCTAssertEqual(triangles, template)
    }


}

