//
//  HLFiniteTimeAction.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLAction.h"

/** base class actions that do have a finite time duration
    possible actions:
    - an action with a duration of 0 seconds
    - an action with a duration of 15.5 seconds
    infinite time actions a valid
 */

@interface HLFiniteTimeAction : HLAction <NSCopying>{
    //duration in seconds
    float _duration;
}
@property (nonatomic,readwrite) float duration;
/** returns a reversed action */
- (HLFiniteTimeAction*) reverse;
@end
