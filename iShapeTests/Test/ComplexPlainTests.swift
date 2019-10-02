//
//  ComplexPlainTests.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 02/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import XCTest
import iShapeTriangulation
import iGeometry

final class ComplexPlainTests: XCTestCase {

    private func triangulate(index: Int) -> [Int] {
        let iGeom = IntGeom()

        let data = ComplexTests.data[index]
        
        let hull = data[0]
        var holes = data
        holes.remove(at: 0)
        
        let shape = Shape(hull: hull, holes: holes)
        let iShape = IntShape(shape: shape, iGeom: iGeom)
        let pShape = PlainShape(iShape: iShape)

        let triangles = pShape.triangulate()
        
//        print(triangles.prettyString)
        
        return triangles
    }

    func testIntPoint_00() {
        let triangles = self.triangulate(index: 0)
        
        let origin = [
                0, 1, 3,
                1, 2, 3
            ]

        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_01() {
        let triangles = self.triangulate(index: 1)
        let origin = [
                1, 2, 0,
                0, 2, 4,
                2, 3, 4
            ]
            
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_02() {
        let triangles = self.triangulate(index: 2)
        let origin = [
                0, 5, 6,
                0, 6, 3,
                6, 7, 3,
                0, 1, 5,
                1, 4, 5,
                1, 7, 4,
                1, 2, 7,
                7, 2, 3
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }

    func testIntPoint_03() {
        let triangles = self.triangulate(index: 3)
        let origin = [
                2, 3, 1,
                0, 1, 3
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_04() {
        let triangles = self.triangulate(index: 4)
        let origin = [
                0, 1, 4,
                2, 4, 1,
                2, 3, 4
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_05() {
        let triangles = self.triangulate(index: 5)
        let origin = [
                0, 1, 4,
                2, 4, 1,
                2, 3, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
        
    }
    
    func testIntPoint_06() {
        let triangles = self.triangulate(index: 6)
        let origin = [
                0, 2, 3,
                0, 1, 2
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_07() {
        let triangles = self.triangulate(index: 7)
        let origin = [
                0, 1, 7,
                6, 7, 5,
                7, 1, 5,
                2, 3, 1,
                1, 3, 5,
                5, 3, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_08() {
        let triangles = self.triangulate(index: 8)
        let origin = [
                6, 7, 5,
                0, 1, 2,
                0, 2, 7,
                2, 5, 7,
                2, 3, 5,
                5, 3, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_09() {
        let triangles = self.triangulate(index: 9)
        let origin = [
                1, 2, 0,
                2, 3, 0,
                6, 7, 5,
                7, 0, 5,
                5, 3, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_10() {
        let triangles = self.triangulate(index: 10)
        let origin = [
                6, 7, 0,
                6, 0, 5,
                0, 4, 5,
                1, 2, 0,
                2, 4, 0,
                2, 3, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_11() {
        let triangles = self.triangulate(index: 11)
        let origin = [
                0, 1, 7,
                6, 7, 5,
                7, 1, 4,
                7, 4, 5,
                2, 3, 1,
                1, 3, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func testIntPoint_12() {
        let triangles = self.triangulate(index: 12)
        let origin = [
                0, 4, 7,
                4, 5, 7,
                6, 7, 5,
                2, 3, 1,
                0, 1, 4,
                4, 1, 3
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func testIntPoint_13() {
        let triangles = self.triangulate(index: 13)
        let origin = [
                0, 1, 11,
                10, 11, 9,
                11, 1, 9,
                9, 6, 7,
                9, 7, 8,
                2, 3, 1,
                1, 3, 9,
                9, 3, 6,
                3, 5, 6,
                3, 4, 5
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func testIntPoint_14() {
        let triangles = self.triangulate(index: 14)
        let origin = [
                0, 1, 9,
                8, 9, 7,
                9, 1, 7,
                7, 5, 6,
                2, 3, 1,
                1, 5, 7,
                1, 3, 5,
                5, 3, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func testIntPoint_15() {
        let triangles = self.triangulate(index: 15)
        let origin = [
                4, 2, 3,
                4, 0, 2,
                0, 1, 2
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_16() {
        let triangles = self.triangulate(index: 16)
        let origin = [
                1, 2, 0,
                21, 34, 20,
                34, 35, 20,
                27, 28, 26,
                28, 16, 26,
                28, 29, 16,
                16, 29, 19,
                14, 15, 22,
                14, 22, 13,
                22, 23, 13,
                13, 23, 12,
                23, 24, 12,
                12, 24, 25,
                12, 26, 11,
                26, 16, 17,
                26, 17, 11,
                17, 10, 11,
                17, 9, 10,
                17, 18, 9,
                9, 18, 8,
                15, 21, 22,
                15, 0, 21,
                21, 2, 34,
                2, 33, 34,
                2, 3, 32,
                32, 3, 31,
                3, 30, 31,
                3, 4, 30,
                30, 4, 29,
                4, 19, 29,
                4, 5, 19,
                19, 5, 18,
                5, 6, 18,
                18, 6, 8,
                8, 6, 7
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func testIntPoint_17() {
        let triangles = self.triangulate(index: 17)
        let origin = [
                6, 7, 5,
                7, 8, 5,
                7, 0, 8,
                8, 0, 11,
                0, 1, 10,
                5, 8, 9,
                5, 9, 4,
                9, 10, 4,
                4, 1, 3,
                1, 2, 3
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
}