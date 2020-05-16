//
//  Colors.swift
//  iShapeUI
//
//  Created by Nail Sharipov on 16/07/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Cocoa

struct Colors {
    
    static let white = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    static let black = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    static let veryLightGray = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    static let lightGray = NSColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor
    static let easyGray = NSColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.2).cgColor
    static let gray = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
    static let darkGray = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
    static let clear = NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).cgColor
    
    static let veryLightBlue = NSColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
    static let lightBlue = NSColor(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0).cgColor
    static let blue = NSColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0).cgColor
    static let darkBlue = NSColor(red: 0.3, green: 0.3, blue: 1.0, alpha: 1.0).cgColor
    
    static let darkGreen = NSColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1.0).cgColor
    
    static let red = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    static let yellow = NSColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0).cgColor
    
    static let orange = NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0).cgColor
    
    static let master = NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0).cgColor
    static let master_second = NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.2).cgColor
    static let slave = NSColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0).cgColor
    static let slave_second = NSColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 0.2).cgColor
    
    static let border = NSColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 0.6).cgColor
    static let solution = NSColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5).cgColor
    static let solution_border = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2).cgColor
    static let solution_second = NSColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 0.5).cgColor
    static let solution_second_border = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2).cgColor
    
    static let into = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    static let out = NSColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0).cgColor
    
    static let shapeColors: [NSColor] = [
        NSColor.purple,
        NSColor(red: 243 / 255, green: 156 / 255, blue: 18 / 255, alpha: 1.0),
        NSColor.magenta,
        NSColor(red: 40 / 255, green: 116 / 255, blue: 166 / 255, alpha: 1.0),
        NSColor.brown
    ]
    
    static func getColor(index: Int) -> NSColor {
        let i = index % Colors.shapeColors.count
        
        let color = shapeColors[i]
        
        return NSColor.init(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: 0.8)
    }
    
}
