//
//  FBOTestLayer.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-6.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLLayer.h"
#import "HLScene.h"
#import "HLWireframeTrefoilKnot.h"

@interface FBOTestLayer : HLLayer{
    HLWireframeTrefoilKnot * bottle ;
    HLWireframeTrefoilKnot * bottle2 ;
}

+ (HLScene*)scene;
+ (id)node;
@end
