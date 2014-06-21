//
//  VaoVboIndexBufferTestObject.m
//  GameEngine
//
//  Created by Tuyuer on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "VaoVboIndexBufferTestObject.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"
#import "HL3Vertex.h"
#import "HL3IndexTriangle.h"
#import "HLTypes.h"

@implementation VaoVboIndexBufferTestObject

- (void)dealloc{
    [_indexVBO release];
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {
        _indexVBO = [HL3IndexVBO indexVBO];
        [_indexVBO retain];
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
        
        HL3Vertex * v1 = [HL3Vertex vertexWithPosition:hl3v(-100, 100, 0)
                                                 color:HL3Vector4Make(1.0, 0, 0, 1.0)
                                              texCoord:CGPointMake(0, 0) normal:hl3v(0, 0, 0)];
        
        HL3Vertex * v2 = [HL3Vertex vertexWithPosition:hl3v(-100, -100, 0)
                                                 color:HL3Vector4Make(1.0, 0, 0, 1.0)
                                              texCoord:CGPointMake(0, 0) normal:hl3v(0, 0, 0)];
        
        HL3Vertex * v3 = [HL3Vertex vertexWithPosition:hl3v(100, -100, 0)
                                                 color:HL3Vector4Make(1.0, 0, 0, 1.0)
                                              texCoord:CGPointMake(0, 0) normal:hl3v(0, 0, 0)];
        
        NSArray * arrayVertexes = [NSArray arrayWithObjects:v1,v2,v3,nil];
        
        HL3IndexTriangle * indexTriangle = [HL3IndexTriangle indexTriangle];
        [indexTriangle setIndexes:0 two:1 three:2];
        
        
        
        
        
        
       
        
        
        [_indexVBO bindVAO];
        
        [_indexVBO bindVertexBuffer];
        [_indexVBO submitVertex:arrayVertexes usage:GL_STREAM_DRAW];
        
        glEnableVertexAttribArray(kCCVertexAttrib_Position);
        glEnableVertexAttribArray(kCCVertexAttrib_Color);
        
        NSInteger diff = offsetof( ccV3F_C4F_T2F_N3F, vertices);
        glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, sizeof(ccV3F_C4F_T2F_N3F), (void*)diff);
        
        diff = offsetof( ccV3F_C4F_T2F_N3F, colors);
        glVertexAttribPointer(kCCVertexAttrib_Color, 3, GL_FLOAT, GL_FALSE, sizeof(ccV3F_C4F_T2F_N3F), (void*)diff);
        
        [_indexVBO unBindVertexBuffer];
        [_indexVBO unBindVAO];
        
        [_indexVBO bindIndexBuffer];
        [_indexVBO submitIndex:[NSArray arrayWithObject:indexTriangle] usage:GL_STREAM_DRAW];
        [_indexVBO unBindIndexBuffer];
        
        _dirty = NO;
    }
    return self;
}

- (void)render{
    if (_dirty) {
        
        _dirty = NO;
    }
    [_indexVBO drawVBOData];
}

- (void)draw{
    NSAssert1(_shaderProgram, @"No shader program set for node: %@", self);
    
    ccGLBlendFunc(_blendFunc.src, _blendFunc.dst);
    
    [_shaderProgram use];
    [_shaderProgram setUniformsForBuiltins];
    
    [self render];
}

@end