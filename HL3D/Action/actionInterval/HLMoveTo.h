//
//  HLMoveTo.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-27.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLActionInterval.h"
#import "HLMoveBy.h"

@interface HLMoveTo : HLMoveBy{
    CGPoint _endPosition;
}

/** creates the action */
+(id) actionWithDuration:(float)duration position:(CGPoint)position;
/** initializes the action */
-(id) initWithDuration:(float)duration position:(CGPoint)position;

@end
