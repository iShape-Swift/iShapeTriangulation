//
//  TriangulatorTests.swift
//  iShapeUITests
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
        
        let triangles = Triangulator.triangulateDelaunay(points: points, hull: hule, holes: [hole])
        
        print(triangles)
        
//        XCTAssertEqual(a, 0)
    }


}
