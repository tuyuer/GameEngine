//
//  HL3ClippingNode.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-14.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLNode.h"

@interface HL3ClippingNode : HLNode{
    HLNode * _stencil;
    GLfloat _alphaThreshold;
    BOOL _inverted;
}

@property (nonatomic, retain) HLNode *stencil;
@property (nonatomic) GLfloat alphaThreshold;
@property (nonatomic) BOOL inverted;

+ (id)clippingNode;
- (id)init;
- (id)initWithStencil:(HLNode *)stencil;

@end
