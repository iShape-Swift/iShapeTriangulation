# iShapeTriangulation
Complex polygon triangulation. A fast O(n*log(n)) algorithm based on "Triangulation of monotone polygons". The result can be represented as a Delaunay triangulation.
## Delaunay triangulation
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/star_triangle.svg" width="500"/>
</p>

## Breaking into polygons
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/star_polygon.svg" width="500" />
</p>

## Triangulation with extra points
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/eagle_triangles_extra_points.svg" width="800" />
</p>

## Features

💡 Fast O(n*log(n)) algorithm based on "Triangulation of monotone polygons"

💡 All code is written to suit "Data Oriented Design". No reference type like class, just structs.

💡 Supports polygons with holes

💡 Supports plain and Delaunay triangulation

💡 Supports breaking into convex polygons

💡 Same points is not restricted

💡 Polygon must not have self intersections

💡 Use integer geometry for calculations

---

## Basic Usage

Let's imagine you have a polygon like one is shown below:

<img align="center" src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/vertices_ordering_rule_0.svg" width="500">

You should list your hull vertices in clockwise direction and your holes vertices in counterclockwise direction

```swift
let points: [CGPoint] = [

  // hule vertices list in clockwise direction
  CGPoint(x: -5, y: 10),
  CGPoint(x: 5, y: 10),
  CGPoint(x: 10, y: 5),
  CGPoint(x: 10, y: -5),
  CGPoint(x: 5, y: -10),
  CGPoint(x: -5, y: -10),
  CGPoint(x: -10, y: -5),
  CGPoint(x: -10, y: 5),
            
  // holes vertices list in counterclockwise direction
  CGPoint(x: -5, y: 0),
  CGPoint(x: 0, y: -5),
  CGPoint(x: 5, y: 0),
  CGPoint(x: 0, y: 5)
]

let hule = points[0...7]
let hole = points[8...11]
        
let triangles: [Int] = Triangulator().triangulateDelaunay(points: points, hull: hule, holes: [hole])

```

<img align="center" src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/vertices_ordering_rule_1.svg" width="500">

After a triangulation you will get an array of indices. Where each triple are represent an indices of the triangle vertices. The indices are always listed in a clock wise direction.
<img align="center" src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/vertices_ordering_rule_2.svg" width="500">

---

## Installation

### [CocoaPods](https://cocoapods.org/)

Add the following to your `Podfile`:
```ruby
pod 'iShapeTriangulation'
```
