//
//  HLWireframeTorus.m
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLWireframeTorus.h"

@implementation HLWireframeTorus

+ (id)torusWithMajorRadius:(float)majorRadius minorRadius:(float)minRadius{
    return [[self alloc] initWithMajorRadius:majorRadius minorRadius:minRadius];
}

- (id)initWithMajorRadius:(float)majorRadius minorRadius:(float)minRadius{
    if (self = [super init]) {
        _majorRadius = majorRadius;
        _minorRadius = minRadius;
        
        ParametricInterval interval = { CGPointMake(20, 20), CGPointMake(2*M_PI, 2*M_PI), CGPointMake(40, 10) };
        [self SetInterval:interval];
    }
    return self;
}

- (HL3Vector)Evaluate:(CGPoint)domain{
    const float major = _majorRadius;
    const float minor = _minorRadius;
    float u = domain.x, v = domain.y;
    float x = (major + minor * cos(v)) * cos(u);
    float y = (major + minor * cos(v)) * sin(u);
    float z = minor * sin(v);
    return hl3v(x, y, z);
}

@end
