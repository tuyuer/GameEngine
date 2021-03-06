//
//  HLActionManager.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLActionManager.h"

@implementation HLActionManager


-(id) init
{
	if ((self=[super init]) ) {
		targets = NULL;
	}
    
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p>", [self class], self];
}

- (void) dealloc
{
	[super dealloc];
}

-(void) addAction:(HLAction*)action target:(id)target paused:(BOOL)paused
{
	NSAssert( action != nil, @"Argument action must be non-nil");
	NSAssert( target != nil, @"Argument target must be non-nil");
    
	tHashElement *element = NULL;
	HASH_FIND_INT(targets, &target, element);
	if( ! element ) {
		element = calloc( sizeof( *element ), 1 );
		element->paused = paused;
		element->target = [target retain];
		HASH_ADD_INT(targets, target, element);
        //		CCLOG(@"cocos2d: ---- buckets: %d/%d - %@", targets->entries, targets->size, element->target);
        
	}
    
    [self actionAllocWithHashElement:element];
	NSAssert( ![element->actions containsObject:action], @"runAction: Action already running");
    [element->actions addObject:action];
    
	[action startWithTarget:target];
}

-(void) deleteHashElement:(tHashElement*)element
{
    [element->actions release];
	HASH_DEL(targets, element);
	[element->target release];
	free(element);
}

-(void) actionAllocWithHashElement:(tHashElement*)element
{
	// 4 actions per Node by default
	if( element->actions == nil )
		element->actions = [[NSMutableArray alloc] init];
}

-(void) removeActionAtIndex:(NSUInteger)index hashElement:(tHashElement*)element
{
	id action = [element->actions objectAtIndex:index];
    
	if( action == element->currentAction && !element->currentActionSalvaged ) {
		[element->currentAction retain];
		element->currentActionSalvaged = YES;
	}
    
    [element->actions removeObjectAtIndex:index];
    
	// update actionIndex in case we are in tick:, looping over the actions
	if( element->actionIndex >= index )
		element->actionIndex--;
    
	if( [element->actions count]== 0 ) {
		if( currentTarget == element )
			currentTargetSalvaged = YES;
		else
			[self deleteHashElement: element];
	}
}

#pragma mark ActionManager - remove

-(void) removeAllActions
{
	for(tHashElement *element=targets; element != NULL; ) {
		id target = element->target;
		element = element->hh.next;
		[self removeAllActionsFromTarget:target];
	}
}
-(void) removeAllActionsFromTarget:(id)target
{
	// explicit nil handling
	if( target == nil )
		return;
    
	tHashElement *element = NULL;
	HASH_FIND_INT(targets, &target, element);
	if( element ) {
		if( [element->actions containsObject:element->currentAction] && !element->currentActionSalvaged ) {
			[element->currentAction retain];
			element->currentActionSalvaged = YES;
		}

        [element->actions removeAllObjects];
		if( currentTarget == element )
			currentTargetSalvaged = YES;
		else
			[self deleteHashElement:element];
	}

}

-(void) removeAction: (HLAction*) action
{
	// explicit nil handling
	if (action == nil)
		return;
    
	tHashElement *element = NULL;
	id target = [action originalTarget];
	HASH_FIND_INT(targets, &target, element );
	if( element ) {
		NSUInteger i = [element->actions indexOfObject:action];
		if( i != NSNotFound )
			[self removeActionAtIndex:i hashElement:element];
	}
    //	else {
    //		CCLOG(@"cocos2d: removeAction: Target not found");
    //	}
}

-(void) removeActionByTag:(NSInteger)aTag target:(id)target
{
	NSAssert( aTag != kHLActionTagInvalid, @"Invalid tag");
	NSAssert( target != nil, @"Target should be ! nil");
    
	tHashElement *element = NULL;
	HASH_FIND_INT(targets, &target, element);
    
	if( element ) {
		NSUInteger limit = [element->actions count];
		for( NSUInteger i = 0; i < limit; i++) {
			HLAction *a = [element->actions objectAtIndex:i];
            
			if( a.tag == aTag && [a originalTarget]==target) {
				[self removeActionAtIndex:i hashElement:element];
				break;
			}
		}
        
	}
}

