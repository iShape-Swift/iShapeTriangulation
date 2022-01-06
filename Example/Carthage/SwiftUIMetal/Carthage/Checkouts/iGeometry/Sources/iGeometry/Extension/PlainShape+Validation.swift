//
//  IntShape+Validation.swift
//  iGeometry
//
//  Created by Nail Sharipov on 02/10/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

public extension PlainShape {
    
    enum Validation {
        
        public struct Edge {
            public let a: Int
            public let b: Int
        }
        
        case valid
        case hasSamePoints(Int, Int)
        case hullIsNotClockWise
        case holeIsNotCounterClockWise(Int)
        case hullIsSelfIntersecting(Edge, Edge)
        case holeIsSelfIntersecting(Edge, Edge)
        case hullIsIntersectingHole(Edge, Edge)
        case holeIsIntersectingHole(Edge, Edge)
    }
    
    func isClockWise(index:  Int) -> Bool {
        let layout = self.layouts[index]
        return self.isClockWise(begin: layout.begin, end: layout.end)
    }

    func validate() -> Validation {
        var result = self.validateVerticesList()
        guard case .valid = result else {
            return result
        }
        
        result = self.validateIntersections()
        guard case .valid = result else {
            return result
        }
        
//        result = self.validateSamePoints()

        return result
    }
    
    private func validateVerticesList() -> Validation {
        var i = 0
        for layout in layouts {
            let isCCW = self.isClockWise(begin: layout.begin, end: layout.end)
            if layout.isHole {
                if isCCW {
                    return .holeIsNotCounterClockWise(i - 1)
                }
            } else {
                if !isCCW {
                    return .hullIsNotClockWise
                }
            }
            i += 1
        }
    
        return .valid
    }

    
    private func validateIntersections() -> Validation {
        let n = layouts.count
        for i in 0..<n {
            let first = layouts[i]
            if i != n {
                if let result = self.isSelfIntersected(begin: first.begin, end: first.end) {
                    if first.isHole {
                        return .holeIsSelfIntersecting(result.0, result.1)
                    } else {
                        return .hullIsSelfIntersecting(result.0, result.1)
                    }
                }
                for j in (i + 1)..<n {
                    let second = layouts[j]
                    if let result = self.isIntersected(first: first, second: second) {
                        if first.isHole {
                            return .holeIsIntersectingHole(result.0, result.1)
                        } else {
                            return .hullIsIntersectingHole(result.0, result.1)
                        }
                    }
                }
            }
        }
        
        return .valid
    }
    
    private func validateSamePoints() -> Validation {
        let n = self.points.count
        for i in 0..<n - 1 {
            let a = self.points[i]
            for j in i+1..<n {
                let b = self.points[j]
                if a.x == b.x && a.y == b.y {
                    return .hasSamePoints(i, j)
                }
            }
        }
    
        return .valid
    }

    private func isClockWise(begin: Int, end: Int) -> Bool {
        var sum: Int64 = 0
        var p1 = self.points[end]
        for i in begin...end {
            let p2 = self.points[i]
            let difX = p2.x - p1.x
            let sumY = p2.y + p1.y
            sum += difX * sumY
            p1 = p2
        }
        
        return sum >= 0
    }
    
    private func isSelfIntersected(begin: Int, end: Int) -> (Validation.Edge, Validation.Edge)? {
        guard end - begin > 2 else {
            return nil
        }
        for i in begin...end - 2 {
            let a = self.points[i]
            let b = self.points[i + 1]
            var j = i + 2
            var c = self.points[j]
            var j0 = j
            j = j + 1 <= end ? j + 1 : begin
            while j != i {
                let d = self.points[j]
                if PlainShape.areSegmentsIntersecting(a: a, b: b, c: c, d: d) {
                    return (Validation.Edge(a: i, b: i + 1), Validation.Edge(a: j0, b: j))
                }
                c = d
                j0 = j
                j = j + 1 <= end ? j + 1 : begin
            }
        }
        return nil
    }
    
    private func isIntersected(first: Layout, second: Layout) -> (Validation.Edge, Validation.Edge)? {
        for i in first.begin...first.end {
            let i1 = i + 1 <= first.end ? i + 1 : first.begin
            let a = self.points[i]
            let b = self.points[i1]
            for j in second.begin...second.end {
                let j1 = j + 1 <= second.end ? j + 1 : second.begin
                let c = self.points[j]
                let d = self.points[j + 1 <= second.end ? j + 1 : second.begin]
                if PlainShape.areSegmentsIntersecting(a: a, b: b, c: c, d: d) {
                    return (Validation.Edge(a: i, b: i1), Validation.Edge(a: j, b: j1))
                }
            }
        }
        return nil
    }
    
    
    private static func areSegmentsIntersecting(a: IntPoint, b: IntPoint, c: IntPoint, d: IntPoint) -> Bool {
        let x0 = isCCW(a: a, b: c, c: d)
        let x1 = isCCW(a: b, b: c, c: d)
        let x2 = isCCW(a: a, b: b, c: c)
        let x3 = isCCW(a: a, b: b, c: d)
        return x0 != x1 && x2 != x3 && x0 != 0 && x1 != 0 && x2 != 0 && x3 != 0
    }
    
    private static func isCCW(a: IntPoint, b: IntPoint, c: IntPoint) -> Int {
        let m0 = (c.y - a.y) * (b.x - a.x)
        let m1 = (b.y - a.y) * (c.x - a.x)
        
        if m0 < m1 {
            return 1
        } else if m0 > m1 {
            return -1
        } else {
            return 0
        }
    }
}

