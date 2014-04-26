//
//  GameLayer.m
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "GameLayer.h"
#import "HLSprite.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"
#import "HLGLProgram.h"
#import "kazmath/GL/matrix.h"
#import "HL3Sprite.h"
#import "HLMD2Animation.h"

@implementation GameLayer

+ (HLScene*)scene{
    HLScene *scene = [HLScene scene];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (id)node{
    return [[[self alloc] init] autorelease];
}

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {

        HL3Sprite * spriteTerran = [HL3Sprite spriteWithFile:@"terran.md2"];
        [self addChild:spriteTerran];
        [spriteTerran setPosition3D:hl3v(240, 360, 0)];
        [spriteTerran setScale3D:hl3v(2, 2, 2)];
        [spriteTerran setRotation3D:hl3v(0, 40, 0)];
        
        HLMD2Animation * animation0 = [HLMD2Animation animationWith:0 endFrame:180 duration:15];
        [animation0 setBRepeat:true];
        [spriteTerran runMD2Action:animation0];
        

        HL3Sprite * spriteTerran2 = [HL3Sprite spriteWithFile:@"tris.md2"];
        [self addChild:spriteTerran2];
        [spriteTerran2 setPosition3D:hl3v(60, 360, -10)];
        [spriteTerran2 setScale3D:hl3v(4, 4, 4)];
        [spriteTerran2 setRotation3D:hl3v(0, 40, 0)];
        
        HLMD2Animation * animation1 = [HLMD2Animation animationWith:0 endFrame:180 duration:15];
        [animation1 setBRepeat:true];
        [spriteTerran2 runMD2Action:animation1];
        
//        HLWireframeMobiusStrip * bottle = [HLWireframeMobiusStrip MobiusStripWithScale:60];
//        HLWireframSphere * bottle = [HLWireframSphere sphereWithRadius:100];
        HLWireframeKleinBottle * bottle = [HLWireframeKleinBottle kleinBottleWithScale:8];
//        HLWireframeTrefoilKnot * bottle = [HLWireframeTrefoilKnot trefoilKnotWithScale:100];
        [self addChild:bottle];
        [bottle setPosition3D:hl3v(160, 100, -40)];
        [bottle setRotation3D:hl3v(0, 180, 00)];
        
        
        [[bottle light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[bottle light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[bottle light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[bottle light3D] setSpecular:HL3Vector4Make(0.5, 0.5, 0.5, 1.0)];
        [[bottle light3D] setShiness:50.0];
        
        
        HLWireframeTrefoilKnot * bottle2 = [HLWireframeTrefoilKnot trefoilKnotWithScale:100];
        [self addChild:bottle2];
        [bottle2 setPosition3D:hl3v(160, 300, -100)];
        
        
        [[bottle2 light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[bottle2 light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[bottle2 light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[bottle2 light3D] setSpecular:HL3Vector4Make(0.5, 0.5, 0.5, 1.0)];
        [[bottle2 light3D] setShiness:50.0];
        
        
        HLWireframSphere * bottle3 = [HLWireframSphere sphereWithRadius:40];
        [self addChild:bottle3];
        [bottle3 setPosition3D:hl3v(240, 160, -40)];
        
        
        [[bottle3 light3D] setPosition:hl3v(0.25, 0.25, 1)];
        [[bottle3 light3D] setDirection:hl3v(0, 0, 1.0)];
        
        [[bottle3 light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[bottle3 light3D] setSpecular:HL3Vector4Make(0.5, 0.5, 0.5, 1.0)];
        [[bottle3 light3D] setShiness:50.0];
    }
    return self;
}

@end

















