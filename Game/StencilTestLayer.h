//
//  StencilTestLayer.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLLayer.h"
#import "HLScene.h"
#import "HLWireframeTrefoilKnot.h"

@interface StencilTestLayer : HLLayer{
    HLWireframeTrefoilKnot * bottle ;
}
+ (HLScene*)scene;
+ (id)node;
@end
