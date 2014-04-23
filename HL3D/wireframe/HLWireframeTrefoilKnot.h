//
//  HLWireframeTrefoilKnot.h
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLParametricSurface.h"

@interface HLWireframeTrefoilKnot : HLParametricSurface{
    float _scale;
}

+ (id)trefoilKnotWithScale:(float)scaleValue;
- (id)initWithScale:(float)scaleValue;

@end
