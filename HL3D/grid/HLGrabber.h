//
//  HLGrabber.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-27.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface HLGrabber : NSObject{
    GLuint      _FBO;
    GLint       _oldFBO;
    GLfloat     _oldClearColor[4];
}

@end
