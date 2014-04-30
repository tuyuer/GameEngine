//
//  HLGLView.m
//  GameEngine
//
//  Created by huxiaozhou on 14-4-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGLView.h"

@implementation HLGLView

- (id) initWithFrame:(NSRect)frameRect shareContext:(NSOpenGLContext*)context
{
    NSOpenGLPixelFormatAttribute attribs[] =
    {
        //		NSOpenGLPFAAccelerated,
        //		NSOpenGLPFANoRecovery,
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
        
#if 0
		// Must specify the 3.2 Core Profile to use OpenGL 3.2
		NSOpenGLPFAOpenGLProfile,
		NSOpenGLProfileVersion3_2Core,
#endif
        
		0
    };
    
	NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
    
	if (!pixelFormat)
		NSLog(@"No OpenGL pixel format");
    
	if( (self = [super initWithFrame:frameRect pixelFormat:[pixelFormat autorelease]]) ) {
        
		if( context )
			[self setOpenGLContext:context];
	}
    
	return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
