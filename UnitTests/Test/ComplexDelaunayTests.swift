//
//  ComplexDelaunayTests.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 02/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//


import XCTest
import iShapeTriangulation
import iGeometry

final class ComplexDelaunayTests: XCTestCase {
    
    private func triangulate(index: Int) -> [Int] {
        let iGeom = IntGeom()
        
        let data = ComplexTests.data[index]
        
        let hull = data[0]
        var holes = data
        holes.remove(at: 0)
        
        let shape = Shape(hull: hull, holes: holes)
        let iShape = IntShape(shape: shape, iGeom: iGeom)
        let pShape = PlainShape(iShape: iShape)
        
        let triangles = pShape.delaunay(extraPoints: nil).trianglesIndices
        
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
            1, 4, 0,
            1, 2, 3,
            1, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_05() {
        let triangles = self.triangulate(index: 5)
        let origin = [
            1, 4, 0,
            1, 2, 3,
            1, 3, 4
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
            1, 7, 0,
            7, 5, 6,
            7, 1, 4,
            3, 1, 2,
            1, 3, 4,
            7, 4, 5
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_08() {
        let triangles = self.triangulate(index: 8)
        let origin = [
            7, 5, 6,
            1, 2, 0,
            7, 0, 2,
            2, 3, 4,
            2, 4, 7,
            4, 5, 7
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_09() {
        let triangles = self.triangulate(index: 9)
        let origin = [
            2, 0, 1,
            3, 0, 2,
            7, 5, 6,
            0, 5, 7,
            0, 3, 4,
            0, 4, 5
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_10() {
        let triangles = self.triangulate(index: 10)
        let origin = [
            7, 0, 6,
            5, 6, 0,
            4, 5, 0,
            1, 2, 4,
            1, 4, 0,
            3, 4, 2
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_11() {
        let triangles = self.triangulate(index: 11)
        let origin = [
            0, 1, 4,
            0, 4, 7,
            4, 5, 7,
            7, 5, 6,
            4, 1, 3,
            1, 2, 3
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
            0, 1, 6,
            0, 6, 11,
            11, 9, 10,
            7, 9, 11,
            8, 9, 7,
            7, 11, 6,
            6, 1, 5,
            1, 2, 3,
            1, 3, 5,
            5, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_14() {
        let triangles = self.triangulate(index: 14)
        let origin = [
            9, 0, 1,
            4, 9, 1,
            8, 9, 5,
            6, 7, 5,
            8, 5, 7,
            4, 5, 9,
            1, 2, 3,
            1, 3, 4
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
            33, 1, 2,
            20, 21, 0,
            0, 35, 20,
            27, 28, 16,
            27, 16, 26,
            29, 16, 28,
            19, 16, 29,
            15, 22, 14,
            13, 14, 22,
            23, 13, 22,
            13, 23, 24,
            25, 13, 24,
            25, 12, 13,
            25, 26, 10,
            11, 12, 25,
            16, 17, 26,
            26, 17, 10,
            25, 10, 11,
            9, 10, 17,
            18, 9, 17,
            8, 9, 18,
            21, 22, 15,
            0, 21, 15,
            1, 34, 0,
            0, 34, 35,
            33, 34, 1,
            33, 2, 3,
            33, 3, 32,
            31, 32, 3,
            30, 31, 3,
            4, 30, 3,
            5, 30, 4,
            29, 30, 5,
            29, 5, 19,
            19, 5, 6,
            19, 6, 18,
            18, 6, 7,
            18, 7, 8
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_17() {
        let triangles = self.triangulate(index: 17)
        let origin = [
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
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_18() {
        let triangles = self.triangulate(index: 18)
        let origin = [
            8, 4, 0,
            4, 5, 3,
            6, 3, 5,
            4, 3, 0,
            8, 0, 11,
            0, 1, 11,
            11, 1, 10,
            10, 1, 2,
            3, 6, 2,
            10, 2, 6
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_19() {
        let triangles = self.triangulate(index: 19)
        let origin = [
            6, 8, 9,
            8, 6, 7,
            6, 9, 5,
            1, 2, 4,
            1, 4, 5,
            4, 2, 3
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_20() {
        let triangles = self.triangulate(index: 20)
        let origin = [
            1, 3, 4,
            3, 1, 2,
            1, 4, 0,
            6, 7, 9,
            6, 9, 0,
            9, 7, 8
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_21() {
        let triangles = self.triangulate(index: 21)
        let origin = [
            4, 5, 0,
            8, 9, 5,
            5, 9, 0,
            10, 3, 9,
            9, 3, 0,
            0, 1, 4,
            4, 1, 7,
            8, 7, 11,
            7, 1, 11,
            3, 10, 2,
            10, 11, 2,
            11, 1, 2
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_22() {
        let triangles = self.triangulate(index: 22)
        let origin = [
            4, 5, 8,
            10, 5, 6,
            8, 9, 3,
            6, 2, 10,
            10, 2, 9,
            9, 2, 3,
            3, 0, 8,
            8, 0, 4,
            4, 0, 7,
            2, 6, 1,
            6, 7, 1,
            7, 0, 1
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_23() {
        let triangles = self.triangulate(index: 23)
        let origin = [
            8, 7, 4,
            6, 7, 10,
            4, 5, 3,
            10, 2, 6,
            6, 2, 5,
            5, 2, 3,
            3, 0, 4,
            4, 0, 8,
            8, 0, 11,
            2, 10, 1,
            10, 11, 1,
            11, 0, 1
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_24() {
        let triangles = self.triangulate(index: 24)
        let origin = [
            6, 0, 7,
            0, 1, 7,
            1, 2, 7,
            9, 2, 3,
            7, 8, 6,
            3, 4, 9,
            4, 5, 9,
            9, 5, 8,
            8, 5, 6
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_25() {
        let triangles = self.triangulate(index: 25)
        let origin = [
            7, 4, 5,
            4, 9, 3,
            2, 3, 9,
            6, 0, 7,
            6, 7, 5,
            7, 0, 10,
            2, 9, 1,
            9, 10, 1,
            10, 0, 1
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_26() {
        let triangles = self.triangulate(index: 26)
        let origin = [
            9, 0, 10,
            9, 10, 8,
            0, 1, 10,
            1, 2, 10,
            12, 2, 3,
            10, 7, 8,
            7, 12, 6,
            4, 12, 3,
            12, 5, 6,
            4, 5, 12
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_27() {
        let triangles = self.triangulate(index: 27)
        let origin = [
            6, 0, 2,
            2, 0, 1,
            2, 3, 6,
            6, 3, 5,
            5, 3, 1
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_28() {
        let triangles = self.triangulate(index: 28)
        let origin = [
            4, 5, 3,
            5, 6, 3,
            3, 6, 2,
            4, 2, 0,
            2, 6, 0
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_29() {
        let triangles = self.triangulate(index: 29)
        let origin = [
            1, 2, 3,
            2, 6, 4,
            0, 4, 6,
            0, 3, 4,
            3, 0, 1
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_30() {
        let triangles = self.triangulate(index: 30)
        let origin = [
            3, 1, 6,
            1, 2, 5,
            1, 5, 6,
            5, 2, 4,
            2, 3, 4
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_31() {
        let triangles = self.triangulate(index: 31)
        let origin = [
            15, 16, 14,
            16, 17, 48,
            16, 48, 14,
            14, 48, 13,
            48, 49, 13,
            19, 20, 18,
            44, 18, 20,
            45, 17, 44,
            44, 17, 18,
            20, 21, 44,
            44, 21, 43,
            17, 47, 48,
            45, 47, 17,
            47, 45, 46,
            52, 12, 13,
            51, 13, 49,
            12, 10, 11,
            52, 10, 12,
            51, 52, 13,
            49, 50, 51,
            24, 22, 23,
            40, 21, 22,
            41, 43, 21,
            43, 41, 42,
            52, 53, 9,
            52, 9, 10,
            55, 53, 54,
            55, 9, 53,
            56, 9, 55,
            56, 8, 9,
            6, 8, 56,
            56, 57, 5,
            57, 58, 59,
            5, 57, 59,
            56, 5, 6,
            6, 7, 8,
            40, 41, 21,
            24, 40, 22,
            25, 40, 24,
            25, 39, 40,
            37, 39, 25,
            37, 38, 39,
            37, 25, 36,
            25, 26, 36,
            62, 63, 61,
            61, 63, 1,
            63, 32, 1,
            34, 35, 33,
            35, 36, 29,
            28, 36, 26,
            35, 29, 33,
            28, 29, 36,
            26, 27, 28,
            59, 60, 5,
            61, 1, 60,
            5, 60, 4,
            60, 1, 2,
            60, 2, 4,
            4, 2, 3,
            33, 29, 32,
            29, 30, 32,
            32, 30, 0,
            32, 0, 1,
            30, 31, 0
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_32() {
        let triangles = self.triangulate(index: 32)
        let origin = [
            15, 16, 14,
            14, 16, 48,
            16, 17, 48,
            48, 17, 47,
            24, 22, 23,
            19, 20, 18,
            20, 44, 18,
            18, 44, 17,
            44, 45, 17,
            17, 45, 46,
            17, 46, 47,
            48, 49, 13,
            48, 13, 14,
            52, 13, 51,
            13, 49, 50,
            13, 50, 51,
            21, 44, 20,
            21, 43, 44,
            21, 22, 40,
            21, 41, 42,
            21, 42, 43,
            12, 13, 52,
            10, 12, 52,
            10, 11, 12,
            52, 53, 9,
            52, 9, 10,
            53, 54, 9,
            9, 54, 55,
            56, 9, 55,
            56, 8, 9,
            8, 56, 6,
            56, 57, 5,
            8, 6, 7,
            6, 56, 5,
            57, 58, 5,
            58, 59, 5,
            59, 60, 5,
            5, 60, 4,
            21, 40, 41,
            24, 40, 22,
            25, 40, 24,
            25, 39, 40,
            39, 25, 38,
            38, 25, 37,
            25, 26, 36,
            25, 36, 37,
            36, 26, 28,
            36, 28, 29,
            26, 27, 28,
            36, 29, 35,
            35, 29, 34,
            34, 29, 33,
            33, 29, 32,
            29, 30, 32,
            62, 63, 1,
            62, 1, 61,
            61, 1, 60,
            60, 1, 2,
            60, 2, 4,
            4, 2, 3,
            63, 32, 1,
            32, 30, 0,
            32, 0, 1,
            30, 31, 0
        ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
}

