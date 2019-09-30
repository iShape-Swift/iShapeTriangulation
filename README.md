# iShapeTriangulation
Complex polygon triangulation. A fast O(n*log(n)) algorithm based on "Triangulation of monotone polygons". The result can be represented as a Delaunay triangulation.
<p align="center">
<img src="https://github.com/NailxSharipov/iShapeTriangulation/blob/master/logo.svg" width="500">
</p>

## Features

💡 Fast O(n*log(n)) algorithm based on "Triangulation of monotone polygons"

💡 Supports polygons with holes

💡 Supports plain and Delaunay triangulation

---

## Basic Usage

Let's imagine you have a polygon shown on the picture below:

<img align="left" src="https://github.com/NailxSharipov/iShapeTriangulation/blob/master/vertices_ordering_rule_0.svg" width="500">

You should list your hull vertices in clockwise direction and your holes vertices in counterclockwise direction,
as shown on the picture below:


<img align="left" src="https://github.com/NailxSharipov/iShapeTriangulation/blob/master/vertices_ordering_rule_1.svg" width="500">

<img align="left" src="https://github.com/NailxSharipov/iShapeTriangulation/blob/master/vertices_ordering_rule_2.svg" width="500">

