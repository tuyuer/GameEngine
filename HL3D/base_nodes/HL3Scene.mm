//
//  HL3Scene.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Scene.h"
#import "HL3Layer.h"

@implementation HL3Scene
@synthesize hl3Layer = _hl3Layer;
@synthesize lights = _lights;
@synthesize activeCamera = _activeCamera;

- (void)dealloc{
    _hl3Layer = nil;
    _activeCamera = nil;
    [_lights release];
    [super dealloc];
}

+ (id)scene {
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        _lights = [[NSMutableArray alloc] initWithCapacity:10];
        _activeCamera = nil;
        _hl3Layer = nil;
    }
    return self;
}

- (void)open{

}


@end








