//
//  ThreeDSceneTestScene.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "ThreeDSceneTestScene.h"
#import "HL3Camera.h"
#import "HL3Light.h"
#import "HLWireframeTrefoilKnot.h"

@implementation ThreeDSceneTestScene

+ (id)scene{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        
        //setup camera
        HL3Camera * camera = [HL3Camera camera];
        [camera setPosition3D:hl3v(160, 240, 0)];
        [self setActiveCamera:camera];
        
        HL3Light * globalLight = [HL3Light light];
        [globalLight retain];
        [globalLight setPosition3D:hl3v(0.25, 0.25, 1)];
        [globalLight setDirection:hl3v(0, 0, 1.0)];
        
        [globalLight setAmbient:HL3Vector4Make(0.04, 0.04, 0.04, 1.0)];
        [globalLight setSpecular:HL3Vector4Make(0.2, 0.2, 0.2, 1.0)];
        [globalLight setShiness:10];
        
        HLWireframeTrefoilKnot * bottle = [HLWireframeTrefoilKnot trefoilKnotWithScale:150];
        [self addChild:bottle];
        [bottle setPosition3D:hl3v(160, 240, 0)];
        
        [bottle setLight3D:globalLight];
    }
    return self;
}

@end
