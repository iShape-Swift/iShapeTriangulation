//
//  SVG.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16.05.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

import Foundation

struct SVG {
    static func svgPrint(pathes: [[CGPoint]], lines: [[CGPoint]]? = nil) {
        var id = 0
        for path in pathes {
            print("<path")
            print("id=\"\(id)\"")
            print("d=\"M \(svgPath(path: path)) Z\"")
            print("style=\"fill:none;stroke:#000000;stroke-width:1.0;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;stroke-miterlimit:4;stroke-dasharray:none\" />")
            id += 1
        }
        guard let lines = lines else { return }
        for path in lines {
            print("<path")
            print("id=\"\(id)\"")
            print("d=\"M \(svgPath(path: path))\"")
            print("style=\"fill:none;stroke:#000000;stroke-width:1.0;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;stroke-miterlimit:4;stroke-dasharray:none\" />")
            id += 1
        }
    }

    private static func svgPath(path: [CGPoint]) -> String {
        var result = String()
        for i in 0..<path.count {
            let p = path[i]
            let x = String(format: "%.1f", p.x)
            let y = String(format: "%.1f", p.y)
            result.append("\(x), \(y)")
            if i + 1 != path.count {
                result.append(",")
            }
        }
        return result
    }
}
