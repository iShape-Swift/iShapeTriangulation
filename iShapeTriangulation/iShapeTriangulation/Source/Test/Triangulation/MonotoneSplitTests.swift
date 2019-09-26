//
//  MonotoneSplitTests.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 07/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

#if iShapeTest

struct MonotoneSplitTests {

static let data: [[[Point]]] = [
        // test 0
        [
            [
                Point(x: -15, y: -15),
                Point(x: -15, y: 15),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15)
            ]
        ],
        // test 1
        [
            [
                Point(x: -15, y: -15),
                Point(x: -25, y: 0),
                Point(x: -15, y: 15),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15)
            ]
        ],
        // test 2
        [
            [
                Point(x: -15, y: -15),
                Point(x: -15, y: 15),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15)
            ],
            [
                Point(x: -10, y: 10),
                Point(x: -10, y: -10),
                Point(x: 10, y: -10),
                Point(x: 10, y: 10)
            ]
        ],
        // test 3
        [
            [
                Point(x: -10, y: -10),
                Point(x: 0, y: 0),
                Point(x: -10, y: 10),
                Point(x: 10, y: 0)
            ]
        ],
        // test 4
        [
            [
                Point(x: -15, y: -15),
                Point(x: -10, y: 0),
                Point(x: -15, y: 15),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15)
            ]
        ],
        // test 5
        [
            [
                Point(x: -15, y: -15),
                Point(x: -15, y: -5),
                Point(x: -20, y: 10),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15)
            ]
        ],
        // test 6
        [
            [
                Point(x: -10, y: 0),
                Point(x: 10, y: 10),
                Point(x: 0, y: 0),
                Point(x: 10, y: -10)
            ]
        ],
        // test 7
        [
            [
                Point(x: -15, y: 0),
                Point(x: -5, y: 10),
                Point(x: -10, y: 15),
                Point(x: 5, y: 20),
                Point(x: 15, y: 0),
                Point(x: 5, y: -20),
                Point(x: -10, y: -15),
                Point(x: -5, y: -10)
            ]
        ],
        // test 8
        [
            [
                Point(x: -15, y: 0),
                Point(x: -15, y: 10),
                Point(x: -10, y: 15),
                Point(x: 5, y: 20),
                Point(x: 15, y: 0),
                Point(x: 5, y: -20),
                Point(x: -10, y: -15),
                Point(x: -5, y: -10)
            ]
        ],
        // test 9
        [
            [
                Point(x: 5, y: 0),
                Point(x: -10, y: 5),
                Point(x: -10, y: 15),
                Point(x: 5, y: 20),
                Point(x: 15, y: 0),
                Point(x: 5, y: -20),
                Point(x: -10, y: -15),
                Point(x: -10, y: -5)
            ]
        ],
        // test 10
        [
            [
                Point(x: 0, y: 0),
                Point(x: -10, y: 5),
                Point(x: -10, y: 15),
                Point(x: 10, y: 15),
                Point(x: 5, y: 10),
                Point(x: 10, y: -15),
                Point(x: -10, y: -15),
                Point(x: -10, y: -5)
            ]
        ],
        // test 11
        [
            [
                Point(x: -15, y: 0),
                Point(x: -5, y: 10),
                Point(x: -10, y: 15),
                Point(x: 5, y: 20),
                Point(x: 0, y: 0),
                Point(x: 5, y: -20),
                Point(x: -10, y: -15),
                Point(x: -5, y: -10)
            ]
        ],
        // test 12
        [
            [
                Point(x: -15, y: 0),
                Point(x: -5, y: 10),
                Point(x: -10, y: 15),
                Point(x: 5, y: 20),
                Point(x: -7, y: 0),
                Point(x: 5, y: -20),
                Point(x: -10, y: -15),
                Point(x: -5, y: -10)
            ]
        ],
        // test 13
        [
            [
                Point(x: -15, y: 0),
                Point(x: -5, y: 10),
                Point(x: -10, y: 15),
                Point(x: -2.5, y: 20),
                Point(x: 5, y: 20),
                Point(x: 2.5, y: 10),
                Point(x: 0, y: 0),
                Point(x: 2.5, y: -10),
                Point(x: 5, y: -20),
                Point(x: -2.5, y: -20),
                Point(x: -10, y: -15),
                Point(x: -5, y: -10)
            ]
        ],
        // test 14
        [
            [
                Point(x: -15, y: 0),
                Point(x: -5, y: 10),
                Point(x: -10, y: 15),
                Point(x: -2.5, y: 20),
                Point(x: 5, y: 20),
                Point(x: -2.5, y: -15),
                Point(x: 5, y: -20),
                Point(x: -2.5, y: -20),
                Point(x: -10, y: -15),
                Point(x: -5, y: -10)
            ]
        ],
        // test 15
        [
            [
                Point(x: -10, y: 0),
                Point(x: 10, y: 10),
                Point(x: 0, y: 0),
                Point(x: 10, y: -20),
                Point(x: -10, y: -20)
            ]
        ],
    ]
}

#endif
