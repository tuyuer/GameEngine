//
//  VBOTestObject.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "VBOTestObject.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"

@implementation VBOTestObject

- (void)dealloc{
    [super dealloc];
}

-(void)ensureCapacity:(NSUInteger)count
{
	if(_bufferCount + count > _bufferCapacity){
		_bufferCapacity += MAX(_bufferCapacity, count);
		_bufferVertex = (GLfloat*)realloc(_bufferVertex, _bufferCapacity*sizeof(GLfloat));
		_bufferColor = (GLfloat*)realloc(_bufferColor, _bufferCapacity*sizeof(GLfloat));
		NSLog(@"VBOTestObject :: Resized vertex buffer to %d", _bufferCapacity);
	}
}

- (id)init{
    if (self = [super init]) {
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
        [self ensureCapacity:1024];
 
        //vbo setup
        glGenBuffers(1, &_vboVertex);
        glBindBuffer(GL_ARRAY_BUFFER, _vboVertex);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*_bufferCapacity, _bufferVertex, GL_STREAM_DRAW);
        
        ccGLEnableVertexAttribs( kCCVertexAttrib_Position | kCCVertexAttrib_Color);
        glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, 0);
        
        
        glGenBuffers(1, &_vboColor);
        glBindBuffer(GL_ARRAY_BUFFER, _vboColor);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*_bufferCapacity, _bufferColor, GL_STREAM_DRAW);
        
        glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, 0);
        
        
        _bufferVertex[0] = -100;
        _bufferVertex[1] = -100;
        _bufferVertex[2] = 0;
        
        _bufferVertex[3] = 100;
        _bufferVertex[4] = -100;
        _bufferVertex[5] = 0;
        
        _bufferVertex[6] = -100;
        _bufferVertex[7] = 100;
        _bufferVertex[8] = 0;
        
        _bufferVertex[9] = 100;
        _bufferVertex[10] = 100;
        _bufferVertex[11] = 0;
        
        
        _bufferColor[0] = 1.0;
        _bufferColor[1] = 0;
        _bufferColor[2] = 0;
        _bufferColor[3] = 1.0;
        
        _bufferColor[4] = 1.0;
        _bufferColor[5] = 0;
        _bufferColor[6] = 0;
        _bufferColor[7] = 1.0;
        
        _bufferColor[8] = 1.0;
        _bufferColor[9] = 0;
        _bufferColor[10] = 0;
        _bufferColor[11] = 1.0;
        
        _bufferColor[12] = 1.0;
        _bufferColor[13] = 0;
        _bufferColor[14] = 0;
        _bufferColor[15] = 1.0;
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        _dirty = YES;
    }
    return self;
}

- (void)render{
    if (_dirty) {
        
        glBindBuffer(GL_ARRAY_BUFFER, _vboVertex);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*_bufferCapacity, _bufferVertex, GL_STREAM_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        glBindBuffer(GL_ARRAY_BUFFER, _vboColor);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*_bufferCapacity, _bufferColor, GL_STREAM_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        _dirty = NO;
    }
    
    //开始绘制
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


- (void)draw{
    
    NSAssert1(_shaderProgram, @"No shader program set for node: %@", self);
    
    ccGLBlendFunc(_blendFunc.src, _blendFunc.dst);
    
    [_shaderProgram use];
    [_shaderProgram setUniformsForBuiltins];

    [self render];
}



@end
