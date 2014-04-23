//
//  HLWireframeMobiusStrip.m
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLWireframeMobiusStrip.h"

@implementation HLWireframeMobiusStrip

+ (id)MobiusStripWithScale:(float)scaleValue{
    return [[self alloc] initWithScale:scaleValue];
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
    float u = domain.x;
    float t = domain.y;
    float major = 1.25;
    float a = 0.125f;
    float b = 0.5f;
    float phi = u / 2;
    
    // General equation for an ellipse where phi is the angle
    // between the major axis and the X axis.
    float x = a * cos(t) * cos(phi) - b * sin(t) * sin(phi);
    float y = a * cos(t) * sin(phi) + b * sin(t) * cos(phi);
    
    // Sweep the ellipse along a circle, like a torus.
    HL3Vector range;
    range.x = (major + x) * cos(u);
    range.y = (major + x) * sin(u);
    range.z = y;

    return hl3v(range.x*_scale, range.y*_scale, range.z*_scale);
}


@end
