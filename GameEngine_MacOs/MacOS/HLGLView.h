//
//  HLGLView.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HLGLView : NSOpenGLView{

}

- (id) initWithFrame:(NSRect)frameRect shareContext:(NSOpenGLContext*)context;

@end
