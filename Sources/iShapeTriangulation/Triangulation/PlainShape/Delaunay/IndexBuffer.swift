//
//  IndexBuffer.swift
//  iShapeTriangulation iOS
//
//  Created by Nail Sharipov on 15.09.2020.
//

struct IndexBuffer {
    
    private struct Link {
        static let empty = Link(prev: -1, empty: true, next: -1)
        var prev: Int
        let empty: Bool
        var next: Int
    }
    
    private var array: [Link]
    private var first: Int
    
    init(count: Int) {
        guard count > 0 else {
            self.array = []
            self.first = -1
            return
        }
        self.first = 0
        self.array = [Link](repeating: .empty, count: count)
        for i in 0..<count {
            self.array[i] = Link(prev: i - 1, empty: false, next: i + 1)
        }
        self.array[count - 1].next = -1
    }

    @inline(__always)
    var hasNext: Bool {
        return first >= 0
    }

    @inline(__always)
    mutating func next() -> Int {
        let index = first
        first = array[index].next
        
        // remove
        if first >= 0 {
            array[first].prev = -1
        }
        array[index] = .empty

        return index
    }

    @inline(__always)
    mutating func add(index: Int) {
        let isOverflow = index >= self.array.count
        if isOverflow || self.array[index].empty {
            if isOverflow {
                let n = self.array.count - index
                for _ in 0...n {
                    self.array.append(.empty)
                }
            }
            array[index] = Link(prev: -1, empty: false, next: first)
            if first >= 0 {
                array[first].prev = index
            }
            first = index
        }
    }

    @inline(__always)
    mutating func remove(index: Int) {
        let link = array[index]
        if link.next >= 0 {
            array[link.next].prev = link.prev
        }
        if link.prev >= 0 {
            array[link.prev].next = link.next
        }
        array[index] = .empty
        if first == index {
            first = link.next
        }
    }

}
