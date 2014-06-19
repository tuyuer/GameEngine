//
//  HLFBXObject.m
//  GameEngine
//
//  Created by huxiaozhou on 14-4-15.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLFBXObject.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"

@implementation HLFBXObject
@synthesize vertices = _vertices;
@synthesize colors = _colors;

- (void)dealloc{
    delete _vertices;
    delete _colors;
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {
        _vertices = new std::vector<HL3Vector>();
        _colors = new std::vector<HL3Vector4>();
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
    }
    return self;
}

- (void)draw{

    NSAssert1(_shaderProgram, @"No shader program set for node: %@", self);

    ccGLBlendFunc(_blendFunc.src, _blendFunc.dst);
    
    [_shaderProgram use];
    [_shaderProgram setUniformsForBuiltins];

    ccGLEnableVertexAttribs( kCCVertexAttrib_Position | kCCVertexAttrib_Color);
    
    
    GLfloat vertices[_vertices->size()*3];
    GLfloat colors[_colors->size()*4];
    
    for (int i = 0; i<_vertices->size(); i++) {
        HL3Vector vv = _vertices->at(i);
        vertices[i*3] = vv.x;
        vertices[i*3+1] = vv.y;
        vertices[i*3+2] = vv.z;
//        NSLog(@"vert = {%f,%f,%f}",vv.x,vv.y,vv.z);
    }
    
    for (int i = 0; i<_colors->size(); i++) {
        HL3Vector4 vv = _colors->at(i);
        colors[i*4] = vv.x;
        colors[i*4+1] = vv.y;
        colors[i*4+2] = vv.z;
        colors[i*4+3] = 1.0;
//        NSLog(@"color = {%f,%f,%f,%f}",vv.x,vv.y,vv.z,vv.w);
    }

    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, colors);

    glDrawArrays(GL_TRIANGLES , 0, _vertices->size());
}

@end














