//
//  StencilTestLayer.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "StencilTestLayer.h"
#import "HLSprite.h"
#import "HLDrawNode.h"
#import "HLDirector.h"
#import "HLClippingNode.h"
#import "HL3ClippingNode.h"
#import "HLWireframeCone.h"
#import "HLMoveBy.h"



@implementation StencilTestLayer

enum {
	kTagTitleLabel = 1,
	kTagSubtitleLabel = 2,
	kTagStencilNode = 100,
	kTagClipperNode = 101,
	kTagContentNode = 102,
};

+ (HLScene*)scene{
    HLScene *scene = [HLScene scene];
	
	// 'layer' is an autorelease object.
	StencilTestLayer *layer = [StencilTestLayer node];
	
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
  
        
        HLWireframeCone * cone = [HLWireframeCone coneWithHeight:5 radius:125];
        cone.bDisableDepthWhenDrawing = true;
        cone.bDisableTexture = true;
        [cone setPosition3D:hl3v(clipper.contentSize.width / 2, clipper.contentSize.height / 2, 0)];
        
        [[cone light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[cone light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[cone light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[cone light3D] setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [[cone light3D] setShiness:10];
        
        clipper.stencil = cone;
        
        
        HLWireframeCone * cone2 = [HLWireframeCone coneWithHeight:5 radius:125];
        [cone2 setPosition3D:hl3v(clipper.contentSize.width / 2, clipper.contentSize.height / 2, 0)];
        
        [[cone2 light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[cone2 light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[cone2 light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[cone2 light3D] setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [[cone2 light3D] setShiness:10];
        [clipper addChild:cone2];
        
        bottle = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        bottle.bClearDepthWhenDrawing = true;
        [[bottle light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[bottle light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[bottle light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[bottle light3D] setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [[bottle light3D] setShiness:10];
        [bottle setPosition3D:hl3v(clipper.contentSize.width/2, 30, 0)];
        [bottle setRotation3D:hl3v(180, 180, 0)];
        [clipper addChild:bottle];
        
        glBlendColor(0.8, 0.8, 0.8, 0.2);
        bottle.blendFunc = (ccBlendFunc){GL_ONE_MINUS_CONSTANT_ALPHA ,GL_DST_ALPHA};
        
        bottle2 = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        [[bottle2 light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[bottle2 light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[bottle2 light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[bottle2 light3D] setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [[bottle2 light3D] setShiness:10];
        [bottle2 setPosition3D:hl3v(160, 280, 0)];
        
        [self addChild:bottle2];
        
        [self schedule:@selector(doSomthing) interval:1.0/60.0];
        
        
        HLSprite * sprite1 = [HLSprite spriteWithFile:@"icon.png"];
        [self addChild:sprite1];
        
        HLMoveBy * moveBy = [HLMoveBy actionWithDuration:10 position:CGPointMake(320, 480)];
        [sprite1 runAction:moveBy];

    }
    return self;
}

- (void)doSomthing{
    HL3Vector currentRot1 = [bottle rotation3D];
    [bottle setRotation3D:hl3v(currentRot1.x, currentRot1.y +0.2, currentRot1.z)];
    [bottle2 setRotation3D:hl3v(currentRot1.x, currentRot1.y -0.2, currentRot1.z)];
}

@end


