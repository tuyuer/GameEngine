//
//  VBOTestObject.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

/**
 
VBO是Vertex Buffer Object, VAO是Vertex Array Object。 VAO是OpenGL 3.0以后才引入的新东西，但是在2.0版本中做为扩展接口。
VBO其实就是显卡中的显存，为了提高渲染速度，可以将要绘制的顶点数据缓存在显存中，这样就不需要将要绘制的顶点数据重复从CPU发送到GPU, 浪费带宽资源。
而VAO则是一个容器，可以包括多个VBO,  它类似于以前的call list, 由于它进一步将VBO容于其中，所以绘制效率将在VBO的基础上更进一步。

*/
#import "HLNode.h"
#include <iostream>
#include <vector>
#import "HL3Foundation.h"

@interface VBOTestObject : HLNode{
    
    GLuint          _vao;
    GLuint          _vboVertex;
    GLuint          _vboColor;
    NSUInteger      _bufferCapacity;
    GLsizei         _bufferCount;
    GLfloat         *_bufferVertex;
    GLfloat         *_bufferColor;
    BOOL            _dirty;

}

@end
