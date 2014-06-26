//
//  HL3Light.m
//  GameEngine
//
//  Created by tuyuer on 14-4-23.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HL3Light.h"

@implementation HL3Light
@synthesize direction = _direction;
@synthesize diffuse = _diffuse;
@synthesize ambient = _ambient;
@synthesize specular = _specular;
@synthesize shiness = _shiness;

+ (id)light{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        _direction = hl3v(0, 0, 0);
        
        _diffuse = HL3Vector4Make(1, 1, 1, 1);
        _ambient = HL3Vector4Make(0, 0, 0, 1);
        _specular = HL3Vector4Make(1, 1, 1, 1);
        _shiness = 50.0;
    }
    return self;
}

- (BOOL)isLight{
    return YES;
}

@end
