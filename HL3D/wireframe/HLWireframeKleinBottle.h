//
//  HLWireframeKleinBottle.h
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLParametricSurface.h"

@interface HLWireframeKleinBottle : HLParametricSurface{
    float _scale;
}

+ (id)kleinBottleWithScale:(float)scaleValue;
- (id)initWithScale:(float)scaleValue;

@end
