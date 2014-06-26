//
//  HL3Layer.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Layer.h"
#import "HL3Scene.h"
#import "HLDirector.h"

@implementation HL3Layer
@synthesize hl3Scene = _hl3Scene;

- (void)dealloc{
    [_hl3Scene release];
    [super dealloc];
}

+ (id)layer{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        
        return self;
    }
    return nil;
}

- (void)visit{
    if (_hl3Scene) {
        [_hl3Scene visit];
    }
    [super visit];
}

- (void)setHl3Scene:(HL3Scene *)hl3Scene{
    if (_hl3Scene) {
        [_hl3Scene release];
    }
    _hl3Scene = [hl3Scene retain];
    _hl3Scene.hl3Layer = self;
}

-(void) updateViewport {
//    CGSize winSize = [[HLDirector sharedDirector] winSize];
//    CGRect gbb = [self glo]
}

/** Invoked from cocos2d when this layer is first displayed. Opens the 3D scene. */
-(void) onEnter {
	[super onEnter];
	[self onOpenCC3Layer];
	[self openCC3Scene];
}

-(void) onOpenCC3Layer {

}

/** Invoked automatically either from onEnter, or if new scene attached and layer is running. */
-(void) openCC3Scene {
	[self updateViewport];			// Set the camera viewport
	[_hl3Scene open];				// Open the scene
}


@end






