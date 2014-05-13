//
//  HLWireframeCone.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-13.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLWireframeCone.h"
#import "HLTextureCache.h"

@implementation HLWireframeCone

+ (id)coneWithHeight:(float)height radius:(float)radius{
    return [[[self alloc] initWithHeight:height radius:radius] autorelease];
}

- (id)initWithHeight:(float)height radius:(float)radius{
    if (self = [super init]) {
        _height = height;
        _radius = radius;
        _texture = [[HLTextureCache sharedTextureCache] addImage:@"Marble.png"];
        ParametricInterval interval = { CGPointMake(40, 40), CGPointMake(2*M_PI, 1), CGPointMake(1, 1) };
        [self SetInterval:interval];
    }
    return self;
}

- (HL3Vector)Evaluate:(CGPoint)domain{
    float u = domain.x, v = domain.y;
    float x = _radius * (1 - v) * cos(u);
    float y = _height * (v - 0.5f);
    float z = _radius * (1 - v) * -sin(u);
    return hl3v(x, y, z);
}

- (bool)UseDomainCoords{
    return false;
}



@end
