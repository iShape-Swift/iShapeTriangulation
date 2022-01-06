//
//  TriangulationError.swift
//  iShapeTriangulation iOS
//
//  Created by Nail Sharipov on 04.01.2022.
//

import iGeometry

public enum TriangulationError: Error {
    case notValidPath(PlainShape.Validation)
}
