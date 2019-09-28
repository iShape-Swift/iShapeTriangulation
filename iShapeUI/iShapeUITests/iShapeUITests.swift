//
//  iShapeUITests.swift
//  iShapeUITests
//
//  Created by Nail Sharipov on 28/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import XCTest
import iGeometry

class iShapeUITests: XCTestCase {

    func testExample() {
        let point = IntPoint(x: 0, y: 0)
        let a = point.bitPack
        XCTAssertEqual(a, 0)
    }


}
