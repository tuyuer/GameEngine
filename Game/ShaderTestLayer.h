//
//  GameLayer.h
//  GameEngine
//
//  Created by tuyuer on 14-4-10.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLLayer.h"
#import "HLScene.h"

@interface ShaderTestLayer : HLLayer{
    NSDate * beginTime;
}
+ (HLScene*)scene;
+ (id)node;
@end
