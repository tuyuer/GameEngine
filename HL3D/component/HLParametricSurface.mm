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

- (id)init{
    if (self = [super init]) {
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionColorLight];
    
        _uniformHandles.u_lightDirection = [_shaderProgram uniformLocationForName:@"u_lightDirection"];
        _uniformHandles.u_lightPosition = [_shaderProgram uniformLocationForName:@"u_lightPosition"];
        _uniformHandles.u_lightAmbient = [_shaderProgram uniformLocationForName:@"u_lightAmbient"];
        _uniformHandles.u_lightDiffuse = [_shaderProgram uniformLocationForName:@"u_lightDiffuse"];
        _uniformHandles.u_lightSpecular = [_shaderProgram uniformLocationForName:@"u_lightSpecular"];
        _uniformHandles.u_lightShiness = [_shaderProgram uniformLocationForName:@"u_lightShiness"];
        _uniformHandles.u_normalMatrix = [_shaderProgram uniformLocationForName:@"u_normalMatrix"];
    }
    return self;
}

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
                
//                NSLog(@"normal(%d,%d) = {%f,%f,%f}",i,j,normal.x,normal.y,normal.z);
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
    [self GenerateVertices:_surfaceVertices flags:VertexFlagsNormals];
    _surfaceIndexCount = [self GetTriangleIndexCount];
    
    glGenBuffers(1, &vertexBuffer);
    
    _surfaceIndices.resize(_surfaceIndexCount);
    [self GenerateTriangleIndices:_surfaceIndices];
    
    glGenBuffers(1, &indexBuffer);
}

- (void)draw{
    
    NSAssert1(_shaderProgram, @"No shader program set for node: %@", self);
    [_shaderProgram use];
	[_shaderProgram setUniformsForBuiltins];
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttrib_Normal);

    //设置光照信息
    HL3Vector v4LightPos = [_light3D position];
    HL3Vector v4LightDir = [_light3D direction];
    
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightPosition with3fv:&v4LightPos.x count:1];
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightDirection with3fv:&v4LightDir.x count:1];
    
    
    HL3Vector4 v4LightAmbient = [_light3D ambient];
    HL3Vector4 v4LightDiffuse = [_light3D diffuse];
    HL3Vector4 v4LightSpecular = [_light3D specular];
    
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightAmbient with3fv:&v4LightAmbient.x count:1];
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightDiffuse with3fv:&v4LightDiffuse.x count:1];
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightSpecular with3fv:&v4LightSpecular.x count:1];

    [_shaderProgram setUniformLocation:_uniformHandles.u_lightShiness withF1:[_light3D shiness]];
   
    kmMat3 matNormal;
    kmMat3Identity(&matNormal);
    
    kmMat4 matMVP ;
    kmMat4Identity(&matMVP);
    kmMat4Fill(&matMVP, _transform3D.getArray());
    
    kmMat4ExtractRotation(&matNormal, &matMVP);
    
//    NSLog(@"{%f,%f,%f,%f,%f,%f,%f,%f,%f}",mat3[0],mat3[1],mat3[2],mat3[3],mat3[4],mat3[5],mat3[6],mat3[7],mat3[8]);
    
    [_shaderProgram setUniformLocation:_uniformHandles.u_normalMatrix withMatrix3fv:matNormal.mat count:1];
    
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
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*6, 0);
    glVertexAttribPointer(kCCVertexAttrib_Normal, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*6,  (const GLvoid*)(sizeof(GLfloat)*3));
    
    glDrawElements(GL_TRIANGLES, _surfaceIndexCount, GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    CHECK_GL_ERROR_DEBUG();
}

@end
















