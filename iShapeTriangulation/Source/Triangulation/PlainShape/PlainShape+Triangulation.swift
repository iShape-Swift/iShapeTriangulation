//
//  PlainShape+PlainTriangulation.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import Foundation
import iGeometry

public extension PlainShape {
    
    func triangulate() -> [Int] {
        let layout = self.split()
        let totalCount = self.points.count + ((self.layouts.count - 2) << 1)
        
        var triangles = Array<Int>()
        triangles.reserveCapacity(3 * totalCount)
        var links = layout.links
        for index in layout.indices {
            PlainShape.triangulate(index: index, links: inout links, triangles: &triangles)
        }
        
        return triangles
    }
/*
    private static func triangulate(index: Int, links: [Link], triangles: inout Array<Int>) {
        var c = links[index]
        
        var a0 = links[c.next]
        var b0 = links[c.prev]
        
        repeat {
            let aBit0 = a0.vertex.point.bitPack
            let bBit0 = b0.vertex.point.bitPack
            
            if bBit0 < aBit0 {
                let b1 = links[b0.prev]
                let bBit1 = b1.vertex.point.bitPack
                if bBit1 < aBit0 {
                    let orientation = PlainShape.getOrientation(a: c.vertex.point, b: b1.vertex.point, c: b0.vertex.point)
                    
                    switch orientation {
                    case .clockWise:
                        triangles.append(c.vertex.index)
                        triangles.append(b1.vertex.index)
                        triangles.append(b0.vertex.index)
                        fallthrough
                    case .line:     // don't add this triangle
                        b0 = b1
                        continue
                    default:
                        break
                    }
                }
            } else {
                let a1 = links[a0.next]
                let aBit1 = a1.vertex.point.bitPack
                if aBit1 < bBit0 {
                    let orientation = PlainShape.getOrientation(a: c.vertex.point, b: a0.vertex.point, c: a1.vertex.point)
                    
                    switch orientation {
                    case .clockWise:
                        triangles.append(c.vertex.index)
                        triangles.append(a0.vertex.index)
                        triangles.append(a1.vertex.index)
                        fallthrough
                    case .line:
                        a0 = a1
                        continue
                    default:
                        break
                    }
                }
            }
            
            triangles.append(c.vertex.index)
            triangles.append(a0.vertex.index)
            triangles.append(b0.vertex.index)

            if bBit0 < aBit0 {
                c = b0
                b0 = links[b0.prev]
            } else {
                c = a0
                a0 = links[a0.next]
            }
        } while a0.this != b0.this
    }
    */
    
    private static func triangulate(index: Int, inout links: [Link], triangles: inout Array<Int>) {
        var c = links[index]
        
        var a0 = links[c.next]
        var b0 = links[c.prev]
        
        repeat {
            let a1 = links[a0.next]
            let b1 = links[b0.prev]
            
            let aBit0 = a0.vertex.point.bitPack;
            let aBit1 = a1.vertex.point.bitPack;
            let bBit0 = b0.vertex.point.bitPack;
            let bBit1 = b1.vertex.point.bitPack;
            
            if aBit0 < bBit1 && bBit0 < aBit1 {
                triangles.append(c.vertex.index)
                triangles.append(a0.vertex.index)
                triangles.append(b0.vertex.index)

                if bBit0 < aBit0 {
                    c = b0
                    b0 = b1
                } else {
                    c = a0
                    a0 = a1
                }
            } else {
                if aBit1 < bBit0 {
                    var cx = c
                    var ax0 = a0
                    var ax1 = a1
                    repeat {
                        let orientation = PlainShape.getOrientation(a: cx.vertex.point, b: ax0.vertex.point, c: ax1.vertex.point)
                        switch orientation {
                        case .clockWise:
                            triangles.append(cx.vertex.index)
                            triangles.append(a0.vertex.index)
                            triangles.append(a1.vertex.index)
                        case .line:
                            ax1.prev = cx.this
                            cx.next = ax1.this
                            links[cx.this] = cx
                            links[ax1.this] = ax1
                        default:
                            break
                        }
                        
                        ax0 = ax1
                        ax1 = links[ax0.next]
                    } while ax1.vertex.point.bitPack < bBit1
                }
            }

            
        } while a0.this != b0.this
    }

    private enum Orientation {
        case clockWise
        case counterClockWise
        case line
    }
    
    private static func getOrientation(a: IntPoint, b: IntPoint, c: IntPoint) -> Orientation {
        let m0 = (c.y - a.y) * (b.x - a.x)
        let m1 = (b.y - a.y) * (c.x - a.x)
        
        if m0 < m1 {
            return .clockWise
        } else if m0 > m1 {
            return .counterClockWise
        } else {
            return .line
        }
    }
}
