//
//  HLEGLView.h
//  GameEngine
//
//  Created by tuyuer on 14-3-24.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface HLEGLView : UIView{
    
    EAGLContext * _esContext;
    
    NSString  * _pixelformat;
    GLuint _depthFormat;
    CGSize _size;
    
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthBuffer;
    
    //backing size
    GLint backingWidth;
    GLint backingHeight;
}
@property (nonatomic,readonly) EAGLContext * esContext;

- (void)swapBuffers;

@end
