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

//final class ApiTests: XCTestCase {
    
    func test_0() {
        
        let shape = PlainShape(
            hull: [
                // hule vertices list in clockwise direction
                CGPoint(x: -5, y: 10),
                CGPoint(x: 5, y: 10),
                CGPoint(x: 10, y: 5),
                CGPoint(x: 10, y: -5),
                CGPoint(x: 5, y: -10),
                CGPoint(x: -5, y: -10),
                CGPoint(x: -10, y: -5),
                CGPoint(x: -10, y: 5),
            ],
            holes: [
                // holes vertices list in counterclockwise direction
                [
                    CGPoint(x: -5, y: 0),
                    CGPoint(x: 0, y: -5),
                    CGPoint(x: 5, y: 0),
                    CGPoint(x: 0, y: 5)
                ]
            ]
        )
        
        shape.delaunay(extraPoints: nil)
        
        
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
}
