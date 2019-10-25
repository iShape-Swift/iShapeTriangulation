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
        
        XCTAssertEqual(TestUtil.isCCW(points: pShape.points, triangles: triangles), true)
        
//        print(triangles.prettyString)
        
        return triangles
    }
    
    func test_00() {
        let triangles = self.triangulate(index: 0)
        
        let origin = [
            0, 1, 3,
            1, 2, 3
        ]
        
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_01() {
        let triangles = self.triangulate(index: 1)
        let origin = [
            1, 2, 0,
            0, 2, 4,
            2, 3, 4
        ]
        
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_02() {
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
    
    func test_03() {
        let triangles = self.triangulate(index: 3)
        let origin = [
            2, 3, 1,
            0, 1, 3
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_04() {
        let triangles = self.triangulate(index: 4)
        let origin = [
            0, 1, 4,
            2, 4, 1,
            2, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_05() {
        let triangles = self.triangulate(index: 5)
        let origin = [
            0, 1, 4,
            2, 4, 1,
            2, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
        
    }
    
    func test_06() {
        let triangles = self.triangulate(index: 6)
        let origin = [
            0, 2, 3,
            0, 1, 2
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_07() {
        let triangles = self.triangulate(index: 7)
        let origin = [
            0, 1, 7,
            7, 1, 5,
            6, 7, 5,
            1, 4, 5,
            2, 4, 1,
            2, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_08() {
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
    
    func test_09() {
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
    
    func test_10() {
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
    
    func test_11() {
        let triangles = self.triangulate(index: 11)
        let origin = [
            0, 1, 7,
            7, 1, 4,
            7, 4, 5,
            6, 7, 5,
            1, 3, 4,
            2, 3, 1
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_12() {
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
    
    
    func test_13() {
        let triangles = self.triangulate(index: 13)
        let origin = [
            0, 1, 11,
            10, 11, 9,
            11, 1, 9,
            9, 6, 7,
            9, 7, 8,
            1, 6, 9,
            1, 5, 6,
            2, 5, 1,
            2, 3, 5,
            3, 4, 5
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_14() {
        let triangles = self.triangulate(index: 14)
        let origin = [
            0, 1, 9,
            9, 1, 7,
            8, 9, 7,
            7, 5, 6,
            1, 5, 7,
            1, 4, 5,
            2, 4, 1,
            2, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_15() {
        let triangles = self.triangulate(index: 15)
        let origin = [
            4, 2, 3,
            4, 0, 2,
            0, 1, 2
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_16() {
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
            26, 16, 17,
            12, 26, 17,
            12, 17, 11,
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
            18, 7, 8,
            5, 7, 18,
            5, 6, 7
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_17() {
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
    
    
    func test_18() {
        let triangles = self.triangulate(index: 18)
        let origin = [
            0, 8, 4,
            0, 4, 5,
            5, 6, 3,
            0, 5, 3,
            11, 8, 0,
            11, 0, 1,
            10, 11, 1,
            10, 1, 6,
            6, 2, 3,
            1, 2, 6
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_19() {
        let triangles = self.triangulate(index: 19)
        let origin = [
            8, 5, 7,
            5, 6, 7,
            8, 9, 5,
            1, 2, 5,
            2, 4, 5,
            2, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_20() {
        let triangles = self.triangulate(index: 20)
        let origin = [
            3, 0, 2,
            0, 1, 2,
            3, 4, 0,
            6, 7, 0,
            7, 9, 0,
            7, 8, 9
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_21() {
        let triangles = self.triangulate(index: 21)
        let origin = [
            0, 4, 5,
            5, 8, 9,
            0, 5, 9,
            9, 10, 3,
            0, 9, 3,
            0, 1, 4,
            1, 7, 4,
            7, 11, 8,
            1, 11, 7,
            10, 2, 3,
            11, 2, 10,
            1, 2, 11
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_22() {
        let triangles = self.triangulate(index: 22)
        let origin = [
            8, 4, 5,
            5, 6, 10,
            3, 8, 9,
            3, 9, 2,
            9, 10, 2,
            10, 6, 2,
            3, 0, 8,
            0, 4, 8,
            0, 7, 4,
            0, 1, 7,
            7, 1, 6,
            6, 1, 2
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_23() {
        let triangles = self.triangulate(index: 23)
        let origin = [
            4, 8, 7,
            7, 10, 6,
            3, 4, 5,
            6, 10, 2,
            5, 6, 2,
            3, 5, 2,
            3, 0, 4,
            0, 8, 4,
            0, 11, 8,
            10, 1, 2,
            11, 1, 10,
            0, 1, 11
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_24() {
        let triangles = self.triangulate(index: 24)
        let origin = [
            6, 0, 7,
            0, 1, 7,
            7, 1, 2,
            2, 3, 9,
            6, 7, 8,
            9, 3, 4,
            9, 4, 5,
            8, 9, 5,
            6, 8, 5
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_25() {
        let triangles = self.triangulate(index: 25)
        let origin = [
            5, 7, 4,
            4, 9, 3,
            3, 9, 2,
            6, 0, 5,
            0, 7, 5,
            0, 10, 7,
            9, 1, 2,
            10, 1, 9,
            0, 1, 10
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_26() {
        let triangles = self.triangulate(index: 26)
        let origin = [
            9, 0, 8,
            0, 10, 8,
            0, 1, 10,
            10, 1, 2,
            2, 3, 12,
            8, 10, 7,
            7, 12, 6,
            6, 3, 5,
            3, 4, 5
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_27() {
        let triangles = self.triangulate(index: 27)
        let origin = [
            6, 0, 2,
            0, 1, 2,
            6, 2, 3,
            6, 3, 5,
            3, 1, 5
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_28() {
        let triangles = self.triangulate(index: 28)
        let origin = [
            5, 3, 4,
            5, 6, 3,
            6, 2, 3,
            2, 0, 4,
            6, 0, 2
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_29() {
        let triangles = self.triangulate(index: 29)
        let origin = [
            2, 3, 1,
            2, 6, 4,
            6, 3, 4,
            6, 1, 3,
            6, 0, 1
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_30() {
        let triangles = self.triangulate(index: 30)
        let origin = [
            6, 3, 1,
            6, 1, 2,
            6, 2, 5,
            2, 4, 5,
            3, 4, 2
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
}
