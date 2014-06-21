//
//  HL3Vertex.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Vertex.h"

@implementation HL3Vertex
@synthesize position = _position;
@synthesize textureCoord = _textureCoord;
@synthesize normal = _normal;
@synthesize color = _color;


+ (id)vertexWithPosition:(HL3Vector)pos color:(HL3Vector4)color texCoord:(HL3Vector2)texCoord normal:(HL3Vector)normal{
    return [[[self alloc] initWithPosition:pos color:color texCoord:texCoord normal:normal] autorelease];
}

- (id)initWithPosition:(HL3Vector)pos color:(HL3Vector4)color texCoord:(HL3Vector2)texCoord normal:(HL3Vector)normal{
    if (self = [super init]) {
        _position = pos;
        _color = color;
        _textureCoord = texCoord;
        _normal = normal;
    }
    return self;
}

+ (id)vertex{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        _color = HL3Vector4Make(1.0, 1.0, 1.0, 1.0);
        _textureCoord = CGPointMake(0, 0);
        _position = hl3v(0, 0, 0);
        _normal = hl3v(0, 0, 0);
    }
    return self;
}

@end

















