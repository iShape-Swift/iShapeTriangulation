//
//  TrianglesCompare.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 02/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import Foundation

private struct Triangle: Hashable {
    
    let a: Int
    let b: Int
    let c: Int
    
    func hash(into hasher: inout Hasher) {
        if a > b && a > c {
            hasher.combine(a)
        } else if b > a && b > c {
            hasher.combine(b)
        } else {
            hasher.combine(c)
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return
            lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c ||
                lhs.a == rhs.b && lhs.b == rhs.c && lhs.c == rhs.a ||
                lhs.a == rhs.c && lhs.b == rhs.a && lhs.c == rhs.b
    }
}


extension Array where Element == Int {
    
    func compare(array: [Int]) -> Bool {
        guard self.count == array.count, self.count % 3 == 0 else {
            return false
        }
        
        let a = self.triangles
        let b = array.triangles
        var set = Set(a)
        
        for triangle in b {
            if set.remove(triangle) == nil {
                return false
            }
        }
        
        return true
    }
    
    private var triangles: [Triangle] {
        get {
            let n = self.count
            var result = Array<Triangle>(repeating: .init(a: 0, b: 0, c: 0), count: n / 3)
            var i = 0
            while i < n {
                let a = self[i]
                let b = self[i + 1]
                let c = self[i + 2]
                
                result[i / 3] = Triangle(a: a, b: b, c: c)
                
                i += 3
            }
            return result
        }
    }
    
    var prettyString: String {
        guard self.count % 3 == 0 else {
            return ""
        }
        var j = 0
        var result = String()
        for i in 0..<self.count {
            j += 1
            if j == 3 {
                if i != 2 {
                    result += ",\n"
                }
                result += "\(self[i - 2]), \(self[i - 1]), \(self[i])"
                j = 0
            }
        }
        return result
    }
}
