//
//  HLBlendLayer.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-5.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

//blendFunc = (ccBlendFunc){GL_DST_COLOR,GL_ZERO}
//
//=( Scolor.R*Dcolor.R,Scolor.G* Dcolor.G, Scolor.B*Dcolor.B, Scolor.A*Dcolor.A) +(Dcolor.R* 0, Dcolor.G*0,Dcolor.B* 0, Dcolor.A*0)
//
//
//
//
//blendFunc = (ccBlendFunc){GL_ZERO ,GL_SRC_COLOR}
//
//=( Scolor.R*0, Scolor.G* 0, Scolor.B*0, Scolor.A*0)+( Dcolor.R*Scolor.R, Dcolor.G*Scolor.G, Dcolor.B*Scolor.B,  Dcolor.A*Scolor.A)


#import "BlendLayer.h"
#import "HL3Sprite.h"
#import "HLSprite.h"

@implementation BlendLayer

- (void)dealloc{
    [super dealloc];
}

+ (HLScene*)scene{
    HLScene *scene = [HLScene scene];
	
	// 'layer' is an autorelease object.
	BlendLayer *layer = [BlendLayer node];
	
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
        HLSprite * spriteBack = [HLSprite spriteWithFile:@"blend_dst.png"];
        [self addChild:spriteBack];
        [spriteBack setPosition:CGPointMake(160, 240)];
        
        HLSprite * spriteSrc = [HLSprite spriteWithFile:@"blend_src.png"];
        [self addChild:spriteSrc];
        [spriteSrc setPosition:CGPointMake(160, 240)];

        spriteSrc.blendFunc = (ccBlendFunc){GL_SRC_ALPHA ,GL_ONE};
    }
    return self;
}

- (void)draw{
    [super draw];
}


@end






