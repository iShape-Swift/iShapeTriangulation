//
//  PlainShapeList.swift
//  iGeometry
//
//  Created by Nail Sharipov on 24.12.2019.
//  Copyright © 2019 iShape. All rights reserved.
//

public struct PlainShapeList {
    
    public static let empty = PlainShapeList(points: [], layouts: [], segments: [])
    
    public struct Segment: Equatable {
        
        public let begin: Int
        public let length: Int
        public var end: Int {
            return begin + length - 1
        }
        
        
        public init(begin: Int, length: Int) {
            self.begin = begin
            self.length = length
        }
    }

    public private (set) var points: [IntPoint]
    public private (set) var layouts: [PlainShape.Layout]
    public private (set) var segments: [Segment]
    
    
    public init(minimumPointsCapacity: Int, minimumLayoutsCapacity: Int, minimumSegmentsCapacity: Int) {
        self.points = [IntPoint]()
        self.points.reserveCapacity(minimumPointsCapacity)
        self.layouts = [PlainShape.Layout]()
        self.layouts.reserveCapacity(minimumLayoutsCapacity)
        self.segments = [Segment]()
        self.segments.reserveCapacity(minimumSegmentsCapacity)
    }
    
    public init(points: [IntPoint], layouts: [PlainShape.Layout], segments: [Segment]) {
        self.points = points
        self.layouts = layouts
        self.segments = segments
    }
    
    public init(plainShape: PlainShape) {
        self.segments = [Segment(begin: 0, length: plainShape.layouts.count)]
        self.layouts = plainShape.layouts
        self.points = plainShape.points
    }
    
    public func get(index: Int) -> PlainShape {
        let segment = self.segments[index]

        let layouts = Array(self.layouts[segment.begin...segment.end])
        
        var offset: Int = 0
        if index > 0 {
            for i in 0..<index {
                let s = self.segments[i]
                let l = self.layouts[s.end]
                offset += l.end + 1
            }
        }
        
        let pointBegin = layouts[0].begin + offset
        let pointEnd = layouts[layouts.count - 1].end + offset
        let points = Array(self.points[pointBegin...pointEnd])
        
        return PlainShape(points: points, layouts: layouts)
    }

    public mutating func add(plainShape: PlainShape) {
        self.segments.append(Segment(begin: self.layouts.count, length: plainShape.layouts.count))
        self.points.append(contentsOf: plainShape.points)
        self.layouts.append(contentsOf: plainShape.layouts)
    }
    
    public mutating func append(list: PlainShapeList) {
        for i in 0..<list.layouts.count {
            let plainShape = list.get(index: i)
            self.add(plainShape: plainShape)
        }
    }
}
