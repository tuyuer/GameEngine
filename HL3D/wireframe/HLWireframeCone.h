//
//  HLWireframeCone.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-13.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLParametricSurface.h"

@interface HLWireframeCone : HLParametricSurface{
    float _height;
    float _radius;
}

+ (id)coneWithHeight:(float)height radius:(float)radius;
- (id)initWithHeight:(float)height radius:(float)radius;
@end
