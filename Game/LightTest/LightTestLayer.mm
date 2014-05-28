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
        
        
        HLWireframeCone * cone = [HLWireframeCone coneWithHeight:5 radius:125];
        cone.bDisableDepthWhenDrawing = true;
        cone.bDisableTexture = true;
        [cone setPosition3D:hl3v(clipper.contentSize.width / 2, clipper.contentSize.height / 2, 0)];
        clipper.stencil = cone;
        
        
        HLWireframeCone * cone2 = [HLWireframeCone coneWithHeight:5 radius:125];
        [cone2 setPosition3D:hl3v(clipper.contentSize.width / 2, clipper.contentSize.height / 2, 0)];
        [cone2 setLight3D:globalLight];
        [clipper addChild:cone2];
        
        bottle = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        bottle.bClearDepthWhenDrawing = true;
        
        [bottle setLight3D:globalLight];
        [bottle setPosition3D:hl3v(clipper.contentSize.width/2, 30, 0)];
        [bottle setRotation3D:hl3v(180, 180, 0)];
        [clipper addChild:bottle];
        
        glBlendColor(0, 0, 0, 0.2);
        bottle.blendFunc = (ccBlendFunc){GL_ONE_MINUS_CONSTANT_ALPHA ,GL_DST_ALPHA};
        
        bottle2 = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        [bottle2 setLight3D:globalLight];
        [bottle2 setPosition3D:hl3v(160, 280, 0)];
        
        [self addChild:bottle2];
        [self schedule:@selector(doSomthing) interval:1.0/60.0];
        
        HLSprite * sprite1 = [HLSprite spriteWithFile:@"icon.png"];
        [self addChild:sprite1];
        
        HLMoveTo * moveTo = [HLMoveTo actionWithDuration:10 position:CGPointMake(160, 240)];
        HLMoveBy * moveBy = [HLMoveBy actionWithDuration:10 position:CGPointMake(-160, -240)];
        HLSequence * sequene = [HLSequence actionOne:moveTo two:moveBy];
//        [sprite1 runAction:sequene];
        
        HLScaleTo * scaleTo = [HLScaleTo actionWithDuration:4.0 scale:4.0];
//        [sprite1 runAction:scaleTo];
        
        HLScaleBy * scaleBy = [HLScaleBy actionWithDuration:4.0 scale:1.0];
        [sprite1 runAction:scaleBy];
        
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
