//
//  Delaunay+Voronoi.swift
//  iGeometry
//
//  Created by Nail Sharipov on 20.05.2020.
//

import Foundation
import iGeometry

extension Delaunay {
    
    private struct Circle {
        var a: Bool
        var b: Bool
        var c: Bool
        let center: Point
        
        init(triangle: Triangle, intGeom: IntGeom) {
            let a = intGeom.float(point: triangle.vertices[0].point)
            let b = intGeom.float(point: triangle.vertices[1].point)
            let c = intGeom.float(point: triangle.vertices[2].point)
            
            let aL = a.x * a.x + a.y * a.y
            let bL = b.x * b.x + b.y * b.y
            let cL = c.x * c.x + c.y * c.y
            
            let d = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
            let x = (aL * (b.y - c.y) + bL * (c.y - a.y) + cL * (a.y - b.y)) / d
            let y = (aL * (c.x - b.x) + bL * (a.x - c.x) + cL * (b.x - a.x)) / d

            self.center = Point(x: x, y: y)
            
            self.a = false
            self.b = false
            self.c = false
        }
    }
    
    private static func inscribedСircle(triangle: Triangle, intGeom: IntGeom) -> Point {
        let a = intGeom.float(point: triangle.vertices[0].point)
        let b = intGeom.float(point: triangle.vertices[1].point)
        let c = intGeom.float(point: triangle.vertices[2].point)
        
        let ABx = a.x - b.x
        let ABy = a.y - b.y
        let AB = sqrt(ABx * ABx + ABy * ABy)
        
        let ACx = a.x - c.x
        let ACy = a.y - c.y
        let AC = sqrt(ACx * ACx + ACy * ACy)
        
        let BCx = b.x - c.x
        let BCy = b.y - c.y
        let BC = sqrt(BCx * BCx + BCy * BCy)
        
        let p = AB + BC + AC
        
        let Ox = (BC * a.x + AC * b.x + AB * c.x) / p
        let Oy = (BC * a.y + AC * b.y + AB * c.y) / p
        
//        let r = sqrt((-BC + AC + AB) * (BC - AC + AB) * (BC + AC - AB) / (4 * p))
//        return Circle(center: Point(x: Ox, y: Oy), radius: r)
        return Point(x: Ox, y: Oy)
    }
    
    public func getCircles(intGeom: IntGeom) -> [Point] {
        let n = self.triangles.count
        var points = [Point]()
        points.reserveCapacity(n)
        
        for triangle in self.triangles {
            points.append(Circle(triangle: triangle, intGeom: intGeom).center)
        }

        return points
    }
    
    public func getInscribedCircles(intGeom: IntGeom) -> [Point] {
        let n = self.triangles.count
        var points = [Point]()
        points.reserveCapacity(n)
        
        for triangle in self.triangles {
            points.append(Delaunay.inscribedСircle(triangle: triangle, intGeom: intGeom))
        }

        return points
    }
    
    public func getVoronoy(intGeom: IntGeom) -> [[Point]] {
        let n = self.triangles.count
        var circles = [Circle]()
        circles.reserveCapacity(n)
        
        for triangle in self.triangles {
            circles.append(Circle(triangle: triangle, intGeom: intGeom))
        }

        var result = [[Point]]()
        
        for i in 0..<n {
            let circle = circles[i]
            let triangle = self.triangles
            
            
            
        }
        

        return result
    }

}

