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

## Important Update: Check Out My New Library!

I'm excited to introduce [iTriangle](https://github.com/iShape-Swift/iTriangle), the latest evolution of this project. Not only does it retain most of the fantastic features of iShapeTriangulation, but it also brings significant improvements, including better support for self-intersection cases. Additionally, it offers more precise adherence to the Delaunay condition. I'll be dedicating my future efforts to this new library, so I highly recommend trying it out for the most up-to-date features and enhancements. Your feedback is always appreciated!


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

Add import:
```swift
import iGeometry
import iShapeTriangulation
```

After that you need represent your polygon as an array of vertices listed in a clockwise direction. Let's have a look for an example of a cheese polygon.
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/cheese_example_0.svg" width="600"/>
</p>

```swift
    let path = [
        // vertices listed in clockwise direction
        Point(x: 0, y: 20),       // 0
        Point(x: 8, y: 10),       // 1
        Point(x: 7, y: 6),        // 2
        Point(x: 9, y: 1),        // 3
        Point(x: 13, y: -1),      // 4
        Point(x: 17, y: 1),       // 5
        Point(x: 26, y: -7),      // 6
        Point(x: 14, y: -15),     // 7
        Point(x: 0, y: -18),      // 8
        Point(x: -14, y: -15),    // 9
        Point(x: -25, y: -7),     // 10
        Point(x: -18, y: 0),      // 11
        Point(x: -16, y: -3),     // 12
        Point(x: -13, y: -4),     // 13
        Point(x: -8, y: -2),      // 14
        Point(x: -6, y: 2),       // 15
        Point(x: -7, y: 6),       // 16
        Point(x: -10, y: 8)       // 17
    ]
```
Then get an instance of a Triangulator class and triangulate your polygon. As the result you will get an array of indices on your vertices array. Where each triple are represent an indices of a triangle vertices.

```swift
    let triangulator = Triangulator()
    if let triangles = try? triangulator.triangulateDelaunay(points: path) {
        for i in 0..<triangles.count / 3 {
            let ai = triangles[3 * i]
            let bi = triangles[3 * i + 1]
            let ci = triangles[3 * i + 2]
            print("triangle \(i): (\(ai), \(bi), \(ci))")
        }
    }
```
The triple are always list vertices in a clock wise direction.
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/cheese_example_1.svg" width="600"/>
</p>

Lets look another example for a polygon with a hole.
Now you need represent a hole as an array of vertices listed in counterclockwise direction
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/cheese_example_2.svg" width="600"/>
</p>

```swift
    let hole = [
        // vertices listed in counterclockwise direction
        Point(x: 2, y: 0),    // 18
        Point(x: -2, y: -2),  // 19
        Point(x: -4, y: -5),  // 20
        Point(x: -2, y: -9),  // 21
        Point(x: 2, y: -11),  // 22
        Point(x: 5, y: -9),   // 23
        Point(x: 7, y: -5),   // 24
        Point(x: 5, y: -2)    // 25
    ]
    
    let points = path + hole
    if let triangles = try? triangulator.triangulateDelaunay(points: points, hull: points[0..<path.count], holes: [points[path.count..<points.count]], extraPoints: nil) {
        for i in 0..<triangles.count / 3 {
            let ai = triangles[3 * i]
            let bi = triangles[3 * i + 1]
            let ci = triangles[3 * i + 2]
            print("triangle \(i): (\(ai), \(bi), \(ci))")
        }
    }
```
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/cheese_example_3.svg" width="600"/>
</p>
---

## Installation

add imports:
```swift
import iGeometry
import iShapeTriangulation
```
### [CocoaPods](https://cocoapods.org/)

Add the following to your `Podfile`:
```ruby
pod 'iShapeTriangulation'
```

### [Cartage](https://github.com/Carthage/Carthage)

Add the following to your `Cartfile`:
```
github "iShape-Swift/iShapeTriangulation"
```

### [Package Manager](https://swift.org/package-manager/)


Add the following to your `Package.swift`:
```swift
let package = Package(
    name: "[your name]",
    products: [
        dependencies: [
            .package(url: "https://github.com/iShape-Swift/iShapeTriangulation", from: "1.0.2")
        ],
        targets: [
            .target(
                name: "[your target]",
                dependencies: ["iShapeTriangulation"])
        ]
    ]
)
```
Or add it directly throw .xcodeproj
<p align="center">
<img src="https://github.com/iShape-Swift/iShapeTriangulation/blob/master/Readme/SwiftPackageManager_tip.png" width="600"/>
</p>

