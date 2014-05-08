//
//  HLBlendLayer.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-5.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "BlendLayer.h"
#import "HL3Sprite.h"
#import "HLSprite.h"

@implementation BlendLayer

- (void)dealloc{
    [super dealloc];
}

+ (HLScene*)scene{
    HLScene *scene = [HLScene scene];
	
	// 'layer' is an autorelease object.
	BlendLayer *layer = [BlendLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (id)node{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        HLSprite * spriteTest = [HLSprite spriteWithFile:@"Circle.png"];
        [self addChild:spriteTest];
        [spriteTest setPosition:CGPointMake(100, 100)];
        [spriteTest setScale:4.0];
    }
    return self;
}

- (void)draw{
    [super draw];
}


@end






