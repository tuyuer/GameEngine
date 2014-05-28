//
//  HLSequence.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLActionInterval.h"
#import "HLFiniteTimeAction.h"

@interface HLSequence : HLActionInterval<NSCopying>{
    HLFiniteTimeAction *_actions[2];
	float _split;
	int _last;
}

/** helper constructor to create an array of sequence-able actions */
+(id) actions: (HLFiniteTimeAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;
/** helper constructor to create an array of sequence-able actions */
+(id) actions: (HLFiniteTimeAction*) action1 vaList:(va_list) args;
/** helper constructor to create an array of sequence-able actions given an array */
+(id) actionWithArray: (NSArray*) arrayOfActions;
/** creates the action */
+(id) actionOne:(HLFiniteTimeAction*)actionOne two:(HLFiniteTimeAction*)actionTwo;
/** initializes the action */
-(id) initOne:(HLFiniteTimeAction*)actionOne two:(HLFiniteTimeAction*)actionTwo;

@end
