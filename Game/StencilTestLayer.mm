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

@implementation StencilTestLayer

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
        
        HLDrawNode * drawNode = [HLDrawNode node];
        [drawNode drawDot:CGPointMake(100, 100) radius:10 color:(ccColor4F){1.0,0,0,1.0}];
        [self addChild:drawNode];
        
        // Draw polygons
        CGSize s = [[HLDirector sharedDirector] winSize];
		CGPoint points[] = { {s.height/4,0}, {s.width,s.height/5}, {s.width/3*2,s.height} };
		[drawNode drawPolyWithVerts:points count:sizeof(points)/sizeof(points[0]) fillColor:ccc4f(1,0,0,0.5) borderWidth:4 borderColor:ccc4f(0,0,1,1)];
        
        [drawNode drawSegmentFrom:ccp(20,s.height) to:ccp(20,s.height/2) radius:10 color:ccc4f(0, 1, 0, 1)];
        
		[drawNode drawSegmentFrom:ccp(10,s.height/2) to:ccp(s.width/2, s.height/2) radius:40 color:ccc4f(1, 0, 1, 0.5)];
        
        [self schedule:@selector(doSomthing) interval:1.0/60.0];
    }
    return self;
}

- (void)doSomthing{
    HL3Vector currentRot = [bottle rotation3D];
    [bottle setRotation3D:hl3v(currentRot.x, currentRot.y-0.2, currentRot.z)];
}

@end