#pragma mark ActionManager - get

-(HLAction*) getActionByTag:(NSInteger)aTag target:(id)target
{
	NSAssert( aTag != kHLActionTagInvalid, @"Invalid tag");
    
	tHashElement *element = NULL;
	HASH_FIND_INT(targets, &target, element);
    
	if( element ) {
		if( element->actions != nil ) {
			NSUInteger limit = [element->actions count];
			for( NSUInteger i = 0; i < limit; i++) {
				HLAction *a = [element->actions objectAtIndex:i];
                
				if( a.tag == aTag )
					return a;
			}
		}
        //		CCLOG(@"cocos2d: getActionByTag: Action not found");
	}
    //	else {
    //		CCLOG(@"cocos2d: getActionByTag: Target not found");
    //	}
	return nil;
}

-(NSUInteger) numberOfRunningActionsInTarget:(id) target
{
	tHashElement *element = NULL;
	HASH_FIND_INT(targets, &target, element);
	if( element )
		return element->actions ? [element->actions count] : 0;
    
    //	CCLOG(@"cocos2d: numberOfRunningActionsInTarget: Target not found");
	return 0;
}


-(void) update: (float) dt
{
	for(tHashElement *elt = targets; elt != NULL; ) {
        
		currentTarget = elt;
		currentTargetSalvaged = NO;
        
		if( ! currentTarget->paused ) {
            
			// The 'actions' ccArray may change while inside this loop.
			for( currentTarget->actionIndex = 0; currentTarget->actionIndex < [currentTarget->actions count]; currentTarget->actionIndex++) {
				currentTarget->currentAction = [currentTarget->actions objectAtIndex:currentTarget->actionIndex];
				currentTarget->currentActionSalvaged = NO;
                
				[currentTarget->currentAction step: dt];
                
				if( currentTarget->currentActionSalvaged ) {
					// The currentAction told the node to remove it. To prevent the action from
					// accidentally deallocating itself before finishing its step, we retained
					// it. Now that step is done, it's safe to release it.
					[currentTarget->currentAction release];
                    
				} else if( [currentTarget->currentAction isDone] ) {
					[currentTarget->currentAction stop];
                    
					HLAction *a = currentTarget->currentAction;
					// Make currentAction nil to prevent removeAction from salvaging it.
					currentTarget->currentAction = nil;
					[self removeAction:a];
				}
                
				currentTarget->currentAction = nil;
			}
		}
        
		// elt, at this moment, is still valid
		// so it is safe to ask this here (issue #490)
		elt = elt->hh.next;
        
		// only delete currentTarget if no actions were scheduled during the cycle (issue #481)
		if( currentTargetSalvaged && [currentTarget->actions count]== 0 )
			[self deleteHashElement:currentTarget];
	}
    
	// issue #635
	currentTarget = nil;
}


#pragma mark ActionManager - Pause / Resume

-(void) pauseTarget:(id)target
{
	tHashElement *element = NULL;
	HASH_FIND_INT(targets, &target, element);
	if( element )
		element->paused = YES;
    //	else
    //		CCLOG(@"cocos2d: pauseAllActions: Target not found");
}

-(void) resumeTarget:(id)target
{
	tHashElement *element = NULL;
	HASH_FIND_INT(targets, &target, element);
	if( element )
		element->paused = NO;
    //	else
    //		CCLOG(@"cocos2d: resumeAllActions: Target not found");
}

-(NSSet *) pauseAllRunningActions
{
    NSMutableSet* idsWithActions = [NSMutableSet setWithCapacity:50];
    
    for(tHashElement *element=targets; element != NULL; element=element->hh.next) {
        if( !element->paused ) {
            element->paused = YES;
            [idsWithActions addObject:element->target];
        }
    }
    return idsWithActions;
}

-(void) resumeTargets:(NSSet *)targetsToResume
{
    for(id target in targetsToResume) {
        [self resumeTarget:target];
    }
}

#pragma


@end
