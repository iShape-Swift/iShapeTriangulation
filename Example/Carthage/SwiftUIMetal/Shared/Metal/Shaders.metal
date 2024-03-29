//
//  Shaders.metal
//  SwiftUIMetal
//
//  Created by Nail Sharipov on 05.01.2022.
//

#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;


struct VertexOut {
    vector_float4 position [[position]];
};

vertex VertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]]) {
    vector_float2 v = vertexArray[vid];

    VertexOut output;
    output.position = vector_float4(v.x, v.y, 0, 1);
    
    return output;
}

fragment float4 fragmentShader(VertexOut interpolated [[stage_in]]) {
    return vector_float4(1, 0, 0, 1);
}
