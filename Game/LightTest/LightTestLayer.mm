//
//  LightTestLayer.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-27.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "LightTestLayer.h"
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

@implementation LightTestLayer

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
	LightTestLayer *layer = [LightTestLayer node];
	
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
        
        HLClippingNode * clipper = [HL3ClippingNode clippingNode];
        clipper.tag = kTagClipperNode;
        clipper.contentSize = CGSizeMake(200, 200);
        clipper.anchorPoint = ccp(0.5, 0.5);
        clipper.position = ccp(self.contentSize.width / 2, 80);
        [self addChild:clipper];
        
        HL3Light * globalLight = [HL3Light light];
        [globalLight retain];
        [globalLight setPosition:hl3v(0.25, 0.25, 1)];
        [globalLight setDirection:hl3v(0, 0, 1.0)];
        
        [globalLight setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [globalLight setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [globalLight setShiness:10];
        
        
        bottle = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        bottle.bClearDepthWhenDrawing = true;
        
        [bottle setLight3D:globalLight];
        [bottle setPosition3D:hl3v(160, 240, 0)];
        [bottle setRotation3D:hl3v(180, 180, 0)];
        [self addChild:bottle];
        [self schedule:@selector(doSomthing) interval:1.0/60.0];
        
        
        
        HLWave3D * waves= [HLWave3D actionWithDuration:100 size:CGSizeMake(40,40) waves:100 amplitude:10];
        
        HLSprite * spriteTest = [HLSprite spriteWithFile:@"Tarsier.png"];
        [self addChild:spriteTest];
        [spriteTest setPosition:CGPointMake(160, 240)];
//        [spriteTest runAction:waves];
        
        [self runAction:waves];
    }
    return self;
}

- (void)draw{
    [super draw];
}

- (void)doSomthing{
    HL3Vector currentRot1 = [bottle rotation3D];
    [bottle setRotation3D:hl3v(currentRot1.x, currentRot1.y +0.2, currentRot1.z)];
//    [bottle2 setRotation3D:hl3v(currentRot1.x, currentRot1.y -0.2, currentRot1.z)];
}

@end
