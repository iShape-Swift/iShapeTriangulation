//
//  IndexBuffer.swift
//  iShapeTriangulation iOS
//
//  Created by Nail Sharipov on 15.09.2020.
//

struct IndexBuffer {
    
    private var array: [Int]
    private var map: [Bool]
    
    init(count: Int) {
        self.array = [Int](repeating: 0, count: count)
        self.map = [Bool](repeating: true, count: count)
        for i in 0..<count {
            self.array[i] = count - i - 1
        }
    }

    @inline(__always)
    var hasNext: Bool {
        return !self.array.isEmpty
    }

    @inline(__always)
    mutating func next() -> Int {
        let last = self.array.removeLast()
        self.map[last] = false
        return last
    }

    @inline(__always)
    mutating func add(index: Int) {
        if index >= self.map.count {
            let n = self.map.count - index
            for _ in 0...n {
                self.map.append(false)
            }
            self.map[index] = true
            self.array.append(index)
        } else if !self.map[index] {
            self.map[index] = true
            self.array.append(index)
        }
    }

    @inline(__always)
    mutating func add(indices: [Int]) {
        for index in indices {
            self.add(index: index)
        }
    }
}
