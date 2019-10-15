//
//  MonotoneDelaunayTests.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 02/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import XCTest
import iShapeTriangulation
import iGeometry

final class MonotoneDelaunayTests: XCTestCase {

    private func triangulate(index: Int) -> [Int] {
        let iGeom = IntGeom()

        let data = MonotoneTests.data[index]
        
        let iPoints = iGeom.int(points: data)

        let iShape = IntShape(hull: iPoints, holes: [])
        let pShape = PlainShape(iShape: iShape)

        let triangles = pShape.triangulateDelaunay()
        
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
                0, 1, 3,
                3, 1, 2
            ]
            
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_02() {
        let triangles = self.triangulate(index: 2)
        let origin = [
                1, 2, 0,
                0, 2, 4,
                2, 3, 4
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }

    func test_03() {
        let triangles = self.triangulate(index: 3)
        let origin = [
                3, 1, 2,
                1, 4, 0,
                3, 4, 1
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_04() {
        let triangles = self.triangulate(index: 4)
        let origin = [
                3, 0, 2,
                0, 1, 2
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_05() {
        let triangles = self.triangulate(index: 5)
        let origin = [
                0, 1, 2,
                0, 2, 4,
                2, 3, 4
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_06() {
        let triangles = self.triangulate(index: 6)
        let origin = [
                1, 2, 3,
                1, 3, 0,
                4, 0, 3
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_07() {
        let triangles = self.triangulate(index: 7)
        let origin = [
                0, 1, 8,
                8, 1, 6,
                8, 6, 7,
                2, 6, 1,
                3, 6, 2,
                5, 6, 3,
                4, 5, 3
            ]
        XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_08() {
        let triangles = self.triangulate(index: 8)
        let origin = [
                6, 0, 1,
                8, 0, 6,
                8, 6, 7,
                2, 6, 1,
                3, 6, 2,
                5, 6, 3,
                4, 5, 3
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_09() {
        let triangles = self.triangulate(index: 9)
        let origin = [
                0, 1, 8,
                7, 8, 1,
                6, 7, 1,
                1, 2, 3,
                1, 3, 6,
                5, 6, 3,
                4, 5, 3
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_10() {
        let triangles = self.triangulate(index: 10)
        let origin = [
                8, 0, 1,
                8, 1, 7,
                1, 6, 7,
                1, 2, 6,
                6, 2, 3,
                6, 3, 5,
                3, 4, 5
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_11() {
        let triangles = self.triangulate(index: 11)
        let origin = [
                8, 0, 6,
                8, 6, 7,
                1, 6, 0,
                1, 2, 3,
                1, 3, 6,
                5, 6, 3,
                4, 5, 3
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_12() {
        let triangles = self.triangulate(index: 12)
        let origin = [
                14, 0, 1,
                14, 1, 13,
                1, 2, 3,
                13, 1, 10,
                10, 12, 13,
                10, 11, 12,
                1, 3, 4,
                1, 4, 10,
                9, 10, 4,
                5, 9, 4,
                5, 6, 8,
                5, 8, 9,
                7, 8, 6
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_13() {
        let triangles = self.triangulate(index: 13)
        let origin = [
                14, 0, 1,
                14, 1, 13,
                2, 3, 4,
                10, 13, 1,
                12, 13, 10,
                12, 10, 11,
                2, 4, 1,
                1, 4, 10,
                9, 10, 4,
                5, 9, 4,
                5, 6, 8,
                5, 8, 9,
                7, 8, 6
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_14() {
        let triangles = self.triangulate(index: 14)
        let origin = [
                8, 1, 2,
                7, 2, 3,
                6, 3, 4,
                8, 0, 1,
                8, 9, 0,
                7, 8, 2,
                6, 7, 3,
                5, 6, 4
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    
    func test_15() {
        let triangles = self.triangulate(index: 15)
        let origin = [
                0, 1, 3,
                3, 1, 2,
                13, 0, 3,
                13, 15, 0,
                13, 14, 15,
                5, 3, 4,
                5, 13, 3,
                11, 13, 5,
                11, 12, 13,
                7, 5, 6,
                8, 5, 7,
                8, 11, 5,
                9, 10, 11,
                11, 8, 9
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_16() {
        let triangles = self.triangulate(index: 16)
        let origin = [
                12, 0, 1,
                12, 1, 11,
                1, 2, 4,
                5, 11, 1,
                4, 2, 3,
                5, 1, 4,
                5, 10, 11,
                10, 5, 8,
                10, 8, 9,
                5, 6, 7,
                5, 7, 8
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
    
    func test_17() {
        let triangles = self.triangulate(index: 17)
        let origin = [
                1, 13, 0,
                12, 13, 1,
                2, 12, 1,
                3, 12, 2,
                10, 11, 12,
                9, 10, 12,
                12, 3, 9,
                4, 9, 3,
                5, 9, 4,
                8, 9, 5,
                5, 6, 7,
                5, 7, 8
            ]
            XCTAssertEqual(triangles.compare(array: origin), true)
    }
}
