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
#import "HLDirector.h"
#import "HL3Light.h"

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
   
        
        bottle = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        [self addChild:bottle];
        [bottle setPosition3D:hl3v(160, 240, 0)];
        
        [[bottle light3D] setPosition3D:hl3v(0.25, 0.25, 1)];
        [[bottle light3D] setDirection:hl3v(0, 0, 1.0)];
         
        [[bottle light3D] setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [[bottle light3D] setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [[bottle light3D] setShiness:10];
        
        [self schedule:@selector(doSomthing) interval:1.0/60.0];
    }
    return self;
}

- (void)doSomthing{
    HL3Vector currentRot = [bottle rotation3D];
    [bottle setRotation3D:hl3v(currentRot.x, currentRot.y-0.2, currentRot.z)];
}
@end

















