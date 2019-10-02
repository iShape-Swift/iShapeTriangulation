//
//  iGeometryTests.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 28/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import XCTest
import iGeometry

final class iGeometryTests: XCTestCase {

    func testIntPoint_0() {
        let point = IntPoint(x: 0, y: 0)
        XCTAssertEqual(point.bitPack, 0)
    }
    
    func testIntPoint_1() {
        let point = IntPoint(x: 0, y: 1)
        XCTAssertEqual(point.bitPack, 1)
    }
    
    func testIntPoint_2() {
        let point = IntPoint(x: 1, y: 0)
        XCTAssertEqual(point.bitPack, 256*256*256*128)
    }
    
    func testIntGeom_0() {
        for x in -10...10 {
            for y in -10...10 {
                let origin = Point(x: Float(x), y: Float(y))
                let intPoint = IntGeom.defGeom.int(point: origin)
                let point = IntGeom.defGeom.float(point: intPoint)
                XCTAssertEqual(Int(point.x), x)
                XCTAssertEqual(Int(point.y), y)
            }
        }
    }
    
    func testIntGeom_1() {
        let a = Point(x: -100, y: 100)
        let b = Point(x: 100, y: -100)
        let iPoints = IntGeom.defGeom.int(points: [a, b])
        let points = IntGeom.defGeom.float(points: iPoints)
        
        XCTAssertEqual(points, [a, b])
    }
    
}
