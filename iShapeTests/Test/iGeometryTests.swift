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
        XCTAssertEqual(point.bitPack, Int64(1) << IntGeom.maxBits)
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
    
    func testShapeList_00() {
        let a = PlainShape(iShape: IntShape(
            hull: [IntPoint(x: 10, y: 20), IntPoint(x: 30, y: 40), IntPoint(x: 50, y: 60)],
            holes: [
                [IntPoint(x: 0, y: 1), IntPoint(x: 2, y: 3), IntPoint(x: 4, y: 5), IntPoint(x: 6, y: 7)],
                [IntPoint(x: 8, y: 9), IntPoint(x: 11, y: 12), IntPoint(x: 13, y: 14)]
            ]
        ))
        let b = PlainShape(iShape: IntShape(
            hull: [IntPoint(x: 70, y: 80), IntPoint(x: 90, y: 100), IntPoint(x: 110, y: 120)],
            holes: [
                [IntPoint(x: 15, y: 16), IntPoint(x: 17, y: 18), IntPoint(x: 19, y: 21), IntPoint(x: 22, y: 23), IntPoint(x: 24, y: 25)],
                [IntPoint(x: 26, y: 27), IntPoint(x: 28, y: 29), IntPoint(x: 31, y: 32), IntPoint(x: 33, y: 34)],
                [IntPoint(x: 35, y: 36), IntPoint(x: 37, y: 38), IntPoint(x: 39, y: 41), IntPoint(x: 42, y: 43)]
            ]
        ))
        let c = PlainShape(iShape: IntShape(
            hull: [IntPoint(x: 130, y: 140), IntPoint(x: 150, y: 160), IntPoint(x: 170, y: 180)],
            holes: []
        ))
        
        var shapeList = PlainShapeList(minimumPointsCapacity: 10, minimumLayoutsCapacity: 4, minimumSegmentsCapacity: 2)
        shapeList.add(plainShape: a)
        shapeList.add(plainShape: b)
        shapeList.add(plainShape: c)
        
        let a0 = shapeList.get(index: 0)
        let b0 = shapeList.get(index: 1)
        let c0 = shapeList.get(index: 2)
        
        XCTAssertEqual(a0, a)
        XCTAssertEqual(b0, b)
        XCTAssertEqual(c0, c)
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
                [Point(x: 1, y: -5), Point(x: 5, y: -5), Point(x: 5, y: 5), Point(x: 1, y: 5)],
                [Point(x: -5, y: -5), Point(x: -1, y: -5), Point(x: -1, y: 5), Point(x: -5, y: 5)]
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
