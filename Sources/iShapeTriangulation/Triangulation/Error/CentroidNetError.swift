//
//  CentroidNetError.swift
//  iShapeTriangulation iOS
//
//  Created by Nail Sharipov on 04.01.2022.
//

import iGeometry

public enum CentroidNetError: Error {
    case notValidPath(PlainShape.Validation)
}
