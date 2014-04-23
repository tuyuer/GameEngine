//
//  HLParametricSurface.m
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLParametricSurface.h"
#import "TransformUtils.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"
#import "HLGLProgram.h"
#import "kazmath/GL/matrix.h"
#import "HLTypes.h"
#import "ccMacros.h"

@implementation HLParametricSurface


- (int)GetVertexCount{
    return _divisions.x * _divisions.y;;
}

- (int)GetLineIndexCount{
    return 4 * _slices.x * _slices.y;
}

- (int)GetTriangleIndexCount{
    return 6 * _slices.x * _slices.y;
}

- (void)GenerateVertices:(vector<float>&)vertices flags:(unsigned char)flags{
    int floatsPerVertex = 3;
    if (flags & VertexFlagsNormals)
        floatsPerVertex += 3;
    if (flags & VertexFlagsTexCoords)
        floatsPerVertex += 2;
    
    for (int j = 0; j < _divisions.y; j++) {
        for (int i = 0; i < _divisions.x; i++) {
            
            // Compute Position
            CGPoint domain = [self ComputeDomain:i y:j];
            HL3Vector range = [self Evaluate:domain];
            vertices.push_back(range.x);
            vertices.push_back(range.y);
            vertices.push_back(range.z);
            
            
            // Compute Normal
            if (flags & VertexFlagsNormals) {
                float s = i, t = j;
                
                // Nudge the point if the normal is indeterminate.
                if (i == 0) s += 0.01f;
                if (i == _divisions.x - 1) s -= 0.01f;
                if (j == 0) t += 0.01f;
                if (j == _divisions.y - 1) t -= 0.01f;
                
                // Compute the tangents and their cross product.
                HL3Vector p = [self Evaluate:[self ComputeDomain:s y:t]];
                
                HL3Vector u1 = [self Evaluate:[self ComputeDomain:s + 0.01f y:t]];
                HL3Vector u = hl3v(u1.x-p.x, u1.y-p.y, u1.z-p.z);
                
                HL3Vector v1 = [self Evaluate:[self ComputeDomain:s y:t + 0.01f]];
                HL3Vector v = hl3v(v1.x-p.x, v1.y-p.y, v1.z-p.z);
    
                HL3Vector normal = HL3VectorCross(u, v);
                normal = HL3VectorNormalize(normal);
                
                if ([self InvertNormal:domain])
                    normal = hl3v(-normal.x, -normal.y, -normal.z) ;
                
                vertices.push_back(normal.x);
                vertices.push_back(normal.y);
                vertices.push_back(normal.z);
            }
            
            // Compute Texture Coordinates
            if (flags & VertexFlagsTexCoords) {
                float s = _textureCount.x * i / _slices.x;
                float t = _textureCount.y * j / _slices.y;
                vertices.push_back(s);
                vertices.push_back(t);
            }
        }
    }

}

- (void)GenerateLineIndices:(vector<unsigned short>&)indices{
    vector<unsigned short>::iterator index = indices.begin();
    for (int j = 0, vertex = 0; j < _slices.y; j++) {
        for (int i = 0; i < _slices.x; i++) {
            int next = (i + 1) % (int)_divisions.x;
            *index++ = vertex + i;
            *index++ = vertex + next;
            *index++ = vertex + i;
            *index++ = vertex + i + _divisions.x;
        }
        vertex += _divisions.x;
    }
}

- (void)GenerateTriangleIndices:(vector<unsigned short>&)indices{
    vector<unsigned short>::iterator index = indices.begin();
    for (int j = 0, vertex = 0; j < _slices.y; j++) {
        for (int i = 0; i < _slices.x; i++) {
            int next = (i + 1) % (int)_divisions.x;
            *index++ = vertex + i;
            *index++ = vertex + next;
            *index++ = vertex + i + _divisions.x;
            *index++ = vertex + next;
            *index++ = vertex + next + _divisions.x;
            *index++ = vertex + i + _divisions.x;
        }
        vertex += _divisions.x;
    }
}


- (CGPoint)ComputeDomain:(float)x y:(float)y
{
    return CGPointMake(x * _upperBound.x / _slices.x, y * _upperBound.y / _slices.y);
}

- (BOOL)InvertNormal:(CGPoint)domain{
    return NO;
}

- (HL3Vector)Evaluate:(CGPoint)domain{
    return kHL3VectorZero;
}

- (void)SetInterval:(const ParametricInterval&)interval;
{
    _divisions = interval.Divisions;
    _upperBound = interval.UpperBound;
    _textureCount = interval.TextureCount;
    _slices = CGPointMake(_divisions.x-1, _divisions.y-1);
    
    //初始化绘图信息
    [self GenerateVertices:_surfaceVertices flags:0];
    _surfaceIndexCount = [self GetLineIndexCount];
    
    glGenBuffers(1, &vertexBuffer);
    
    _surfaceIndices.resize(_surfaceIndexCount);
    [self GenerateLineIndices:_surfaceIndices];
    glGenBuffers(1, &indexBuffer);

}

- (void)draw{
    [super draw];

    HLGLProgram * programShader = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_Position_uColor];
    int colorLocation_ = glGetUniformLocation([programShader program], "u_color");
    int pointSizeLocation_ = glGetUniformLocation([programShader program], "u_pointSize");
    
    [programShader use];
    [programShader setUniformsForBuiltins];
    
    static ccColor4F color_ = {1,0,0,1};
    static GLfloat pointSize_ = 1;
    
    [programShader setUniformLocation:colorLocation_ with4fv:(GLfloat*)&color_.r count:1];
    [programShader setUniformLocation:pointSizeLocation_ withF1:pointSize_];
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);

    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER,
                 _surfaceVertices.size() * sizeof(_surfaceVertices[0]),
                 &_surfaceVertices[0],
                 GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                 _surfaceIndexCount * sizeof(GLushort),
                 &_surfaceIndices[0],
                 GL_STATIC_DRAW);
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, 0);
    glDrawElements(GL_LINES, _surfaceIndexCount, GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    CHECK_GL_ERROR_DEBUG();
}

@end
















