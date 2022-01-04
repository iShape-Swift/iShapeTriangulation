//
//  PlainShape+PlainTriangulation.swift
//  iShapeTriangulation
//
//  Created by Nail Sharipov on 21/09/2019.
//  Copyright © 2019 Nail Sharipov. All rights reserved.
//

import iGeometry

public extension PlainShape {
        
    /// Makes plain triangulation for polygon
    /// - Parameter extraPoints: extra points for triangulation
    /// - Returns: Indices of triples which form triangles in clockwise direction
    func triangulate(extraPoints: [IntPoint]? = nil) throws -> [Int] {
        let layout: MonotoneLayout
        do {
            layout = try self.split(maxEdge: 0, extraPoints: extraPoints)
        } catch SplitError.unusedPoint {
            let validation = self.validate()
            throw TriangulationError.notValidPath(validation)
        }
        
        let extraCount: Int = extraPoints?.count ?? 0
        let totalCount = self.points.count + extraCount + ((self.layouts.count - 2) << 1)
        
        var triangles = Array<Int>()
        triangles.reserveCapacity(3 * totalCount)
        var links = layout.links
        for index in layout.indices {
            PlainShape.triangulate(index: index, links: &links, triangles: &triangles)
        }
        
        return triangles
    }
    
    private static func triangulate(index: Int, links: inout [Link], triangles: inout Array<Int>) {
        var c = links[index]
        
        var a0 = links[c.next]
        var b0 = links[c.prev]
        
        while a0.this != b0.this {
            let a1 = links[a0.next]
            let b1 = links[b0.prev]
            
            var aBit0 = a0.vertex.point.bitPack
            var aBit1 = a1.vertex.point.bitPack
            if aBit1 < aBit0 {
                aBit1 = aBit0
            }
            
            var bBit0 = b0.vertex.point.bitPack
            var bBit1 = b1.vertex.point.bitPack
            if bBit1 < bBit0 {
                bBit1 = bBit0
            }
            
            if aBit0 <= bBit1 && bBit0 <= aBit1 {
                if IntTriangle.isNotLine(a: c.vertex.point, b: a0.vertex.point, c: b0.vertex.point) {
                    triangles.append(c.vertex.index)
                    triangles.append(a0.vertex.index)
                    triangles.append(b0.vertex.index)
                }
                
                a0.prev = b0.this
                b0.next = a0.this
                links[a0.this] = a0
                links[b0.this] = b0
                
                if bBit0 < aBit0 {
                    c = b0
                    b0 = b1
                } else {
                    c = a0
                    a0 = a1
                }
            } else {
                if aBit1 < bBit1 {
                    var cx = c
                    var ax0 = a0
                    var ax1 = a1
                    var ax1Bit: Int64 = .min
                    repeat {
                        let orientation = IntTriangle.getOrientation(a: cx.vertex.point, b: ax0.vertex.point, c: ax1.vertex.point)
                        switch orientation {
                        case .clockWise:
                            triangles.append(cx.vertex.index)
                            triangles.append(ax0.vertex.index)
                            triangles.append(ax1.vertex.index)
                            fallthrough
                        case .line:
                            ax1.prev = cx.this
                            cx.next = ax1.this
                            links[cx.this] = cx
                            links[ax1.this] = ax1
                            
                            if cx.this != c.this {
                                // move back
                                ax0 = cx
                                cx = links[cx.prev]
                                continue
                            } else {
                                // move forward
                                ax0 = ax1
                                ax1 = links[ax1.next]
                            }
                        case .counterClockWise:
                            cx = ax0
                            ax0 = ax1
                            ax1 = links[ax1.next]
                        }
                        ax1Bit = ax1.vertex.point.bitPack
                    } while ax1Bit < bBit0
                } else {
                    var cx = c
                    var bx0 = b0
                    var bx1 = b1
                    var bx1Bit: Int64 = .min
                    repeat {
                        let orientation = IntTriangle.getOrientation(a: cx.vertex.point, b: bx1.vertex.point, c: bx0.vertex.point)
                        switch orientation {
                        case .clockWise:
                            triangles.append(cx.vertex.index)
                            triangles.append(bx1.vertex.index)
                            triangles.append(bx0.vertex.index)
                            fallthrough
                        case .line:
                            bx1.next = cx.this
                            cx.prev = bx1.this
                            links[cx.this] = cx
                            links[bx1.this] = bx1
                            
                            if cx.this != c.this {
                                // move back
                                bx0 = cx
                                cx = links[cx.next]
                                continue
                            } else {
                                // move forward
                                bx0 = bx1
                                bx1 = links[bx0.prev]
                            }
                        case .counterClockWise:
                            cx = bx0
                            bx0 = bx1
                            bx1 = links[bx1.prev]
                        }
                        bx1Bit = bx1.vertex.point.bitPack
                    } while bx1Bit < aBit0
                }
                
                c = links[c.this]
                a0 = links[c.next]
                b0 = links[c.prev]
                
                aBit0 = a0.vertex.point.bitPack
                bBit0 = b0.vertex.point.bitPack
                
                if IntTriangle.isNotLine(a: c.vertex.point, b: a0.vertex.point, c: b0.vertex.point) {
                    triangles.append(c.vertex.index)
                    triangles.append(a0.vertex.index)
                    triangles.append(b0.vertex.index)
                }
                a0.prev = b0.this
                b0.next = a0.this
                links[a0.this] = a0
                links[b0.this] = b0
                
                if bBit0 < aBit0 {
                    c = b0
                    b0 = links[b0.prev]
                } else {
                    c = a0
                    a0 = links[a0.next]
                }
                
            } //while
        }
    }
}
