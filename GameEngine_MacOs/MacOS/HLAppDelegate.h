//
//  HLAppDelegate.h
//  GameEngine_MacOs
//
//  Created by huxiaozhou on 14-4-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HLGLView.h"

@interface HLAppDelegate : NSObject <NSApplicationDelegate>{

}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet HLGLView *glView;

@end
