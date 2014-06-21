//
//  HL3IndexTriangle.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3IndexTriangle.h"

@implementation HL3IndexTriangle

+ (id)indexTriangle{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        memset(vertexIndex, 0, sizeof(int)*3);
    }
    return self;
}

- (void)setIndexes:(int)indexOne two:(int)indexTwo three:(int)indexThree{
    vertexIndex[0] = indexOne;
    vertexIndex[1] = indexTwo;
    vertexIndex[2] = indexThree;
}

- (int*)vertexIndex{
    return vertexIndex;
}

@end
