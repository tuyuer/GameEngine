//
//  HLActionInterval.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLFiniteTimeAction.h"
#include <sys/time.h>

/** an interval action is an action that takes place within a certain period of time
    it has an start time ,and a finish time . the finish time is the parameter duration
    plus the start time 
 
    these HLActionIntervalactions have some interesting properties, like:
    - they can run normally 
    - they can run reversed with the reverse method
    - they can run with the time alterd with the accelerate ,accelDeccel and Speed actions
     For example, you can simulate a Ping Pong effect running the action normally and
     then running it again in Reverse mode.
     
     Example:
     
     HLAction * pingPongAction = [HLSequence actions: action, [action reverse], nil];
 */

@interface HLActionInterval : HLFiniteTimeAction<NSCopying>{
    float _elapsed;
    BOOL _firstTick;
}

@property (nonatomic,readonly) float elapsed;
/** creates the action */
+(id) actionWithDuration: (float) d;
/** initializes the action */
-(id) initWithDuration: (float) d;
/** returns YES if the action has finished */
-(BOOL) isDone;
/** returns a reversed action */
- (HLActionInterval*) reverse;
@end


















