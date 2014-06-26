//
//  HL3Camera.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Camera.h"

@implementation HL3Camera
@synthesize fieldOfView = _fieldOfView;

+ (id)camera{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        _fieldOfView = kHL3DefaultFieldOfView;
    }
    return self;
}

- (BOOL)isCamera{
    return YES;
}

@end
