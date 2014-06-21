//
//  HL3Material.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Material.h"

@implementation HL3Material

+ (id)material{
    return [[[self alloc] init] autorelease];
}

+ (id)materialWithColor:(HL3Vector4)color diffuse:(HL3Vector4)diffuse
                ambient:(HL3Vector4)ambient specular:(HL3Vector4)specular
                shiness:(float)shiness{
    return [[[self alloc] initWithColor:color diffuse:diffuse ambient:ambient specular:specular shiness:shiness] autorelease];
}

- (id)initWithColor:(HL3Vector4)color diffuse:(HL3Vector4)diffuse
            ambient:(HL3Vector4)ambient specular:(HL3Vector4)specular
            shiness:(float)shiness{
    if (self = [super init]) {
        _color = color;
        _diffuse = diffuse;
        _ambient = ambient;
        _specular = specular;
        _shiness = shiness;
    }
    return self;
}

- (id)init{
    if (self = [super init]) {
        _color = HL3Vector4Make(1.0, 1.0, 1.0, 1.0);
        _diffuse = HL3Vector4Make(1.0, 1.0, 1.0, 1.0);
        _ambient = HL3Vector4Make(1.0, 1.0, 1.0, 1.0);
        _specular = HL3Vector4Make(1.0, 1.0, 1.0, 1.0);
        _shiness = 1.0;
    }
    return self;
}

@end



