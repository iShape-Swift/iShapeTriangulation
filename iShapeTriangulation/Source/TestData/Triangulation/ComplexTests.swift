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
                Point(x:41.74223, y: 8.30298)
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
                Point(x:16, y: 0)
            ]
        ],
        [
            [
                Point(x:32, y: 0),                  // 0
                Point(x:16.63412, y: -3.308732),    // 1
                Point(x:29.56414, y: -12.24587),    // 2
                Point(x:39.11233, y: -26.13403),    // 3
                Point(x:22.62741, y: -22.62741),    // 4
                Point(x:9.42247, y: -14.10172),     // 5
                Point(x:12.24587, y: -29.56414),    // 6
                Point(x:9.177051, y: -46.13614),    // 7
                Point(x:0, y: -32),                 // 8
                Point(x:-3.30873, y: -16.63412),    // 9
                Point(x:-12.24586, y: -29.56413),   // 10
                Point(x:-26.13402, y: -39.11234),   // 11
                Point(x:-22.62742, y: -22.62742),   // 12
                Point(x:-14.10172, y: -9.42247),    // 13
                Point(x:-29.56417, y: -12.24587),   // 14
                Point(x:-46.13614, y: -9.177038),   // 15
                Point(x:-32, y: 0),                 // 16
                Point(x:-16.63412, y: 3.308738),    // 17
                Point(x:-29.56419, y: 12.24591),    // 18
                Point(x:-39.11232, y: 26.13405),    // 19
                Point(x:-22.62735, y: 22.62738),    // 20
                Point(x:-9.422461, y: 14.10173),    // 21
                Point(x:-12.24588, y: 29.56424),    // 22
                Point(x:-9.177009, y: 46.13615),    // 23
                Point(x:0, y: 32),                  // 24
                Point(x:3.308749, y: 16.63411),     // 25
                Point(x:12.24596, y: 29.56426),     // 26
                Point(x:26.13407, y: 39.1123),      // 27
                Point(x:22.62734, y: 22.62728),     // 28
                Point(x:14.10174, y: 9.422452),     // 29
                Point(x:29.56433, y: 12.24589),     // 30
                Point(x:46.13615, y: 9.176978)      // 31
            ],
            [
                Point(x:23.06808, y: 4.588489),     // 32
                Point(x:14.78216, y: 6.122947),     // 33
                Point(x:7.050869, y: 4.711226),     // 34
                Point(x:11.31367, y: 11.31364),     // 35
                Point(x:13.06704, y: 19.55615),     // 36
                Point(x:6.122978, y: 14.78213),     // 37
                Point(x:1.654375, y: 8.317057),     // 38
                Point(x:0, y: 16),                  // 39
                Point(x:-4.588504, y: 23.06807),    // 40
                Point(x:-6.122941, y: 14.78212),    // 41
                Point(x:-4.71123, y: 7.050865),     // 42
                Point(x:-11.31367, y: 11.31369),    // 43
                Point(x:-19.55616, y: 13.06702),    // 44
                Point(x:-14.7821, y: 6.122953),     // 45
                Point(x:-8.317058, y: 1.654369),    // 46
                Point(x:-16, y: 0),                 // 47
                Point(x:-23.06807, y: -4.588519),   // 48
                Point(x:-14.78208, y: -6.122936),   // 49
                Point(x:-7.050862, y: -4.711235),   // 50
                Point(x:-11.31371, y: -11.31371),   // 51
                Point(x:-13.06701, y: -19.55617),   // 52
                Point(x:-6.122929, y: -14.78206),   // 53
                Point(x:-1.654365, y: -8.317059),   // 54
                Point(x:0, y: -16),                 // 55
                Point(x:4.588525, y: -23.06807),    // 56
                Point(x:6.122935, y: -14.78207),    // 57
                Point(x:4.711235, y: -7.050862),    // 58
                Point(x:11.31371, y: -11.31371),    // 59
                Point(x:19.55617, y: -13.06701),    // 60
                Point(x:14.78207, y: -6.122935),    // 61
                Point(x:8.317059, y: -1.654366),    // 62
                Point(x:16, y: 0)                   // 63
            ]
        ],
        ComplexTests.donut(count: 128, radius: 16, k: 0.5),
        ComplexTests.circle(count: 16, radius: 4, k: 0.03),
    ]
    
    private static func donut(count: Int, radius: Float, k: Float) -> [[Point]] {
        let n = Float(count)
        
        let da0 = 2 * Float.pi / n
        let da1 = 16 * Float.pi / n
        let delta = k * radius
        
        var hull = [Point](repeating: .zero, count: count)
        
        var a0: Float = 0
        var a1: Float = 0
        
        
        for i in 0..<count {
            let r = radius + delta * sin(a1)
            let x = r * cos(a0)
            let y = r * sin(a0)
            a0 -= da0
            a1 -= da1
            hull[i] = Point(x: x, y: y)
        }
        
        var hole = [Point](repeating: .zero, count: count)
        
        for i in 0..<count {
            
            let p = hull[count - i - 1]
            hole[i] = Point(x: 0.5 * p.x, y: 0.5 * p.y)
            
        }
        return [hull, hole]
    }
    
    private static func circle(count: Int, radius: Float, k: Float) -> [[Point]] {
        let n = Float(count)
        
        let da0 = 2 * Float.pi / n
        let delta = k * radius
        
        var hull = [Point](repeating: .zero, count: count)
        
        var a0: Float = 0
        let r = radius + delta

        for i in 0..<count {
            let x = r * cos(a0)
            let y = r * sin(a0)
            a0 -= da0
            hull[i] = Point(x: x, y: y)
        }
        
        var hole = [Point](repeating: .zero, count: count)
        
        for i in 0..<count {
            let p = hull[count - i - 1]
            hole[i] = Point(x: 0.5 * p.x, y: 0.5 * p.y)
            
        }
        return [hull, hole]
    }
    
    
}

#endif

