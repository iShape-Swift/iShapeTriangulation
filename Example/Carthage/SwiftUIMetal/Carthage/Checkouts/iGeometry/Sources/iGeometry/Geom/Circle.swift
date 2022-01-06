//
//  Circle.swift
//  iGeometry
//
//  Created by Nail Sharipov on 13.02.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

public struct Circle {
    public let center: Point
    public let radius: Float
    
    init(center: Point, radius: Float) {
        self.center = center
        self.radius = radius
    }
}
