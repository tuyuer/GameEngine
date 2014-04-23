//
//  HLWireframeKleinBottle.m
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLWireframeKleinBottle.h"

@implementation HLWireframeKleinBottle

+ (id)kleinBottleWithScale:(float)scaleValue{
    return [[[self alloc] initWithScale:scaleValue] autorelease];
}

- (id)initWithScale:(float)scaleValue{
    if (self = [super init]) {
        _scale = scaleValue;
        ParametricInterval interval = { CGPointMake(20, 20), CGPointMake(2*M_PI, 2*M_PI), CGPointMake(15, 50) };
        [self SetInterval:interval];
    }
    return self;
}

- (HL3Vector)Evaluate:(CGPoint)domain{
    float v = 1 - domain.x;
    float u = domain.y;
    
    float x0 = 3 * cos(u) * (1 + sin(u)) +
    (2 * (1 - cos(u) / 2)) * cos(u) * cos(v);
    
    float y0  = 8 * sin(u) + (2 * (1 - cos(u) / 2)) * sin(u) * cos(v);
    
    float x1 = 3 * cos(u) * (1 + sin(u)) +
    (2 * (1 - cos(u) / 2)) * cos(v + M_PI);
    
    float y1 = 8 * sin(u);
    
    HL3Vector range;
    range.x = u < M_PI ? x0 : x1;
    range.y = u < M_PI ? -y0 : -y1;
    range.z = (-2 * (1 - cos(u) / 2)) * sin(v);
    
    return hl3v(range.x*_scale, range.y*_scale, range.z*_scale);
}

@end
