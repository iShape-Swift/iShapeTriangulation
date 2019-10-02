//
//  TrianglesCompare.swift
//  iShapeTests
//
//  Created by Nail Sharipov on 02/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

import Foundation


extension Array where Element == Int {
    
    func compare(array: [Int]) -> Bool {
        guard self.count == array.count, self.count % 3 == 0 else {
            return false
        }
        
        var j = 0
        for i in 0..<self.count {
            j += 1
            if j == 3 {
                let a = self[i]
                let b = self[i - 1]
                let c = self[i - 2]
                
                let a0 = array[i]
                let b0 = array[i - 1]
                let c0 = array[i - 2]
                if !(a == a0 && b == b0 && c == c0 ||
                    a == c0 && b == a0 && c == b0 ||
                    a == b0 && b == c0 && c == a0) {
                    return false
                }
                j = 0
            }
        }

        return true
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
