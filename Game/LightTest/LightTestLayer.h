//
//  LightTestLayer.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-27.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLLayer.h"
#import "HLScene.h"
#import "HLWireframeTrefoilKnot.h"

@interface LightTestLayer : HLLayer{
    HLWireframeTrefoilKnot * bottle ;
    HLWireframeTrefoilKnot * bottle2 ;
}

+ (HLScene*)scene;
+ (id)node;
@end
