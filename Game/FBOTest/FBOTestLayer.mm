//
//  FBOTestLayer.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-6.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "FBOTestLayer.h"
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
#import "HLWave3D.h"

@implementation FBOTestLayer

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
	FBOTestLayer *layer = [FBOTestLayer node];
	
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
        
        HLWave3D * c5= [HLWave3D actionWithDuration:100 size:CGSizeMake(40,40) waves:100 amplitude:10];
        
        HLSprite * spriteTest = [HLSprite spriteWithFile:@"Tarsier.png"];
        [self addChild:spriteTest];
        [spriteTest setPosition:CGPointMake(160, 240)];
        [spriteTest runAction:c5];
        
    }
    return self;
}

- (void)draw{
    [super draw];
}

- (void)doSomthing{
    HL3Vector currentRot1 = [bottle rotation3D];
    [bottle setRotation3D:hl3v(currentRot1.x, currentRot1.y +0.2, currentRot1.z)];
    [bottle2 setRotation3D:hl3v(currentRot1.x, currentRot1.y -0.2, currentRot1.z)];
}
@end
