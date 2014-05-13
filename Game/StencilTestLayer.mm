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
#import "HLWireframeCone.h"



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
        
        bottle = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        [self addChild:bottle];
        [bottle setPosition3D:hl3v(160, 240, 0)];
        
        [[bottle light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[bottle light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[bottle light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[bottle light3D] setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [[bottle light3D] setShiness:10];
        
        [self schedule:@selector(doSomthing) interval:1.0/60.0];
        
        

        HLClippingNode * clipper = [HLClippingNode clippingNode];
        clipper.tag = kTagClipperNode;
        clipper.contentSize = CGSizeMake(200, 200);
        clipper.anchorPoint = ccp(0.5, 0.5);
        clipper.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:clipper];
        
        HLDrawNode *stencil = [HLDrawNode node];
        
        CGPoint circle[360];
        for (int i=0; i<360; i++) {
            circle[i].x = clipper.contentSize.width/2 + 100 * cos(CC_DEGREES_TO_RADIANS(i*1.0));
            circle[i].y = clipper.contentSize.height/2 + 100 * sin(CC_DEGREES_TO_RADIANS(i*1.0));
        }
        
        ccColor4F white = {1, 1, 1, 1};
        [stencil drawPolyWithVerts:circle count:360 fillColor:white borderWidth:1 borderColor:white];
        clipper.stencil = stencil;
  
        HLSprite *content = [HLSprite spriteWithFile:@"Tarsier.png"];
        content.tag = kTagContentNode;
        content.anchorPoint = ccp(0.5, 0.5);
        content.position = ccp(clipper.contentSize.width / 2, clipper.contentSize.height / 2);
        [clipper addChild:content];
        
        
        HLWireframeCone * cone = [HLWireframeCone coneWithHeight:5 radius:125];
        [self addChild:cone];
        [cone setPosition3D:hl3v(160, 80, 0)];
        
        [[cone light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[cone light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[cone light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[cone light3D] setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [[cone light3D] setShiness:10];
    }
    return self;
}

- (void)doSomthing{
    HL3Vector currentRot = [bottle rotation3D];
    [bottle setRotation3D:hl3v(currentRot.x, currentRot.y-0.2, currentRot.z)];
}

@end


