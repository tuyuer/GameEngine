//
//  HLEGLView.m
//  GameEngine
//
//  Created by tuyuer on 14-3-24.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLEGLView.h"
#import "kazmath/GL/matrix.h"
#import "kazmath.h"
#import <QuartzCore/QuartzCore.h>

@implementation HLEGLView
@synthesize esContext = _esContext;

+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //set up layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opacity=YES;
        
        _pixelformat = kEAGLColorFormatRGB565;
        _depthFormat = GL_DEPTH_COMPONENT24_OES; // GL_DEPTH_COMPONENT24_OES;
        _size = [eaglLayer bounds].size;
        
        //set up context
        _esContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:_esContext];
        
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                        _pixelformat, kEAGLDrawablePropertyColorFormat, nil];
        
        //set up render buffer
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        //为Render Buffer 分配空间
        if (![_esContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer]) {
            NSLog(@"failed to call context");
        }
        
        if (_depthFormat) {
            if (!depthBuffer) {
                //创建深度缓冲
                glGenBuffers(1, &depthBuffer);
                NSAssert(depthBuffer, @"can not create depthBuffer...");
            }
            //绑定深度缓冲
            glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
            glRenderbufferStorage(GL_RENDERBUFFER, depthBuffer,backingWidth, backingHeight);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
        }
        
        //set up frame buffer
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        
        //开启深度
        glEnable(GL_DEPTH_TEST);
        
        //EGLView Frame size
        _size=CGSizeMake(frame.size.width,frame.size.height);
        
    }
    return self;
}


- (void)swapBuffers{
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
	[_esContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
