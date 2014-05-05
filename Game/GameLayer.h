//
//  GameLayer.h
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLLayer.h"
#import "HLScene.h"
#import "HLWireframSphere.h"
#import "HLWireframeTorus.h"
#import "HLWireframeTrefoilKnot.h"
#import "HLWireframeMobiusStrip.h"
#import "HLWireframeKleinBottle.h"

@interface GameLayer : HLLayer{
    HLWireframSphere * bottle ;
}

+ (HLScene*)scene;
+ (id)node;
@end
