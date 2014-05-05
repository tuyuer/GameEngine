//
//  HLWireframSphere.m
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLWireframSphere.h"

@implementation HLWireframSphere

+ (id)sphereWithRadius:(float)radius{
    return [[[self alloc] initWithRadius:radius] autorelease];
}

- (id)initWithRadius:(float)radius{
    if (self = [super init]) {
        _radius = radius;
        ParametricInterval interval = { CGPointMake(40, 40), CGPointMake(M_PI, 2*M_PI), CGPointMake(3, 3) };
        [self SetInterval:interval];
    }
    return self;
}

- (HL3Vector)Evaluate:(CGPoint)domain{
    float u = domain.x, v = domain.y;
    float x = _radius * sin(u) * cos(v);
    float y = _radius * cos(u);
    float z = _radius * -sin(u) * sin(v);
    return hl3v(x, y, z);
}

@end
