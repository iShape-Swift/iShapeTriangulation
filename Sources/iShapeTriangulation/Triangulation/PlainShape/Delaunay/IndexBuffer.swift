//
//  IndexBuffer.swift
//  iShapeTriangulation iOS
//
//  Created by Nail Sharipov on 15.09.2020.
//

struct IndexBuffer {
    
    private var array: [Int]
    private var map: [Int]
    
    init(count: Int) {
        self.array = [Int](repeating: 0, count: count)
        self.map = [Int](repeating: -1, count: count)
        for i in 0..<count {
            let index = count &- i &- 1
            self.array[i] = index
            self.map[index] = i
        }
    }

    @inline(__always)
    var hasNext: Bool {
        return !self.array.isEmpty
    }

    @inline(__always)
    mutating func next() -> Int {
        let last = self.array.removeLast()
        self.map[last] = -1
        return last
    }

    @inline(__always)
    mutating func add(index: Int) {
        if index >= self.map.count {
            let n = self.map.count - index
            for _ in 0...n {
                self.map.append(-1)
            }
            self.map[index] = self.array.count
            self.array.append(index)
        } else if self.map[index] == -1 {
            self.map[index] = self.array.count
            self.array.append(index)
        }
    }

    @inline(__always)
    mutating func remove(index: Int) {
        let j = self.map[index]
        if j >= 0 {
            self.map[index] = -1
            self.array.remove(at: j)
        }
    }

}
