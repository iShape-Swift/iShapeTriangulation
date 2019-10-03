//
//  PlainShape+Test.swift
//  iGeometry
//
//  Created by Nail Sharipov on 03/10/2019.
//

#if iShapeTest

import iGeometry

struct DebugShape {
    let points: [IntPoint]
    let data: [String]
}

extension PlainShape.MonotoneLayout {

    var shapes: [DebugShape] {
        var shapes = Array<DebugShape>()
        for index in self.indices {
            
            var next = self.links[index]
            
            var points = Array<IntPoint>()
            var data = Array<String>()
            repeat {
                points.append(next.vertex.point)
                data.append(String(next.vertex.index))
                next = self.links[next.next]
            } while next.this != index

            shapes.append(DebugShape(points: points, data: data))
        }
        
        return shapes
    }

}

extension PlainShape {
    
    var pathes: [[Vertex]] {
        get {
            let navigator = self.navigator
            let links = navigator.links
            
            var pathes = [[Vertex]]()
            pathes.reserveCapacity(self.layouts.count)
            
            for split in self.layouts {
                var vertices = [Vertex]()
                vertices.reserveCapacity(navigator.iPoints.count)
                var next = links[split.begin]
                repeat {
                    vertices.append(next.vertex)
                    next = links[next.next]
                } while next.this != split.begin
                
                pathes.append(vertices)
            }
            
            return pathes
        }
    }
}

#endif
