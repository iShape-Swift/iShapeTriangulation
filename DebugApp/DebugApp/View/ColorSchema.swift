//
//  ColorShema.swift
//  DebugApp
//
//  Created by Nail Sharipov on 09.08.2020.
//  Copyright © 2020 Nail Sharipov. All rights reserved.
//

import SwiftUI

protocol Schema {
    var defaultPolygonStroke: Color { get }
    var defaultTriangleStroke: Color { get }
}


final class ColorSchema: ObservableObject {

    struct WhiteSchema: Schema {
        let defaultPolygonStroke: Color = .init(white: 0.2)
        let defaultTriangleStroke: Color = .init(white: 0.5)
    }
    
    @Published var schema: Schema = WhiteSchema()

}
