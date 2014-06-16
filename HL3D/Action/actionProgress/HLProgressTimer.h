//
//  HLProgressTimer.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLNode.h"
#import "HLSprite.h"
#import "HL3Foundation.h"

typedef enum {
	kHLProgressTimerTypeRadial,
	kHLProgressTimerTypeBar,
} HLProgressTimerType;


/**
 CCProgresstimer is a subclass of CCNode.
 It renders the inner sprite according to the percentage.
 The progress can be Radial, Horizontal or vertical.
 @since v0.99.1
 */

@interface HLProgressTimer : HLNode{
    HLProgressTimerType     _type;
    float                   _percentage;
    HLSprite                *_sprite;
    
    int                     _vertexDataCount;
    ccV2F_C4B_T2F           *_vertexData;
    CGPoint                 _midpoint;
    CGPoint                 _barChangeRate;
    BOOL                    _reverseDirection;
}

@end















