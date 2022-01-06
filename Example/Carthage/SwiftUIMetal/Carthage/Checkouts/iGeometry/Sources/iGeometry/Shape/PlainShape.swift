//
//  PlainShape.swift
//  iGeometry
//
//  Created by Nail Sharipov on 23/09/2019.
//  Copyright © 2019 iShape. All rights reserved.
//

public struct PlainShape: Equatable {

    public struct Layout: Equatable {
        
        public let begin: Int
        public let length: Int
        public var end: Int {
            return begin + length - 1
        }
        
        public let isClockWise: Bool

        public var isHole: Bool {
            return !isClockWise
        }
        
        var isEmpty: Bool {
            return begin == -1
        }

        public init(begin: Int, length: Int, isClockWise: Bool) {
            self.begin = begin
            self.length = length
            self.isClockWise = isClockWise
        }
    }
    
    public static let empty = PlainShape(points: [], layouts: [])
    
    public var points: [IntPoint]
    public var layouts: [Layout]
    
    public init(pointsCapacity: Int, layoutsCapacity: Int) {
        self.points = Array<IntPoint>()
        self.points.reserveCapacity(pointsCapacity)
        self.layouts = Array<Layout>()
        self.layouts.reserveCapacity(layoutsCapacity)
    }
    
    public init(points: [IntPoint], layouts: [Layout]) {
        self.points = points
        self.layouts = layouts
    }
    
    public init(points: [IntPoint]) {
        self.points = points
        self.layouts = [Layout(begin: 0, length: points.count, isClockWise: true)]
    }

    public init(iShape: IntShape) {
        var count = iShape.hull.count
        for hole in iShape.holes {
            count += hole.count
        }
        
        var points = [IntPoint]()
        points.reserveCapacity(count)
        
        var layouts = [Layout]()
        layouts.reserveCapacity(iShape.holes.count + 1)
        
        var start = 0
        points.append(contentsOf: iShape.hull)
        
        let layout = Layout(begin: start, length: iShape.hull.count, isClockWise: true)
        layouts.append(layout)
        
        
        start = layout.length
        for hole in iShape.holes {
            points.append(contentsOf: hole)
            let layout = Layout(begin: start, length: hole.count, isClockWise: false)
            layouts.append(layout)
            
            start += hole.count
        }
        
        self.points = points
        self.layouts = layouts
    }
    
    public func get(index: Int) -> [IntPoint] {
        let layout = self.layouts[index]
        let path = Array(self.points[layout.begin...layout.end])
        return path
    }
    
    public func get(layout: Layout) -> [IntPoint] {
        let slice = self.points[layout.begin...layout.end]
        return Array(slice)
    }

    public mutating func add(hole: [IntPoint]) {
        let layout = Layout(begin: self.points.count, length: hole.count, isClockWise: false)
        self.points.append(contentsOf: hole)
        self.layouts.append(layout)
    }
    
    public mutating func add(path: [IntPoint], isClockWise: Bool) {
        let begin = points.count
        let layout = Layout(
            begin: begin,
            length: path.count,
            isClockWise: isClockWise
        )
        points.append(contentsOf: path)
        layouts.append(layout)
    }
    
    public mutating func remove(index: Int) {
        let count = self.layouts.count
        guard !(index == 0 && count == 1)  else {
            self.layouts.removeLast()
            self.points.removeAll()
            return
        }
        
        let layout = self.layouts[index]
        let lastLayout = self.layouts[count - 1]
        self.layouts.remove(at: index)
        
        let tailStart = layout.begin + layout.length
        let length = lastLayout.begin + lastLayout.length - tailStart
        let slice = Array(self.points[tailStart..<tailStart + length])
        self.points.replaceSubrange(layout.begin..<layout.begin + length, with: slice)
    }
    
    public mutating func replace(index: Int, path: [IntPoint]) {
        let oldLayout = self.layouts[index]
        let newLayout = Layout(
            begin: oldLayout.begin,
            length: path.count,
            isClockWise: oldLayout.isClockWise
        )
        if newLayout.length == oldLayout.length {
            var j = 0
            for i in oldLayout.begin...oldLayout.end {
                self.points[i] = path[j]
                j += 1
            }
        } else if index + 1 == self.layouts.count {
            self.layouts[index] = newLayout
            self.points.removeLast(oldLayout.length)
            self.points.append(contentsOf: path)
        } else {
            self.layouts[index] = newLayout
            let tail = Array(self.points[oldLayout.end + 1..<self.points.count])
            let removeLength = self.points.count - oldLayout.begin
            self.points.removeLast(removeLength)
            self.points.append(contentsOf: path)
            self.points.append(contentsOf: tail)
            let shift = newLayout.length - oldLayout.length
            var i = index + 1
            while i < self.layouts.count {
                let lt = self.layouts[i]
                self.layouts[i] = Layout(
                    begin: lt.begin + shift,
                    length: lt.length,
                    isClockWise: lt.isClockWise
                )
                i += 1
            }
        }
    }
}
