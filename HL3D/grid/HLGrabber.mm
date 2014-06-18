//
//  HLGrabber.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-27.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGrabber.h"

@implementation HLGrabber

- (void) dealloc{
    glDeleteFramebuffers(1, &_FBO);
    [super dealloc];
}

- (id) init{

    if (self = [super init]) {
        // generate FBO
        glGenFramebuffers(1, &_FBO);
    }
    return self;
}

-(void)logError:(GLenum)enumValue{
    switch (enumValue) {
        case GL_FRAMEBUFFER_UNSUPPORTED:
            NSLog(@"GL_FRAMEBUFFER_UNSUPPORTED");
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
            NSLog(@"GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
            NSLog(@"GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT");
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
            NSLog(@"GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS");
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_APPLE:
            NSLog(@"GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE_APPLE");
            break;
            
        default:
            break;
    }
}

-(void)grab:(HLTexture*)texture{
    
    // get old FBO
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_oldFBO);
    
    // bind
    GLuint depthBuffer;
    glGenRenderbuffers(1, &depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16,texture.width , texture.height);
 
    glBindFramebuffer(GL_FRAMEBUFFER, _FBO);
    
    // associate texture with FBO
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture.Name, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
    
    // check if it worked (probaly worth doing)
    GLuint status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        [NSException raise:@"Frame Grabber" format:@"Could not attach texture to framebuffer"];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, _oldFBO);
}


-(void)beforeRender:(HLTexture*)texture{
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_oldFBO);
    glBindFramebuffer(GL_FRAMEBUFFER, _FBO);
    
    // save clear color
    glGetFloatv(GL_COLOR_CLEAR_VALUE, _oldClearColor);
    
    glClearColor(0, 0, 0, 0);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
}

-(void)afterRender:(HLTexture*)texture{
    glBindFramebuffer(GL_FRAMEBUFFER, _oldFBO);
    
    // Restore clear color
    glClearColor(_oldClearColor[0], _oldClearColor[1], _oldClearColor[2], _oldClearColor[3]);
}

@end




















