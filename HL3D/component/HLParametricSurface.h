//
//  HLParametricSurface.h
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL3Node.h"
#import "HLSurface.h"
#import "HL3Foundation.h"

enum VertexFlags {
    VertexFlagsNormals = 1 << 0,
    VertexFlagsTexCoords = 1 << 1,
};

struct ParametricInterval {
    CGPoint Divisions;
    CGPoint UpperBound;
    CGPoint TextureCount;
};

@interface HLParametricSurface : HL3Node <HLSurface>{
    CGPoint _slices;
    CGPoint _divisions;
    
    CGPoint _upperBound;
    CGPoint _textureCount;
    
    //for drawing
    vector<float> _surfaceVertices;
    vector<GLushort> _surfaceIndices;
    int _surfaceVerticesCount;
    int _surfaceIndexCount;
    
    GLuint indexBuffer;
    GLuint vertexBuffer;
}

- (BOOL)InvertNormal:(CGPoint)domain;
- (HL3Vector)Evaluate:(CGPoint)domain;
- (void)SetInterval:(const ParametricInterval&)interval;
@end

















