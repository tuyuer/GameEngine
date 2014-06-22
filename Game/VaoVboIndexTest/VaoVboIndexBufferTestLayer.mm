//
//  VaoVboIndexBufferTestLayer.m
//  GameEngine
//
//  Created by Tuyuer on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "VaoVboIndexBufferTestLayer.h"

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
#import "VBOTestObject.h"
#import "IndexBufferTestObject.h"
#import "VaoVboIndexBufferTestObject.h"

@implementation VaoVboIndexBufferTestLayer

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
	VaoVboIndexBufferTestLayer *layer = [VaoVboIndexBufferTestLayer node];
	
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
        VaoVboIndexBufferTestObject * ibto = [[[VaoVboIndexBufferTestObject alloc] init] autorelease];
        [self addChild:ibto];
        [ibto setPosition:CGPointMake(160, 240)];
        
        HLSprite * sprite = [HLSprite spriteWithFile:@"Marble.png"];
        [sprite setPosition:CGPointMake(160, 100)];
        [self addChild:sprite];
    }
    return self;
}


@end
