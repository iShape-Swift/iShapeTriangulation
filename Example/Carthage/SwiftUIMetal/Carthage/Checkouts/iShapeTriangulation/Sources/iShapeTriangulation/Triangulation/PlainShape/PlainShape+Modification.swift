//
//  PlainShape+Modification.swift
//  iGeometry
//
//  Created by Nail Sharipov on 20.07.2020.
//

import iGeometry

public extension PlainShape {
    
    mutating func modified(maxEgeSize: Int64) -> PlainShape {
        var points = [IntPoint]()
        points.reserveCapacity(self.points.count)
        var layouts = [Layout]()
        layouts.reserveCapacity(self.layouts.count)
        
        let sqrMaxSize = maxEgeSize * maxEgeSize
        
        var n = 0
        
        for layout in self.layouts {
            let last = layout.end
            var a = self.points[last]
            var j = 0
            for i in layout.begin...last {
                let b = self.points[i]
                let dx = b.x - a.x
                let dy = b.y - a.y
                let sqrSize = dx * dx + dy * dy
                if sqrSize <= sqrMaxSize {
                    j += 1
                    points.append(b)
                } else {
                    let l = Int64(Double(sqrSize).squareRoot())
                    let s = Int(l / maxEgeSize)
                    let ds = Double(s)
     
                    let sx = Double(dx) / ds
                    let sy = Double(dy) / ds
                    var fx: Double = 0
                    var fy: Double = 0
                    for _ in 1..<s {
                        fx += sx
                        fy += sy
                        
                        let x = a.x + Int64(fx)
                        let y = a.y + Int64(fy)
                        points.append(IntPoint(x: x, y: y))
                    }
                    points.append(b)
                    j += s
                }
                a = b
            }
            layouts.append(Layout(begin: n, length: j, isClockWise: layout.isClockWise))
            n += j
        }
        return PlainShape(points: points, layouts: layouts)
    }
    
    mutating func modify(maxEgeSize: Int64) {
        let shape = self.modified(maxEgeSize: maxEgeSize)
        self.points = shape.points
        self.layouts = shape.layouts
    }
    
}
