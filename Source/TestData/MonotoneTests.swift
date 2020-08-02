//
//  MonotoneTests.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 09/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

#if DEBUG

public struct MonotoneTests {
    
    private static let key = "monotone"
    public static var pageIndex: Int = UserDefaults.standard.integer(forKey: MonotoneTests.key)
    public static func nextIndex() -> Int {
        let n = MonotoneTests.data.count
        MonotoneTests.pageIndex = (MonotoneTests.pageIndex + 1) % n
        UserDefaults.standard.set(MonotoneTests.pageIndex, forKey: MonotoneTests.key)
        return MonotoneTests.pageIndex
    }
    
    public static func prevIndex() -> Int {
        let n = MonotoneTests.data.count
        MonotoneTests.pageIndex = (MonotoneTests.pageIndex - 1 + n) % n
        UserDefaults.standard.set(MonotoneTests.pageIndex, forKey: MonotoneTests.key)
        return MonotoneTests.pageIndex
    }
    
    public static let data: [[Point]] = [
        // test 0
        [
            Point(x: -15, y: -15),
            Point(x: -15, y: 15),
            Point(x: 15, y: 15),
            Point(x: 15, y: -15)
        ],
        // test 1
        [
            Point(x: -15, y: 10),
            Point(x: 5, y: 10),
            Point(x: 15, y: -10),
            Point(x: -5, y: -10)
        ],
        // test 2
        [
            Point(x: -15, y: -15),
            Point(x: -25, y: 0),
            Point(x: -15, y: 15),
            Point(x: 15, y: 15),
            Point(x: 15, y: -15)
        ],
        // test 3
        [
            Point(x: -5, y:-15),
            Point(x:-10, y:  0),
            Point(x:  0, y: 15),
            Point(x: 10, y:  5),
            Point(x:  5, y:-10)
        ],
        // test 4
        [
            Point(x: 0, y: -5),
            Point(x: 0, y: 0),
            Point(x: 10, y: -10),
            Point(x: -10, y: -10)
        ],
        // test 5
        [
            Point(x: -15, y: -15),
            Point(x: -15, y: 0),
            Point(x: 0, y: 0),
            Point(x: 0, y: 15),
            Point(x: 15, y: -15)
        ],
        // test 6
        [
            Point(x: -15, y: -15),
            Point(x: -15, y: 0),
            Point(x: -1, y: 20),
            Point(x: 0, y: 5),
            Point(x: 15, y: -15)
        ],
        // test 7
        [
            Point(x: -10, y: 10),
            Point(x: -5, y: 5),
            Point(x: 10, y: 20),
            Point(x: 20, y: 20),
            Point(x: 25, y: 20),
            Point(x: 25, y: -5),
            Point(x: 10, y: -5),
            Point(x: 10, y: -10),
            Point(x: -10, y: -10)
        ],
        // test 8
        [
            Point(x: -10, y: 10),
            Point(x: -5, y: 15),
            Point(x: 10, y: 20),
            Point(x: 20, y: 20),
            Point(x: 25, y: 20),
            Point(x: 25, y: -5),
            Point(x: 10, y: -5),
            Point(x: 10, y: -10),
            Point(x: -10, y: -10)
        ],
        // test 9
        [
            Point(x: -10, y: 10),
            Point(x:  -5, y: 5),
            Point(x:  10, y: 20),
            Point(x:  15, y: 10),
            Point(x:  25, y: 20),
            
            Point(x: 25, y: 0),
            Point(x: 10, y: 0),
            Point(x: 10, y: -10),
            Point(x: -10, y: -10)
        ],
        // test 10
        [
            Point(x: -10, y: 10),
            Point(x:  -5, y: -5),
            Point(x:  10, y: 20),
            Point(x:  15, y: 10),
            Point(x:  25, y: 20),
            
            Point(x: 25, y: 0),
            Point(x: 10, y: 0),
            Point(x: 10, y: -10),
            Point(x: -10, y: -10)
        ],
        // test 11
        [
            Point(x: -10, y: 10),
            Point(x:  10, y: 10),
            Point(x:  10, y: 20),
            Point(x:  15, y: 10),
            Point(x:  25, y: 20),
            
            Point(x: 25, y: 0),
            Point(x: 10, y: 0),
            Point(x: 10, y: -10),
            Point(x: -10, y: -10)
        ],
        // test 12
        [
            Point(x: -35, y: 5),
            Point(x: -20, y: 10),
            Point(x: -18, y: 20),
            
            Point(x: 0, y: 20),
            Point(x: 5, y: 10),
            Point(x: 15, y: 5),
            Point(x: 20, y: 10),
            Point(x: 35, y: 0),
            Point(x: 25, y: -10),
            
            Point(x: 10, y: -4),
            Point(x: -5, y: -15),
            Point(x: -5, y: -20),
            Point(x: -15, y: -25),
            Point(x: -20, y: -10),
            Point(x: -30, y: -5)
        ],
        // test 13
        [
            Point(x: -35, y: 5),
            Point(x: -20, y: 10),
            Point(x: -10, y: 20),
            
            Point(x: 0, y: 20),
            Point(x: 5, y: 10),
            Point(x: 15, y: 5),
            Point(x: 20, y: 10),
            Point(x: 35, y: 0),
            Point(x: 25, y: -10),
            
            Point(x: 10, y: -4),
            Point(x: -5, y: -15),
            Point(x: -5, y: -20),
            Point(x: -15, y: -25),
            Point(x: -20, y: -10),
            Point(x: -30, y: -5)
        ],
        // test 14
        [
            Point(x: -10, y: -10),
            Point(x: -10, y: -5),
            Point(x: -10, y: 0),
            Point(x: -10, y: 5),
            Point(x: -10, y: 10),
            
            Point(x: 10, y: 10),
            Point(x: 10, y: 5),
            Point(x: 10, y: 0),
            Point(x: 10, y: -5),
            Point(x: 10, y: -10)
        ],
        // test 15
        [
            Point(x: -20, y: 0),
            
            Point(x: -15, y:  15),
            Point(x: -10, y:  20),
            Point(x:  -5, y:  15),
            Point(x:   0, y:  20),
            Point(x:   5, y:  15),
            Point(x:  10, y:  20),
            Point(x:  15, y:  15),
            
            Point(x:  25, y:   0),
            
            Point(x:  20, y: -15),
            Point(x:  15, y: -20),
            Point(x:  10, y: -15),
            Point(x:   5, y: -20),
            Point(x:   0, y: -15),
            Point(x:  -5, y: -20),
            Point(x: -10, y: -15)
        ],
        // test 16
        [
            Point(x: -20, y:  5),
            
            Point(x: -10, y:  10),
            Point(x:  -5, y:  20),
            Point(x:   0, y:  25),
            Point(x:   5, y:  15),
            Point(x:  10, y:   0),
            Point(x:  15, y:   5),
            
            Point(x:  20, y:  -5),
            
            Point(x:  15, y: -15),
            Point(x:   5, y: -25),
            Point(x:   0, y: -15),
            Point(x: -10, y: -10),
            Point(x: -15, y:  -5),
        ],
        // test 17
        [
            Point(x: -35, y:  5),
            
            Point(x: -13.5, y:  8),
            Point(x: -9.5,y:  20),
            Point(x:   3, y:  20),
            Point(x: 8.5, y:  11),
            Point(x:  15, y:   5),
            Point(x:  32, y:14.5),
            
            Point(x:  35, y:   0),
            
            Point(x:  25, y: -10),
            Point(x:   0, y: 1.5),
            Point(x:-0.5, y:-12.5),
            Point(x:  -5, y: -20),
            Point(x: -7.5, y: 2.5),
            Point(x:-31, y:-4)
        ],
        // test 18
        [
            Point(x: -10, y:  5),
            
            Point(x:  -5, y:  5),
            Point(x:   0, y:  0),
            Point(x:   5, y:  5),
            Point(x:  10, y:  5),
            Point(x:  10, y: -5),
            Point(x:   5, y: -5),
            Point(x:   0, y:  0),
            Point(x:  -5, y: -5),
            Point(x: -10, y: -5)
        ],
        // test 19
        [
            Point(x:-0.5, y: -5),
            Point(x:-10, y: 0),
            Point(x:-10, y: 10),
            Point(x:20, y: 10),
            Point(x:10, y: 5),
            Point(x:10, y: 0),
            Point(x:5, y: 5),
            Point(x:0, y: -15)
        ],
        // test 20
        [
            Point(x:-5, y: -5),
            Point(x:-20, y: 10),
            Point(x: 20, y: 10),
            Point(x: 15, y: -5),
            Point(x: 5, y: 5),
            Point(x: 0, y: -15)
        ],
        // test 21
        [
            Point(x:-15, y: 15),
            Point(x: 3, y: 15),
            Point(x: 5, y: 5),
            Point(x: 10, y: -4),
            Point(x: 17, y: -8),
            Point(x: 9, y: -10),
            Point(x: 8.5, y: -7),
            Point(x:-5, y: 2)
        ]
    ]
}

#endif
