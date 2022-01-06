//
//  DBPoint.swift
//  iGeometry
//
//  Created by Nail Sharipov on 09.04.2020.
//  Copyright © 2020 iShape. All rights reserved.
//

public struct DBPoint {
    
    public static let zero = DBPoint(x: 0, y: 0)
    
    public let x: Double
    public let y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public init(iPoint: IntPoint) {
        self.x = Double(iPoint.x)
        self.y = Double(iPoint.y)
    }
}
