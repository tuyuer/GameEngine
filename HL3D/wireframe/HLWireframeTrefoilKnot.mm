//
//  HLWireframeTrefoilKnot.m
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLWireframeTrefoilKnot.h"
#import "HL3Foundation.h"

@implementation HLWireframeTrefoilKnot


+ (id)trefoilKnotWithScale:(float)scaleValue{
    return [[[self alloc] initWithScale:scaleValue] autorelease];
}

- (id)initWithScale:(float)scaleValue{
    if (self = [super init]) {
        _scale = scaleValue;
        ParametricInterval interval = { CGPointMake(100, 15), CGPointMake(2*M_PI, 2*M_PI), CGPointMake(12, 1) };
        [self SetInterval:interval];
    }
    return self;
}

- (HL3Vector)Evaluate:(CGPoint)domain{
    const float a = 0.5f;
    const float b = 0.3f;
    const float c = 0.5f;
    const float d = 0.1f;
    float u = (2*M_PI - domain.x) * 2;
    float v = domain.y;
    
    float r = a + b * cos(1.5f * u);
    float x = r * cos(u);
    float y = r * sin(u);
    float z = c * sin(1.5f * u);
    
    HL3Vector dv;
    dv.x = -1.5f * b * sin(1.5f * u) * cos(u) -
    (a + b * cos(1.5f * u)) * sin(u);
    dv.y = -1.5f * b * sin(1.5f * u) * sin(u) +
    (a + b * cos(1.5f * u)) * cos(u);
    dv.z = 1.5f * c * cos(1.5f * u);
    
    HL3Vector q = HL3VectorNormalize(dv);
    HL3Vector qvn = HL3VectorNormalize(hl3v(q.y, -q.x, 0));
    HL3Vector ww = HL3VectorCross(q, qvn);
    
    HL3Vector range;
    range.x = x + d * (qvn.x * cos(v) + ww.x * sin(v));
    range.y = y + d * (qvn.y * cos(v) + ww.y * sin(v));
    range.z = z + d * ww.z * sin(v);
    return hl3v(range.x*_scale, range.y*_scale, range.z*_scale);
}

@end
