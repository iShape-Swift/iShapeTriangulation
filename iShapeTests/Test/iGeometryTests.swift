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

    func testIntPoint_00() {
        let point = IntPoint(x: 0, y: 0)
        XCTAssertEqual(point.bitPack, 0)
    }
    
    func testIntPoint_01() {
        let point = IntPoint(x: 0, y: 1)
        XCTAssertEqual(point.bitPack, 1)
    }
    
    func testIntPoint_02() {
        let point = IntPoint(x: 1, y: 0)
        XCTAssertEqual(point.bitPack, 256*256*256*128)
    }
    
    func testIntGeom_00() {
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
    
    func testIntGeom_01() {
        let a = Point(x: -100, y: 100)
        let b = Point(x: 100, y: -100)
        let iPoints = IntGeom.defGeom.int(points: [a, b])
        let points = IntGeom.defGeom.float(points: iPoints)
        
        XCTAssertEqual(points, [a, b])
    }
    
    func testValidation_00() {
        let shape = Shape(hull: [Point(x: -1, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 0)], holes: [])
        let iShape = IntShape(shape: shape)
        let pShape = PlainShape(iShape: iShape)
        
        let isValid: Bool
        if case .valid = pShape.validate() {
            isValid = true
        } else {
            isValid = false
        }
        
        XCTAssertEqual(isValid, true)
    }
    
    func testValidation_01() {
        let shape = Shape(hull: [Point(x: -1, y: 0), Point(x: 0, y: -1), Point(x: 1, y: 0)], holes: [])
        let iShape = IntShape(shape: shape)
        let pShape = PlainShape(iShape: iShape)
        
        let isValid: Bool
        if case .valid = pShape.validate() {
            isValid = true
        } else {
            isValid = false
        }
        
        XCTAssertEqual(isValid, false)
    }
    
    func testValidation_02() {
        let shape = Shape(
            hull: [Point(x: -10, y: -10), Point(x: -10, y: 10), Point(x: 10, y: 10), Point(x: 10, y: -10)],
            holes: [
                [Point(x: -5, y: -5), Point(x: -5, y: 5), Point(x: 0, y: 5), Point(x: 0, y: -5)],
                [Point(x: 0, y: -5), Point(x: 5, y: -5), Point(x: 5, y: 5), Point(x: 0, y: 5)]
            ]
        )
        let iShape = IntShape(shape: shape)
        let pShape = PlainShape(iShape: iShape)
        
        let validation = pShape.validate()

        let isValid: Bool
        switch validation {
        case .valid:
            isValid = true
        case let .holeIsNotCounterClockWise(index):
            XCTAssertEqual(index, 0)
            isValid = false
        default:
            isValid = false
        }

        XCTAssertEqual(isValid, false)
    }
    
    func testValidation_03() {
        let shape = Shape(
            hull: [Point(x: -10, y: -10), Point(x: -10, y: 10), Point(x: 10, y: 10), Point(x: 10, y: -10)],
            holes: [
                [Point(x: 0, y: -5), Point(x: 5, y: -5), Point(x: 5, y: 5), Point(x: 0, y: 5)],
                [Point(x: -5, y: -5), Point(x: -5, y: 5), Point(x: 0, y: 5), Point(x: 0, y: -5)]
            ]
        )
        let iShape = IntShape(shape: shape)
        let pShape = PlainShape(iShape: iShape)
        
        let validation = pShape.validate()

        let isValid: Bool
        switch validation {
        case .valid:
            isValid = true
        case let .holeIsNotCounterClockWise(index):
            XCTAssertEqual(index, 1)
            isValid = false
        default:
            isValid = false
        }

        XCTAssertEqual(isValid, false)
    }
    
    func testValidation_04() {
        let shape = Shape(
            hull: [Point(x: -10, y: -10), Point(x: -10, y: 10), Point(x: 10, y: 10), Point(x: 10, y: -10)],
            holes: [
                [Point(x: 0, y: -5), Point(x: 5, y: -5), Point(x: 5, y: 5), Point(x: 0, y: 5)],
                [Point(x: -5, y: -5), Point(x: 0, y: -5), Point(x: 0, y: 5), Point(x: -5, y: 5)]
            ]
        )
        let iShape = IntShape(shape: shape)
        let pShape = PlainShape(iShape: iShape)
        
        let validation = pShape.validate()

        let isValid: Bool
        switch validation {
        case .valid:
            isValid = true
        default:
            isValid = false
        }

        XCTAssertEqual(isValid, true)
    }
}
