//
//  ComplexTests.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 07/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

#if iShapeTest

public struct ComplexTests {
    
    public static let data: [[[Point]]] = [
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
        // test 16
        [
            [
                Point(x: -25, y:  5),
                
                Point(x: -30, y:  20),
                Point(x: -25, y:  30),
                Point(x: -10, y:  25),
                Point(x:   0, y:  30),
                
                Point(x:  15, y:  15),
                Point(x:  30, y:  15),
                Point(x:  35, y:   5),
                
                Point(x:  30, y: -10),
                Point(x:  25, y: -10),
                Point(x:  15, y: -20),
                Point(x:  15, y: -30),
                
                Point(x:  -5, y: -35),
                
                Point(x: -15, y: -20),
                Point(x: -40, y: -25),
                Point(x: -35, y:  -5)
            ],
            [
                Point(x:   5, y:   0),
                Point(x:  10, y: -10),
                Point(x:  25, y:   0),
                Point(x:  15, y:   5)
            ],
            [
                Point(x: -15, y:   0),
                Point(x: -25, y:  -5),
                Point(x: -30, y: -15),
                Point(x: -15, y: -10),
                Point(x:  -5, y: -15),
                Point(x:   0, y: -25),
                Point(x:   5, y: -15),
                Point(x:  -5, y:  -5),
                Point(x:  -5, y:   5),
                Point(x:   5, y:  10),
                Point(x:   0, y:  20),
                Point(x:  -5, y:  15),
                Point(x: -10, y:  15),
                Point(x: -15, y:  20),
                Point(x: -20, y:  10),
                Point(x: -15, y:   5)
            ]
        ],
        // test 17
        [
            [
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 5),
                Point(x: 10, y: -5),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10),
                Point(x: -10, y: -5),
                Point(x: -10, y: 5)
            ],
            [
                Point(x: -5, y: 0),
                Point(x: 0, y: -5),
                Point(x: 5, y: 0),
                Point(x: 0, y: 5)
            ],
        ],
        // test 18
        [
            [
                Point(x: -10, y: -10),
                Point(x: -10, y: 10),
                Point(x: 10, y: 10),
                Point(x: 10, y: -10)
            ],
            [
                Point(x: 0, y: -5),
                Point(x: 5, y: -5),
                Point(x: 5, y: 5),
                Point(x: 0, y: 5)
            ],
            [
                Point(x: -5, y: -5),
                Point(x: 0, y: -5),
                Point(x: 0, y: 5),
                Point(x: -5, y: 5)
            ]
        ],
        // test 19
        [
            [
                Point(x:  0,  y:   0),
                
                Point(x:  -5, y:   5),
                Point(x:  -5, y:  10),
                Point(x:   5, y:  10),
                Point(x:   5, y:   5),
                
                Point(x:   0, y:   0),
                
                Point(x:   5, y:  -5),
                Point(x:   5, y: -10),
                Point(x:  -5, y: -10),
                Point(x:  -5, y:  -5)
            ]
        ],
        // test 20
        [
            [
                Point(x:   0, y:   0),
                
                Point(x:   5, y:  -5),
                Point(x:   5, y: -10),
                Point(x:  -5, y: -10),
                Point(x:  -5, y:  -5),
                
                Point(x:  0,  y:   0),
                
                Point(x:  -5, y:   5),
                Point(x:  -5, y:  10),
                Point(x:   5, y:  10),
                Point(x:   5, y:   5)
            ]
        ],
        // test 21
        [
            [
                Point(x: -15, y: -10),
                Point(x: -15, y:  10),
                Point(x:  15, y:  10),
                Point(x:  15, y:  -10)
            ],
            [
                Point(x: -10, y:   0),
                Point(x:  -5, y:  -5),
                Point(x:   0, y:   0),
                Point(x:  -5, y:   5)
            ],
            [
                Point(x:   0, y:   0),
                Point(x:   5, y:  -5),
                Point(x:  10, y:   0),
                Point(x:   5, y:   5)
            ]
        ],
        // test 22
        [
            [
                Point(x: -10, y:  15),
                Point(x:  10, y:  15),
                Point(x:  10, y: -15),
                Point(x: -10, y: -15)
            ],
            [
                Point(x:  -5, y:   5),
                Point(x:   0, y:   0),
                Point(x:   5, y:   5),
                Point(x:   0, y:  10)
            ],
            [
                Point(x:  -5, y:  -5),
                Point(x:   0, y: -10),
                Point(x:   5, y:  -5),
                Point(x:   0, y:   0)
            ]
        ],
        // test 23
        [
            [
                Point(x: -10, y:  15),
                Point(x:  10, y:  15),
                Point(x:  10, y: -15),
                Point(x: -10, y: -15)
            ],
            [
                Point(x:  -5, y:  -5),
                Point(x:   0, y: -10),
                Point(x:   5, y:  -5),
                Point(x:   0, y:   0)
            ],
            [
                Point(x:  -5, y:   5),
                Point(x:   0, y:   0),
                Point(x:   5, y:   5),
                Point(x:   0, y:  10)
            ]
        ],
        // test 24
        [
            [
                Point(x: -10, y:  10),
                Point(x:  -5, y:  10),
                Point(x:   0, y:   5),
                Point(x:   5, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ],
            [
                Point(x:  -5, y:   0),
                Point(x:   0, y:  -5),
                Point(x:   5, y:   0),
                Point(x:   0, y:   5)
            ]
        ],
        // test 25
        [
            [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x:   5, y: -10),
                Point(x:   0, y:  -5),
                Point(x:  -5, y: -10),
                Point(x: -10, y: -10)
            ],
            [
                Point(x:  -5, y:   0),
                Point(x:   0, y:  -5),
                Point(x:   5, y:   0),
                Point(x:   0, y:   5)
            ]
        ],
        // test 26
        [
            [
                Point(x: -10, y:  10),
                Point(x:  -5, y:  10),
                Point(x:   0, y:   5),
                Point(x:   5, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x:   5, y: -10),
                Point(x:   0, y:  -5),
                Point(x:  -5, y: -10),
                Point(x: -10, y: -10)
            ],
            [
                Point(x:  -5, y:   0),
                Point(x:   0, y:  -5),
                Point(x:   5, y:   0),
                Point(x:   0, y:   5)
            ]
        ],
        // test 27
        [
            [
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:   0, y:   5),
                Point(x:   5, y:   0),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ]
        ],
        // test 28
        [
            [
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x:   5, y:   0),
                Point(x:   0, y:  -5),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10),
                Point(x: -10, y:  10)
            ]
        ],
        // test 29
        [
            [
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10),
                Point(x:   0, y:  -5),
                Point(x:  -5, y:   0),
                Point(x: -10, y: -10),
                Point(x: -10, y:  10)
            ]
        ],
        // test 30
        [
            [
                Point(x: -10, y:  10),
                Point(x:  -5, y:   0),
                Point(x:   0, y:   5),
                Point(x: -10, y:  10),
                Point(x:  10, y:  10),
                Point(x:  10, y: -10),
                Point(x: -10, y: -10)
            ]
        ],
        [
            [
                Point(x:32, y: 0),                  // 0
                Point(x:21.02803, y: -4.182736),
                Point(x:29.56414, y: -12.24587),
                Point(x:35.38735, y: -23.64507),
                Point(x:22.62741, y: -22.62741),
                Point(x:11.91142, y: -17.82671),    // 5
                Point(x:12.24587, y: -29.56414),
                Point(x:8.303045, y: -41.74222),
                Point(x:0, y: -32),
                Point(x:-4.182734, y: -21.02804),
                Point(x:-12.24586, y: -29.56413),   // 10
                Point(x:-23.64507, y: -35.38735),
                Point(x:-22.62742, y: -22.62742),
                Point(x:-17.82671, y: -11.91142),
                Point(x:-29.56416, y: -12.24587),
                Point(x:-41.74223, y: -8.303034),   // 15
                Point(x:-32, y: 0),
                Point(x:-21.02803, y: 4.182745),    // 17
                Point(x:-29.56418, y: 12.2459),
                Point(x:-35.38733, y: 23.64509),
                Point(x:-22.62736, y: 22.62739),    // 20
                Point(x:-11.91141, y: 17.82672),    // 21
                Point(x:-12.24587, y: 29.56422),
                Point(x:-8.303008, y: 41.74223),
                Point(x:0, y: 32),
                Point(x:4.182758, y: 21.02803),     // 25
                Point(x:12.24594, y: 29.56422),
                Point(x:23.64511, y: 35.38732),
                Point(x:22.62737, y: 22.62731),
                Point(x:17.82672, y: 11.9114),
                Point(x:29.56428, y: 12.24587),     // 30
                Point(x:41.74223, y: 8.30298),
            ],
            [
                Point(x:20.87112, y: 4.15149),
                Point(x:14.78214, y: 6.122937),
                Point(x:8.913362, y: 5.9557),
                Point(x:11.31368, y: 11.31366),     // 35
                Point(x:11.82256, y: 17.69366),
                Point(x:6.12297, y: 14.78211),
                Point(x:2.091379, y: 10.51402),
                Point(x:0, y: 16),
                Point(x:-4.151504, y: 20.87111),    // 40
                Point(x:-6.122936, y: 14.78211),
                Point(x:-5.955706, y: 8.913358),
                Point(x:-11.31368, y: 11.3137),     // 43
                Point(x:-17.69367, y: 11.82255),
                Point(x:-14.78209, y: 6.12295),     // 45
                Point(x:-10.51402, y: 2.091372),
                Point(x:-16, y: 0),
                Point(x:-20.87111, y: -4.151517),   // 48
                Point(x:-14.78208, y: -6.122935),
                Point(x:-8.913354, y: -5.955712),
                Point(x:-11.31371, y: -11.31371),
                Point(x:-11.82253, y: -17.69367),
                Point(x:-6.12293, y: -14.78207),
                Point(x:-2.091367, y: -10.51402),
                Point(x:0, y: -16),
                Point(x:4.151523, y: -20.87111),
                Point(x:6.122935, y: -14.78207),
                Point(x:5.955712, y: -8.913354),
                Point(x:11.31371, y: -11.31371),
                Point(x:17.69367, y: -11.82254),
                Point(x:14.78207, y: -6.122935),
                Point(x:10.51402, y: -2.091368),
                Point(x:16, y: 0),
            ]
        ]
    ]
}

#endif

