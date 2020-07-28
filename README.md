# iShapeTriangulation
Complex polygon triangulation, tessellation and split into convex polygons. A fast O(n*log(n)) algorithm based on "Triangulation of monotone polygons". The result can be represented as a Delaunay triangulation.
## Delaunay triangulation
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/star_triangle.svg" width="500"/>
</p>

## Breaking into convex polygons
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/star_polygon.svg" width="500" />
</p>

## Triangulation with extra points
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/eagle_triangles_extra_points.svg" width="800" />
</p>

## Tessellation
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/eagle_tessellation.svg" width="800" />
</p>

## Centroid net
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/eagle_centroid.svg" width="800" />
</p>

## Features

💡 Fast O(n*log(n)) algorithm based on "Triangulation of monotone polygons"

💡 All code is written to suit "Data Oriented Design". No reference type like class, just structs.

💡 Supports polygons with holes

💡 Supports plain and Delaunay triangulation

💡 Supports tesselation

💡 Supports breaking into convex polygons

💡 Supports building centroid net

💡 Same points is not restricted

💡 Polygon must not have self intersections

💡 Use integer geometry for calculations

💡 More then 100 tests

---

## Basic Usage

Let's imagine you have a polygon like one is shown below:

<p float="left">
  <img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/vertices_ordering_rule_0.svg" width="300"/>
  <img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/vertices_ordering_rule_1.svg" width="300"/>
</p>

You should list your hull vertices in clockwise direction and your holes vertices in counterclockwise direction

```swift

let shape = PlainShape(
  hull: [
    // hule vertices list in clockwise direction
    CGPoint(x: -5, y: 10),
    CGPoint(x: 5, y: 10),
    CGPoint(x: 10, y: 5),
    CGPoint(x: 10, y: -5),
    CGPoint(x: 5, y: -10),
    CGPoint(x: -5, y: -10),
    CGPoint(x: -10, y: -5),
    CGPoint(x: -10, y: 5),
  ],
  holes: [
    // holes vertices list in counterclockwise direction
    [
        CGPoint(x: -5, y: 0),
        CGPoint(x: 0, y: -5),
        CGPoint(x: 5, y: 0),
        CGPoint(x: 0, y: 5)
    ]
  ]
)
        
let delaunay = shape.delaunay()

let triangles = delaunay.trianglesIndices

for i in 0..<triangles.count / 3 {
    let ai = triangles[3 * i]
    let bi = triangles[3 * i + 1]
    let ci = triangles[3 * i + 2]
    print("triangle \(i): (\(ai), \(bi), \(ci))")
}

let polygons = delaunay.convexPolygonsIndices

var i = 0
var j = 0
while i < polygons.count {
    let n = polygons[i]
    var result = polygons[i + 1...i + n].reduce("", { $0 + "\($1), " })
    result.removeLast(2)
    print("polygon \(j): (\(result))")
    i += n + 1
    j += 1
}

```
After a triangulation you will get an array of indices. Where each triple are represent an indices of the triangle vertices. The indices are always listed in a clock wise direction.
<img align="left" src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/vertices_ordering_rule_2.svg" width="300"/>
```swift
triangle 0: (6, 7, 8)
triangle 1: (6, 8, 5)
triangle 2: (7, 0, 8)
triangle 3: (8, 0, 11)
triangle 4: (11, 0, 1)
triangle 5: (11, 1, 10)
triangle 6: (8, 9, 5)
triangle 7: (5, 9, 4)
triangle 8: (9, 10, 4)
triangle 9: (2, 10, 1)
triangle 10: (10, 3, 4)
triangle 11: (2, 3, 10)
```
and for polygons:
```swift
polygon 0: (6, 7, 8, 9, 4, 5)
polygon 1: (7, 0, 1, 11, 8)
polygon 2: (11, 1, 2, 3, 10)
polygon 3: (9, 10, 3, 4)
```
After a triangulation you will get an array of indices. Where each triple are represent an indices of the triangle vertices. The indices are always listed in a clock wise direction.

---

## Installation

### [CocoaPods](https://cocoapods.org/)

Add the following to your `Podfile`:
```ruby
pod 'iShapeTriangulation'
```
