//
//  ExtraPointsTests.swift
//  iGeometry
//
//  Created by Nail Sharipov on 07.05.2020.
//

#if DEBUG

import Foundation
import iGeometry

public struct ExtraPointsTests {
    
    private static let key = "extraPoints"
    public static var pageIndex: Int = UserDefaults.standard.integer(forKey: ExtraPointsTests.key)
    public static func nextIndex() -> Int {
        let n = ExtraPointsTests.data.count
        ExtraPointsTests.pageIndex = (ExtraPointsTests.pageIndex + 1) % n
        UserDefaults.standard.set(ExtraPointsTests.pageIndex, forKey: ExtraPointsTests.key)
        return ExtraPointsTests.pageIndex
    }
    
    public static func prevIndex() -> Int {
        let n = ExtraPointsTests.data.count
        ExtraPointsTests.pageIndex = (ExtraPointsTests.pageIndex - 1 + n) % n
        UserDefaults.standard.set(ExtraPointsTests.pageIndex, forKey: ExtraPointsTests.key)
        return ExtraPointsTests.pageIndex
    }
    
    public static let data: [[[Point]]] = [
        // test 0
        [
            [
                Point(x: -15, y: -15),
                Point(x: -25, y: 0),
                Point(x: -15, y: 15),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15)
            ],
            [
                Point(x: 0, y: 0)
            ]
        ],
        // test 1
        [
            [
                Point(x: -10, y: 0),
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 0),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10)
            ],
            [
                Point(x: 0, y: -5)
            ]
        ],
        // test 2
        [
            [
                Point(x: 0, y: 0),
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 0),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10)
            ],
            [
                Point(x: 5, y: 0)
            ]
        ],
        // test 3
        [
            [
                Point(x: 0, y: 5),
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 0),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10)
            ],
            [
                Point(x: 5, y: 0)
            ]
        ],
        // test 4
        [
            [
                Point(x: 0, y: 5),
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 0),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10)
            ],
            [
                Point(x: 4, y: 0)
            ]
        ],
        // test 5
        [
            [
                Point(x: -10, y: 5),
                Point(x: -5, y: 5),
                Point(x: 5, y: 10),
                Point(x: 10, y: 0),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10)
            ],
            [
                Point(x: 4, y: 0)
            ]
        ],
        // test 6
        [
            [
                Point(x: -10, y: 5),
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 0),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10)
            ],
            [
                Point(x: -4, y: -1),
                Point(x: 0, y: 0)
            ]
        ],
        // test 7
        [
            [
                Point(x: -10, y: 5),
                Point(x: -5, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 0),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10)
            ],
            [
                Point(x: -5, y: 5),
                Point(x: 0, y: 0),
                Point(x: 5, y: -5)
            ]
        ],
        // test 8
        [
            [
                Point(x: -15, y: 15),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15),
                Point(x: -15, y: -15)
            ],
            [
                Point(x: 0, y: 5),
                Point(x: 5, y: 0),
                Point(x: 0, y: -5),
                Point(x: -5, y: 0)
            ]
        ],
        // test 9
        [
            [
                Point(x: -15, y: -5),
                Point(x: -15, y: 5),
                
                Point(x: -5, y: 15),
                Point(x:  5, y: 15),

                Point(x: 15, y: 5),
                Point(x: 15, y: -5),
                
                Point(x:  5, y: -15),
                Point(x: -5, y: -15)
            ],
            [
                Point(x: -5, y: 5),
                Point(x: -5, y: -5),
                Point(x:  5, y: -5),
                Point(x:  5, y: 5)
            ],
            [
                Point(x: 10, y: 0),
                Point(x: 0, y: 10),
                Point(x: -10, y: 0),
                Point(x: 0, y: -10),
            ]
        ],
        // test 10
        [
            [
                Point(x: -15, y: 15),
                Point(x: 15, y: 15),
                Point(x: 15, y: -15),
                Point(x: -15, y: -15)
            ],
            [
                Point(x: -10, y: 10),
                Point(x: -5, y: 10),
                Point(x: 0, y: 10),
                Point(x: 5, y: 10),
                Point(x: 10, y: 10),

                Point(x: -10, y: 5),
                Point(x: -5, y: 5),
                Point(x: 0, y: 5),
                Point(x: 5, y: 5),
                Point(x: 10, y: 5),
                
                Point(x: -10, y: 0),
                Point(x: -5, y: 0),
                Point(x: 0, y: 0),
                Point(x: 5, y: 0),
                Point(x: 10, y: 0),
                
                Point(x: -10, y: -5),
                Point(x: -5, y: -5),
                Point(x: 0, y: -5),
                Point(x: 5, y: -5),
                Point(x: 10, y: -5),
                
                Point(x: -10, y: -10),
                Point(x: -5, y: -10),
                Point(x: 0, y: -10),
                Point(x: 5, y: -10),
                Point(x: 10, y: -10)
            ]
        ],
        // test 11
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
            ],
            [
                Point(x: 0, y: 5),
                Point(x: 0, y: 0),
                Point(x: 0, y: -5)
            ]
        ],
        [
            [
                Point(x: 0.0, y: -18.0),
                Point(x: -2.8, y: -19.6),
                Point(x: -4.8, y: -19.6),
                Point(x: -3.6, y: -17.6),
                Point(x: -6.4, y: -18.0),
                Point(x: -9.2, y: -16.8),
                Point(x: -7.6, y: -15.2),
                Point(x: -10.4, y: -15.6),
                Point(x: -12.8, y: -13.6),
                Point(x: -10.4, y: -12.8),
                Point(x: -13.6, y: -12.4),
                Point(x: -15.2, y: -10.8),
                Point(x: -14.0, y: -10.0),
                Point(x: -16.0, y: -9.6),
                Point(x: -17.2, y: -7.2),
                Point(x: -12.8, y: -6.8),
                Point(x: -7.2, y: -4.0),
                Point(x: -7.6, y: -1.2),
                Point(x: -8.4, y: 0.8),
                Point(x: -8.8, y: -0.4),
                Point(x: -10.0, y: -1.2),
                Point(x: -10.4, y: 1.2),
                Point(x: -10.8, y: 0.0),
                Point(x: -12.8, y: -1.6),
                Point(x: -12.8, y: 1.2),
                Point(x: -13.6, y: -0.4),
                Point(x: -16.4, y: -2.0),
                Point(x: -16.0, y: 0.4),
                Point(x: -18.4, y: -1.2),
                Point(x: -18.4, y: 1.2),
                Point(x: -21.2, y: -0.4),
                Point(x: -20.8, y: 1.6),
                Point(x: -23.6, y: 0.4),
                Point(x: -23.2, y: 2.8),
                Point(x: -26.0, y: 1.6),
                Point(x: -25.2, y: 3.6),
                Point(x: -29.2, y: 2.4),
                Point(x: -28.4, y: 4.4),
                Point(x: -32.4, y: 3.6),
                Point(x: -31.0, y: 6.4),
                Point(x: -35.2, y: 6.0),
                Point(x: -34.0, y: 7.2),
                Point(x: -37.6, y: 7.6),
                Point(x: -35.6, y: 9.2),
                Point(x: -38.4, y: 8.8),
                Point(x: -41.2, y: 9.2),
                Point(x: -39.2, y: 10.8),
                Point(x: -42.0, y: 10.8),
                Point(x: -44.8, y: 12.0),
                Point(x: -41.2, y: 13.6),
                Point(x: -45.2, y: 13.6),
                Point(x: -47.6, y: 15.2),
                Point(x: -42.8, y: 16.4),
                Point(x: -46.8, y: 17.2),
                Point(x: -48.8, y: 19.6),
                Point(x: -44.0, y: 19.6),
                Point(x: -40.8, y: 20.0),
                Point(x: -42.8, y: 20.4),
                Point(x: -46.0, y: 23.4),
                Point(x: -48.0, y: 25.6),
                Point(x: -42.0, y: 23.2),
                Point(x: -36.8, y: 22.0),
                Point(x: -38.4, y: 23.6),
                Point(x: -39.6, y: 26.4),
                Point(x: -39.6, y: 30.4),
                Point(x: -37.6, y: 26.4),
                Point(x: -28.0, y: 22.4),
                Point(x: -30.0, y: 24.4),
                Point(x: -30.0, y: 26.8),
                Point(x: -28.4, y: 24.8),
                Point(x: -21.2, y: 22.0),
                Point(x: -11.0, y: 13.6),
                Point(x: -8.4, y: 12.4),
                Point(x: -6.0, y: 12.4),
                Point(x: -4.0, y: 12.8),
                Point(x: -2.4, y: 14.0),
                Point(x: -0.0, y: 14.4),
                Point(x: 2.4, y: 14.0),
                Point(x: 4.0, y: 12.8),
                Point(x: 6.0, y: 12.4),
                Point(x: 8.4, y: 12.4),
                Point(x: 11.0, y: 13.6),
                Point(x: 21.2, y: 22.0),
                Point(x: 28.4, y: 24.8),
                Point(x: 30.0, y: 26.8),
                Point(x: 30.0, y: 24.4),
                Point(x: 28.0, y: 22.4),
                Point(x: 37.6, y: 26.4),
                Point(x: 39.6, y: 30.4),
                Point(x: 39.6, y: 26.4),
                Point(x: 38.4, y: 23.6),
                Point(x: 36.8, y: 22.0),
                Point(x: 42.0, y: 23.2),
                Point(x: 48.0, y: 25.6),
                Point(x: 46.0, y: 23.4),
                Point(x: 42.8, y: 20.4),
                Point(x: 40.8, y: 20.0),
                Point(x: 44.0, y: 19.6),
                Point(x: 48.8, y: 19.6),
                Point(x: 46.8, y: 17.2),
                Point(x: 42.8, y: 16.4),
                Point(x: 47.6, y: 15.2),
                Point(x: 45.2, y: 13.6),
                Point(x: 41.2, y: 13.6),
                Point(x: 44.8, y: 12.0),
                Point(x: 42.0, y: 10.8),
                Point(x: 39.2, y: 10.8),
                Point(x: 41.2, y: 9.2),
                Point(x: 38.4, y: 8.8),
                Point(x: 35.6, y: 9.2),
                Point(x: 37.6, y: 7.6),
                Point(x: 34.0, y: 7.2),
                Point(x: 35.2, y: 6.0),
                Point(x: 31.0, y: 6.4),
                Point(x: 32.4, y: 3.6),
                Point(x: 28.4, y: 4.4),
                Point(x: 29.2, y: 2.4),
                Point(x: 25.2, y: 3.6),
                Point(x: 26.0, y: 1.6),
                Point(x: 23.2, y: 2.8),
                Point(x: 23.6, y: 0.4),
                Point(x: 20.8, y: 1.6),
                Point(x: 21.2, y: -0.4),
                Point(x: 18.4, y: 1.2),
                Point(x: 18.4, y: -1.2),
                Point(x: 16.0, y: 0.4),
                Point(x: 16.4, y: -2.0),
                Point(x: 13.6, y: -0.4),
                Point(x: 12.8, y: 1.2),
                Point(x: 12.8, y: -1.6),
                Point(x: 10.8, y: 0.0),
                Point(x: 10.4, y: 1.2),
                Point(x: 10.0, y: -1.2),
                Point(x: 8.8, y: -0.4),
                Point(x: 8.4, y: 0.8),
                Point(x: 7.6, y: -1.2),
                Point(x: 7.2, y: -4.0),
                Point(x: 12.8, y: -6.8),
                Point(x: 17.2, y: -7.2),
                Point(x: 16.0, y: -9.6),
                Point(x: 14.0, y: -10.0),
                Point(x: 15.2, y: -10.8),
                Point(x: 13.6, y: -12.4),
                Point(x: 10.4, y: -12.8),
                Point(x: 12.8, y: -13.6),
                Point(x: 10.4, y: -15.6),
                Point(x: 7.6, y: -15.2),
                Point(x: 9.2, y: -16.8),
                Point(x: 6.4, y: -18.0),
                Point(x: 3.6, y: -17.6),
                Point(x: 4.8, y: -19.6),
                Point(x: 2.8, y: -19.6)
            ],
            
            [
                Point(x: -2.4, y: 9.2),
                Point(x: -2.4, y: 8),
                Point(x: -1.6, y: 7.2),
                Point(x: -1.2, y: 8)
            ],
            [
                Point(x: 1.2, y: 8),
                Point(x: 1.6, y: 7.2),
                Point(x: 2.4, y: 8),
                Point(x: 2.4, y: 9.2)
            ],
            [
                Point(x: 0, y: 8.0),
                Point(x: -0.8, y: 7.6),
                Point(x: -1.2, y: 6.8),
                Point(x: -1.6, y: 6.4),
                Point(x: -3.2, y: 6.4),
                Point(x: -1.6, y: 5.6),
                Point(x: -0.8, y: 4.8),
                Point(x: 0, y: 2.8),
                Point(x: 0.8, y: 4.8),
                Point(x: 1.6, y: 5.6),
                Point(x: 3.2, y: 6.4),
                Point(x: 1.6, y: 6.4),
                Point(x: 1.2, y: 6.8),
                Point(x: 0.8, y: 7.6),
            ],
            [
                Point(x: 8, y: 6),
                Point(x: 13, y: 7),
                Point(x: 19, y: 9),
                Point(x: 24, y: 13),
                Point(x: 30, y: 15),
                Point(x: 36, y: 17),
                
                Point(x: -8, y: 6),
                Point(x: -13, y: 7),
                Point(x: -19, y: 9),
                Point(x: -24, y: 13),
                Point(x: -30, y: 15),
                Point(x: -36, y: 17),
                
                Point(x: 5, y: 0),
                Point(x: -5, y: 0),
                Point(x: 0, y: -5),
                Point(x: 5, y: -10),
                Point(x: -5, y: -10),
                Point(x: 0, y: -15),
            ]
        ],
        // test
        [
            [
                Point(x: 0, y: 0),
                Point(x: -10, y: 5),
                Point(x: 0, y: 10),
                Point(x: 10, y: 5),
                Point(x: 10, y: -5),
                Point(x: 0, y: -10),
                Point(x: -10, y: -5)
            ],
            [
                
            ]
        ]
    ]
}

#endif
