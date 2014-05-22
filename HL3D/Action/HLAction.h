//
//  HLAction.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#include <sys/time.h>
#import <Foundation/Foundation.h>
#import "HLTypes.h"

enum {
	//! Default tag
	kHLActionTagInvalid = -1,
};

/** Base class for HLAction Class
 */

@interface HLAction : NSObject<NSCopying>{

    id _originalTarget;
    id _target;
    NSInteger _tag;

}

/** the "target". the action will modify the target properties
 the target will be set with "startWithTarget" method
 when the 'stop' method is called, target will be set to nil.
 the target is 'assigned', it is not 'retained'
*/
@property (nonatomic,readonly,assign) id target;

/** the original target, since target can be nil
 is the target that were used to run the action.
 unless you are doing somthing complex,
 like CCActionManager,
 you should not call this method
*/
@property (nonatomic,readonly,assign) id originalTarget;

/** the action tag , an identifier of the action */
@property (nonatomic,readwrite,assign) NSInteger tag;

-(id) copyWithZone: (NSZone*) zone;

//create and initialize
+(id) action;

//! return YES if the action has finished
-(BOOL) isDone;

/** Initializes the action */
-(id) init;
//! called before the action start. It will also set the target.
-(void) startWithTarget:(id)target;
//! called after the action has finished. It will set the 'target' to nil.
//! IMPORTANT: You should never call "[action stop]" manually. Instead, use: "[target stopAction:action];"
-(void) stop;
//! called every frame with its delta time. DON'T override unless you know what you are doing.
-(void) step: (float) dt;
//! called once per frame. time a value between 0 and 1
//! For example:
//! * 0 means that the action just started
//! * 0.5 means that the action is in the middle
//! * 1 means that the action is over
-(void) update: (float) time;

@end















