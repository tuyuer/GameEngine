//
//  HLMoveBy.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLActionInterval.h"

@interface HLMoveBy : HLActionInterval<NSCopying>{
    CGPoint _positionDelta;
    CGPoint _startPos;
    CGPoint _previousPos;
}

/** creates the action */
+(id) actionWithDuration: (float)duration position:(CGPoint)deltaPosition;
/** initializes the action */
-(id) initWithDuration: (float)duration position:(CGPoint)deltaPosition;
@end
