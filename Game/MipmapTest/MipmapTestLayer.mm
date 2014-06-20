//
//  MipmapTestLayer.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "MipmapTestLayer.h"
#import "HLSprite.h"
#import "HLDrawNode.h"
#import "HLDirector.h"
#import "HLClippingNode.h"
#import "HL3ClippingNode.h"
#import "HLWireframeCone.h"
#import "HLMoveBy.h"
#import "HL3Light.h"
#import "HL3Node.h"
#import "HLMoveTo.h"
#import "HLSequence.h"
#import "HLScaleTo.h"
#import "HLScaleBy.h"
#import "HLFlipX3D.h"
#import "HLWave3D.h"
#import "HLFBXManager.h"
#import "HLFBXObject.h"

@implementation MipmapTestLayer

enum {
	kTagTitleLabel = 1,
	kTagSubtitleLabel = 2,
	kTagStencilNode = 100,
	kTagClipperNode = 101,
	kTagContentNode = 102,
};

- (void)dealloc{
    [super dealloc];
}


+ (HLScene*)scene{
    HLScene *scene = [HLScene scene];
	
	// 'layer' is an autorelease object.
	MipmapTestLayer *layer = [MipmapTestLayer node];
	
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
              
        
        HLTexture *texture0 = [[HLTextureCache sharedTextureCache] addImage:@"Marble.png"];
        [texture0 generateMipmap];
        [texture0 setAliasTexParameters];
        
        HLTexture *texture1 = [[HLTextureCache sharedTextureCache] addImage:@"Marble_nomipmap.png"];
        [texture1 setAliasTexParameters];
        
        HLSprite * sprite1 = [[HLSprite alloc] initWithTexture:texture0 rect:CGRectMake(0, 0, 128, 128)];
        [self addChild:sprite1];
        [sprite1 setPosition:CGPointMake(64, 240)];
        
        HLSprite * sprite2 = [[HLSprite alloc] initWithTexture:texture1 rect:CGRectMake(0, 0, 128, 128)];
        [self addChild:sprite2];
        [sprite2 setPosition:CGPointMake(320-64, 240)];
        
        [sprite1 runAction:[HLScaleTo actionWithDuration:40 scale:0]];
        [sprite2 runAction:[HLScaleTo actionWithDuration:40 scale:0]];
    }
    return self;
}

- (void)draw{
    [super draw];
}

@end
