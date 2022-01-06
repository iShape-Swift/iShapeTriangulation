//
//  UniversalData.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 30.01.2021.
//

#if DEBUG

import iGeometry

public struct UniversalData {
    
    public struct LayoutBundle {
        public let points: [Point]
        public let hull: ArraySlice<Point>
        public let holes: [ArraySlice<Point>]?
        public let extraPoints: [Point]?
    }
    
    public var points: [[Point]]
    private let hasInnerPoints: Bool
    private var hasHoles: Bool {
        hasInnerPoints && points.count > 2 || points.count > 1
    }
    
    public var path: [Point] {
        points[0]
    }
    
    public var holes: [[Point]] {
        guard hasHoles else {
            return []
        }
        var holes = self.points
        holes.removeFirst()
        if hasInnerPoints {
            holes.removeLast()
        }
        return holes
    }
    
    public var bundle: LayoutBundle {
        var paths = self.points
        let points = paths.flatMap({ $0 })

        var n = paths.removeFirst().count
        let hull = points[0..<n]
        
        let extraPoints: [Point]?
        if hasInnerPoints {
            extraPoints = paths.removeLast()
        } else {
            extraPoints = nil
        }
        
        let holes: [ArraySlice<Point>]?
        if hasHoles {
            var aHoles = [ArraySlice<Point>]()
            for i in 1..<paths.count {
                let hole = paths[i]
                aHoles.append(points[n..<n + hole.count])
                n += hole.count
            }
            holes = aHoles
        } else {
            holes = nil
        }

        return LayoutBundle(points: points, hull: hull, holes: holes, extraPoints: extraPoints)
    }
  
    
//    points: [Point], hull: ArraySlice<Point>, holes: [ArraySlice<Point>]?
    
    
//    let extraPoints: [Point]? = nil
//    let points = paths.flatMap({ $0 })
//    let path = paths[0]
//
//    let hull = points[0..<path.count]
//
//    var holes = [ArraySlice<Point>]()
//    var n = hull.count
//    if paths.count > 1 {
//        for i in 1..<paths.count {
//            let hole = paths[i]
//            holes.append(points[n..<n + hole.count])
//            n += hole.count
//        }
//    }
    
    public init(path: [Point], holes: [[Point]]? = nil, innerPoints: [Point]? = nil) {
        var points = [[Point]]()
        points.append(path)
        
        if let holes = holes, !holes.isEmpty {
            for hole in holes where holes.count > 2 {
                points.append(hole)
            }
        }

        if let innerPoints = innerPoints, !innerPoints.isEmpty {
            points.append(innerPoints)
            hasInnerPoints = true
        } else {
            hasInnerPoints = false
        }
        
        self.points = points
    }

}


#endif
