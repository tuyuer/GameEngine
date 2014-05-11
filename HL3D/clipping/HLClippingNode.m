//
//  HLClippingNode.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-9.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLClippingNode.h"

static GLint _stencilBits = -1;


@implementation HLClippingNode
@synthesize stencil = _stencil;
@synthesize alphaThreshold = _alphaThreshold;
@synthesize inverted = _inverted;


+ (id)clippingNode
{
    return [self node];
}

- (id)init{
    return [self initWithStencil:nil];
}

- (id)initWithStencil:(HLNode *)stencil{
    if (self = [super init]) {
        self.stencil = stencil;
        self.alphaThreshold = 1;
        self.inverted = NO;
        
        if (_stencilBits <= 0 ) {
            glGetIntegerv(GL_STENCIL_BITS, &_stencilBits);
        }
    }
    return self;
}

@end
