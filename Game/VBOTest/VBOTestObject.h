//
//  VBOTestObject.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLNode.h"
#include <iostream>
#include <vector>
#import "HL3Foundation.h"

@interface VBOTestObject : HLNode{
    
    GLuint          _vboVertex;
    GLuint          _vboColor;
    NSUInteger      _bufferCapacity;
    GLsizei         _bufferCount;
    GLfloat         *_bufferVertex;
    GLfloat         *_bufferColor;
    BOOL            _dirty;

}

@end
