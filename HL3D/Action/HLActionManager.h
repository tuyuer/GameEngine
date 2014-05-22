//
//  HLActionManager.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uthash.h"
#import "HLAction.h"

typedef struct _hashElement
{
    NSMutableArray * actions;
    NSUInteger actionIndex;
    BOOL currentActionSalvaged;
    BOOL paused;
    UT_hash_handle hh;
    
    id				target;
    HLAction		*currentAction;
}tHashElement;




/**
 HLActionManager the object that manages all the actions.
 Normally you won't need to use this API directly. 99% of the cases you will use the CCNode interface, which uses this object.
 But there are some cases where you might need to use this API directly:
 Examples:
 - When you want to run an action where the target is different from a CCNode.
 - When you want to pause / resume the actions
 */
@interface HLActionManager : NSObject{
    tHashElement * targets;
    tHashElement * currentTarget;
    BOOL currentTargetSalvaged;
}

/** Adds an action with a target.
 If the target is already present, then the action will be added to the existing target.
 If the target is not present, a new instance of this target will be created either paused or paused, and the action will be added to the newly created target.
 When the target is paused, the queued actions won't be 'ticked'.
 */
-(void) addAction: (HLAction*) action target:(id)target paused:(BOOL)paused;

/** Removes all actions from all the targets.
 */
-(void) removeAllActions;

/** Removes all actions from a certain target.
 All the actions that belongs to the target will be removed.
 */
-(void) removeAllActionsFromTarget:(id)target;
/** Removes an action given an action reference.
 */
-(void) removeAction: (HLAction*) action;
/** Removes an action given its tag and the target */
-(void) removeActionByTag:(NSInteger)tag target:(id)target;
/** Gets an action given its tag an a target
 @return the Action the with the given tag
 */
-(HLAction*) getActionByTag:(NSInteger) tag target:(id)target;
/** Returns the numbers of actions that are running in a certain target
 * Composable actions are counted as 1 action. Example:
 *    If you are running 1 Sequence of 7 actions, it will return 1.
 *    If you are running 7 Sequences of 2 actions, it will return 7.
 */
-(NSUInteger) numberOfRunningActionsInTarget:(id)target;

/** Pauses the target: all running actions and newly added actions will be paused.
 */
-(void) pauseTarget:(id)target;
/** Resumes the target. All queued actions will be resumed.
 */
-(void) resumeTarget:(id)target;

/** Pauses all running actions, returning a list of targets whose actions were paused.
 */
-(NSSet *) pauseAllRunningActions;

/** Resume a set of targets (convenience function to reverse a pauseAllRunningActions call)
 */
-(void) resumeTargets:(NSSet *)targetsToResume;

@end


















