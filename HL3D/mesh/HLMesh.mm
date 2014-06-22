//
//  HLMesh.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLMesh.h"

@implementation HLMesh

- (void)dealloc{
    [_material release];
    [_indexVBO release];
    [super dealloc];
}

+ (id)mesh{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        _material = [HL3Material material];
        _indexVBO = [HL3IndexVBO indexVBO];
        
        [_material retain];
        [_indexVBO retain];
    }
    return self;
}

@end
