//
//  IntPoint+Array.swift
//  iGeometry
//
//  Created by Nail Sharipov on 01.01.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

public extension Array where Element == IntPoint {

    var area: Int64 {
        guard var p1 = self.last else {
            return 0
        }
        
        var sum: Int64 = 0
        
        for p2 in self {
            let x = p2.x &- p1.x
            let y = p2.y &+ p1.y
            sum &+= x * y
            p1 = p2
        }

        return sum >> 1
    }
    
    mutating func invert() {
        let n = self.count
        let m = n >> 1
        for i in 0..<m {
            let j = n - i - 1
            let a = self[i]
            let b = self[j]
            self[i] = b
            self[j] = a
        }
    }
}
