//
//  ThreeDSceneLayerTest.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "ThreeDSceneLayerTest.h"
#import "HLSprite.h"

@implementation ThreeDSceneLayerTest


+ (id)node{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        
        HLSprite * sprite = [HLSprite spriteWithFile:@"Marble.png"];
        [sprite setPosition:CGPointMake(160, 100)];
        [self addChild:sprite];
        
    }
    return self;
}

@end
