//
//  HLSchedule.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-5.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLScheduler.h"
#import "HLDirector.h"


//
// Data structures
//
#pragma mark -
#pragma mark Data Structures
// A list double-linked list used for "updates with priority"
typedef struct _listEntry
{
	struct	_listEntry *prev, *next;
	TICK_IMP	impMethod;
	id			target;				// not retained (retained by hashUpdateEntry)
	NSInteger	priority;
	BOOL		paused;
    BOOL		markedForDeletion;	// selector will no longer be called and entry will be removed at end of the next tick
} tListEntry;


typedef struct _hashUpdateEntry
{
	tListEntry		**list;		// Which list does it belong to ?
	tListEntry		*entry;		// entry in the list
	id				target;		// hash key (retained)
	UT_hash_handle  hh;
} tHashUpdateEntry;

// Hash Element used for "selectors with interval"
typedef struct _hashSelectorEntry
{
	NSMutableArray	*timers;
	id				target;		// hash key (retained)
	unsigned int	timerIndex;
	HLTimer			*currentTimer;
	BOOL			currentTimerSalvaged;
	BOOL			paused;
	UT_hash_handle  hh;
} tHashTimerEntry;


//
// CCTimer
//
#pragma mark - HLTimer

@interface HLTimer ()
-(void) setupTimerWithInterval:(hlTime)seconds repeat:(uint)r delay:(hlTime)d;
-(void) trigger;
-(void) cancel;
@end

@implementation HLTimer

@synthesize interval=_interval;

-(void) setupTimerWithInterval:(hlTime)seconds repeat:(uint)r delay:(hlTime)d
{
	_elapsed = -1;
	_interval = seconds;
	_delay = d;
	_useDelay = (_delay > 0) ? YES : NO;
	_repeat = r;
	_runForever = (_repeat == UINT_MAX -1) ? YES : NO;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) trigger
{
	// override me
}

-(void) cancel
{
	// override me
}

-(void) update: (hlTime) dt
{
	if( _elapsed == - 1)
	{
		_elapsed = 0;
		_nTimesExecuted = 0;
	}
	else
	{
		if (_runForever && !_useDelay)
		{//standard timer usage
			_elapsed += dt;
			if( _elapsed >= _interval ) {
				[self trigger];
				_elapsed = 0;
                
			}
		}
		else
		{//advanced usage
			_elapsed += dt;
			if (_useDelay)
			{
				if( _elapsed >= _delay )
				{
					[self trigger];
					_elapsed = _elapsed - _delay;
					_nTimesExecuted+=1;
					_useDelay = NO;
				}
			}
			else
			{
				if (_elapsed >= _interval)
				{
					[self trigger];
					_elapsed = 0;
					_nTimesExecuted += 1;
                    
				}
			}
            
			if (!_runForever && _nTimesExecuted > _repeat)
			{	//unschedule timer
				[self cancel];
			}
		}
	}
}
@end



#pragma mark HLTimerTargetSelector

@implementation HLTimerTargetSelector

@synthesize selector=_selector;

+(id) timerWithTarget:(id)t selector:(SEL)s
{
	return [[[self alloc] initWithTarget:t selector:s interval:0 repeat:(UINT_MAX -1) delay:0] autorelease];
}

+(id) timerWithTarget:(id)t selector:(SEL)s interval:(hlTime) i
{
	return [[[self alloc] initWithTarget:t selector:s interval:i repeat:(UINT_MAX -1) delay:0] autorelease];
}

-(id) initWithTarget:(id)t selector:(SEL)s
{
	return [self initWithTarget:t selector:s interval:0 repeat:(UINT_MAX -1) delay: 0];
}

-(id) initWithTarget:(id)t selector:(SEL)s interval:(hlTime) seconds repeat:(uint) r delay:(hlTime) d
{
	if( (self=[super init]) ) {
        
		// target is not retained. It is retained in the hash structure
		_target = t;
		_selector = s;
		_impMethod = (TICK_IMP) [t methodForSelector:s];
		
		[self setupTimerWithInterval:seconds repeat:r delay:d];
	}
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p | target:%@ selector:(%@)>", [self class], self, [_target class], NSStringFromSelector(_selector)];
}

-(void) trigger
{
	_impMethod(_target, _selector, _elapsed);
}

-(void) cancel
{
	[[[HLDirector sharedDirector] scheduler] unscheduleSelector:_selector forTarget:_target];
}

@end



#pragma mark HLTimerBlock

@implementation HLTimerBlock

@synthesize key=_key;
@synthesize target=_target;

+(id) timerWithTarget:(id)owner interval:(hlTime)seconds key:(NSString*)key block:(void(^)(hlTime delta)) block
{
	return [[[self alloc] initWithTarget:(id)owner interval:seconds repeat:(UINT_MAX -1)  delay:0 key:key block:block] autorelease];
}

-(id) initWithTarget:(id)owner interval:(hlTime) seconds repeat:(uint) r delay:(hlTime)d key:(NSString*)key block:(void(^)(hlTime delta))block
{
	if( (self=[super init]) ) {
		_block = [block copy];
		_key = [key copy];
		_target = owner;
		
		[self setupTimerWithInterval:seconds repeat:r delay:d];
	}
	
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p | block>", [self class], self];
}

- (void)dealloc
{
	[_key release];
    [_block release];
    
    [super dealloc];
}

-(void) trigger
{
	_block( _elapsed);
}

-(void) cancel
{
	[[[HLDirector sharedDirector] scheduler] unscheduleBlockForKey:_key target:_target];
}

@end


//
// CCScheduler
//
#pragma mark - HLScheduler
@interface HLScheduler (Private)
-(void) removeHashElement:(tHashTimerEntry*)element;
@end

@implementation HLScheduler

@synthesize paused = _paused;
@synthesize timeScale = _timeScale;

- (id) init
{
	if( (self=[super init]) ) {
		_timeScale = 1.0f;
        
		// used to trigger CCTimer#update
		updateSelector = @selector(update:);
		impMethod = (TICK_IMP) [HLTimerTargetSelector instanceMethodForSelector:updateSelector];
        
		// updates with priority
		updates0 = NULL;
		updatesNeg = NULL;
		updatesPos = NULL;
		hashForUpdates = NULL;
        
		// selectors with interval
		currentTarget = nil;
		currentTargetSalvaged = NO;
		hashForTimers = nil;
        updateHashLocked = NO;
		_paused = NO;
	}
    
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p | timeScale = %0.2f >", [self class], self, _timeScale];
}

- (void) dealloc
{
	[self unscheduleAll];
	[super dealloc];
}


#pragma mark CCScheduler - Timers

-(void) removeHashElement:(tHashTimerEntry*)element
{
    [element->timers release];
//	ccArrayFree(element->timers);
	[element->target release];
	HASH_DEL(hashForTimers, element);
	free(element);
}

-(void) scheduleSelector:(SEL)selector forTarget:(id)target interval:(hlTime)interval paused:(BOOL)paused
{
	[self scheduleSelector:selector forTarget:target interval:interval repeat:(UINT_MAX-1) delay:0.0f paused:paused];
}

-(void) scheduleSelector:(SEL)selector forTarget:(id)target interval:(hlTime)interval repeat:(uint)repeat delay:(hlTime)delay paused:(BOOL)paused
{
	NSAssert( selector != nil, @"Argument selector must be non-nil");
	NSAssert( target != nil, @"Argument target must be non-nil");
    
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &target, element);
    
	if( ! element ) {
		element = (tHashTimerEntry *)calloc( sizeof( *element ), 1 );
		element->target = [target retain];
		HASH_ADD_INT( hashForTimers, target, element );
        
		// Is this the 1st element ? Then set the pause level to all the selectors of this target
		element->paused = paused;
        
	} else
		NSAssert( element->paused == paused, @"CCScheduler. Trying to schedule a selector with a pause value different than the target");
    
    
	if( element->timers == nil )
		element->timers = [[NSMutableArray arrayWithCapacity:10] retain];
	else
	{
		for( unsigned int i=0; i< [element->timers count]; i++ ) {
			HLTimer *timer = [element->timers objectAtIndex:i];
			if( [timer isKindOfClass:[HLTimerTargetSelector class]] && selector == [(HLTimerTargetSelector*)timer selector] ) {
				[timer setInterval: interval];
				return;
			}
		}
	}
    
	HLTimerTargetSelector *timer = [[HLTimerTargetSelector alloc] initWithTarget:target selector:selector interval:interval repeat:repeat delay:delay];
    [element->timers addObject:timer];
}

-(void) scheduleBlockForKey:(NSString*)key target:(id)owner interval:(hlTime)interval repeat:(uint)repeat delay:(hlTime)delay paused:(BOOL)paused block:(void(^)(hlTime dt))block
{
	NSAssert( block != nil, @"Argument block must be non-nil");
	NSAssert( owner != nil, @"Argument owner must be non-nil");
	
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &owner, element);
	
	if( ! element ) {
		element = (tHashTimerEntry *)calloc( sizeof( *element ), 1 );
		element->target = [owner retain];
		HASH_ADD_INT( hashForTimers, target, element );
		
		// Is this the 1st element ? Then set the pause level to all the selectors of this target
		element->paused = paused;
		
	} else
		NSAssert( element->paused == paused, @"CCScheduler. Trying to schedule a block with a pause value different than the target");
	
	
	if( element->timers == nil )
		element->timers = [[NSMutableArray arrayWithCapacity:10] retain];
	else
	{
		for( unsigned int i=0; i< [element->timers count]; i++ ) {
			HLTimer *timer = [element->timers objectAtIndex:i];
			if( [timer isKindOfClass:[HLTimerBlock class]] && [key isEqualToString:[(HLTimerBlock*)timer key] ] ) {
				[timer setInterval: interval];
				return;
			}
		}
	}
	
	HLTimerBlock *timer = [[HLTimerBlock alloc] initWithTarget:owner interval:interval repeat:repeat delay:delay key:key block:block];
    [element->timers addObject:timer];
	[timer release];
}

-(void) unscheduleSelector:(SEL)selector forTarget:(id)target
{
	// explicity handle nil arguments when removing an object
	if( target==nil && selector==NULL)
		return;
	
	NSAssert( target != nil, @"Target MUST not be nil");
	NSAssert( selector != NULL, @"Selector MUST not be NULL");
	
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &target, element);
	
	if( element ) {
		
		for( unsigned int i=0; i< [element->timers count]; i++ ) {
			HLTimer *timer = [element->timers objectAtIndex:i];
			
			
			if( [timer isKindOfClass:[HLTimerTargetSelector class]] && selector == [(HLTimerTargetSelector*)timer selector] ) {
				
				if( timer == element->currentTimer && !element->currentTimerSalvaged ) {
					[element->currentTimer retain];
					element->currentTimerSalvaged = YES;
				}
				[element->timers removeObjectAtIndex:i];
				
				// update timerIndex in case we are in tick:, looping over the actions
				if( element->timerIndex >= i )
					element->timerIndex--;
				
				if( [element->timers count] == 0 ) {
					if( currentTarget == element )
						currentTargetSalvaged = YES;
					else
						[self removeHashElement: element];
				}
				return;
			}
		}
	}
	
	// Not Found
	//	NSLog(@"CCScheduler#unscheduleSelector:forTarget: selector not found: %@", selString);
	
}

-(void) unscheduleBlockForKey:(NSString*)key target:(id)target
{
	// explicity handle nil arguments when removing an object
	if( target==nil && key==NULL)
		return;
    
	NSAssert( target != nil, @"Target MUST not be nil");
	NSAssert( key != NULL, @"key MUST not be NULL");
    
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &target, element);
    
	if( element ) {
        
		for( unsigned int i=0; i< [element->timers count]; i++ ) {
			HLTimer *timer = [element->timers objectAtIndex:i];
            
            
			if( [timer isKindOfClass:[HLTimerBlock class]] &&  [key isEqualToString: [(HLTimerBlock*)timer key]] ) {
                
				if( timer == element->currentTimer && !element->currentTimerSalvaged ) {
					[element->currentTimer retain];
					element->currentTimerSalvaged = YES;
				}
                [element->timers removeObjectAtIndex:i];
                
				// update timerIndex in case we are in tick:, looping over the actions
				if( element->timerIndex >= i )
					element->timerIndex--;
                
				if( [element->timers count] == 0 ) {
					if( currentTarget == element )
						currentTargetSalvaged = YES;
					else
						[self removeHashElement: element];
				}
				return;
			}
		}
	}
    
	// Not Found
    //	NSLog(@"CCScheduler#unscheduleSelector:forTarget: selector not found: %@", selString);
}

#pragma mark CCScheduler - Update Specific

-(void) priorityIn:(tListEntry**)list target:(id)target priority:(NSInteger)priority paused:(BOOL)paused
{
	tListEntry *listElement = (tListEntry *)malloc( sizeof(*listElement) );
    
	listElement->target = target;
	listElement->priority = priority;
	listElement->paused = paused;
	listElement->impMethod = (TICK_IMP) [target methodForSelector:updateSelector];
	listElement->next = listElement->prev = NULL;
    listElement->markedForDeletion = NO;
    
	// empty list ?
	if( ! *list ) {
		DL_APPEND( *list, listElement );
        
	} else {
		BOOL added = NO;
        
		for( tListEntry *elem = *list; elem ; elem = elem->next ) {
			if( priority < elem->priority ) {
                
				if( elem == *list )
					DL_PREPEND(*list, listElement);
				else {
					listElement->next = elem;
					listElement->prev = elem->prev;
                    
					elem->prev->next = listElement;
					elem->prev = listElement;
				}
                
				added = YES;
				break;
			}
		}
        
		// Not added? priority has the higher value. Append it.
		if( !added )
			DL_APPEND(*list, listElement);
	}
    
	// update hash entry for quicker access
	tHashUpdateEntry *hashElement = (tHashUpdateEntry *)calloc( sizeof(*hashElement), 1 );
	hashElement->target = [target retain];
	hashElement->list = list;
	hashElement->entry = listElement;
	HASH_ADD_INT(hashForUpdates, target, hashElement );
}

-(void) appendIn:(tListEntry**)list target:(id)target paused:(BOOL)paused
{
	tListEntry *listElement = (tListEntry *)malloc( sizeof( * listElement ) );
    
	listElement->target = target;
	listElement->paused = paused;
    listElement->markedForDeletion = NO;
	listElement->impMethod = (TICK_IMP) [target methodForSelector:updateSelector];
    
	DL_APPEND(*list, listElement);
    
    
	// update hash entry for quicker access
	tHashUpdateEntry *hashElement = (tHashUpdateEntry *)calloc( sizeof(*hashElement), 1 );
	hashElement->target = [target retain];
	hashElement->list = list;
	hashElement->entry = listElement;
	HASH_ADD_INT(hashForUpdates, target, hashElement );
}

-(void) scheduleUpdateForTarget:(id)target priority:(NSInteger)priority paused:(BOOL)paused
{
	tHashUpdateEntry * hashElement = NULL;
	HASH_FIND_INT(hashForUpdates, &target, hashElement);
    if(hashElement)
    {
#if COCOS2D_DEBUG >= 1
        NSAssert( hashElement->entry->markedForDeletion, @"CCScheduler: You can't re-schedule an 'update' selector'. Unschedule it first");
#endif
        // TODO : check if priority has changed!
        
        hashElement->entry->markedForDeletion = NO;
        return;
    }
    
	// most of the updates are going to be 0, that's way there
	// is an special list for updates with priority 0
	if( priority == 0 )
		[self appendIn:&updates0 target:target paused:paused];
    
	else if( priority < 0 )
		[self priorityIn:&updatesNeg target:target priority:priority paused:paused];
    
	else // priority > 0
		[self priorityIn:&updatesPos target:target priority:priority paused:paused];
}

- (void) removeUpdateFromHash:(tListEntry*)entry
{
	tHashUpdateEntry * element = NULL;
	
	HASH_FIND_INT(hashForUpdates, &entry->target, element);
	if( element ) {
		// list entry
		DL_DELETE( *element->list, element->entry );
		free( element->entry );
		
		// hash entry
		id target = element->target;
		HASH_DEL( hashForUpdates, element);
		free(element);
		
		// target#release should be the last one to prevent
		// a possible double-free. eg: If the [target dealloc] might want to remove it itself from there
		[target release];
	}
}

-(void) unscheduleUpdateForTarget:(id)target
{
	if( target == nil )
		return;
    
	tHashUpdateEntry * element = NULL;
	HASH_FIND_INT(hashForUpdates, &target, element);
	if( element ) {
        if(updateHashLocked)
            element->entry->markedForDeletion = YES;
        else
            [self removeUpdateFromHash:element->entry];
        
        //		// list entry
        //		DL_DELETE( *element->list, element->entry );
        //		free( element->entry );
        //
        //		// hash entry
        //		[element->target release];
        //		HASH_DEL( hashForUpdates, element);
        //		free(element);
	}
}

#pragma mark CCScheduler - Common for Update selector & Custom Selectors

-(void) unscheduleAll
{
    [self unscheduleAllWithMinPriority:kHLPrioritySystem];
}

-(void) unscheduleAllWithMinPriority:(NSInteger)minPriority
{
	// Custom Selectors
	for(tHashTimerEntry *element=hashForTimers; element != NULL; ) {
		id target = element->target;
		element=(tHashTimerEntry *)element->hh.next;
		[self unscheduleAllForTarget:target];
	}
    
	// Updates selectors
	tListEntry *entry, *tmp;
    if(minPriority < 0) {
        DL_FOREACH_SAFE( updatesNeg, entry, tmp ) {
            if(entry->priority >= minPriority) {
                [self unscheduleUpdateForTarget:entry->target];
            }
        }
    }
    if(minPriority <= 0) {
        DL_FOREACH_SAFE( updates0, entry, tmp ) {
            [self unscheduleUpdateForTarget:entry->target];
        }
    }
	DL_FOREACH_SAFE( updatesPos, entry, tmp ) {
        if(entry->priority >= minPriority) {
            [self unscheduleUpdateForTarget:entry->target];
        }
	}
    
}

-(void) unscheduleAllForTarget:(id)target
{
	// explicit nil handling
	if( target == nil )
		return;
    
	// Custom Selectors
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &target, element);
    
	if( element ) {
        
		if( [element->timers containsObject:element->currentTimer] && !element->currentTimerSalvaged ) {
			[element->currentTimer retain];
			element->currentTimerSalvaged = YES;
		}
        [element->timers removeAllObjects];
		if( currentTarget == element )
			currentTargetSalvaged = YES;
		else
			[self removeHashElement:element];
	}
    
	// Update Selector
	[self unscheduleUpdateForTarget:target];
}

-(void) resumeTarget:(id)target
{
	NSAssert( target != nil, @"target must be non nil" );
    
	// Custom Selectors
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &target, element);
	if( element )
		element->paused = NO;
    
	// Update selector
	tHashUpdateEntry * elementUpdate = NULL;
	HASH_FIND_INT(hashForUpdates, &target, elementUpdate);
	if( elementUpdate ) {
		NSAssert( elementUpdate->entry != NULL, @"resumeTarget: unknown error");
		elementUpdate->entry->paused = NO;
	}
}

-(void) pauseTarget:(id)target
{
	NSAssert( target != nil, @"target must be non nil" );
    
	// Custom selectors
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &target, element);
	if( element )
		element->paused = YES;
    
	// Update selector
	tHashUpdateEntry * elementUpdate = NULL;
	HASH_FIND_INT(hashForUpdates, &target, elementUpdate);
	if( elementUpdate ) {
		NSAssert( elementUpdate->entry != NULL, @"pauseTarget: unknown error");
		elementUpdate->entry->paused = YES;
	}
    
}

-(BOOL) isTargetPaused:(id)target
{
	NSAssert( target != nil, @"target must be non nil" );
    
	// Custom selectors
	tHashTimerEntry *element = NULL;
	HASH_FIND_INT(hashForTimers, &target, element);
	if( element )
		return element->paused;
	
	// We should check update selectors if target does not have custom selectors
	tHashUpdateEntry * elementUpdate = NULL;
	HASH_FIND_INT(hashForUpdates, &target, elementUpdate);
	if ( elementUpdate )
		return elementUpdate->entry->paused;
	
	return NO;  // should never get here
}

-(NSSet*) pauseAllTargets
{
	return [self pauseAllTargetsWithMinPriority:kHLPrioritySystem];
}

-(NSSet*) pauseAllTargetsWithMinPriority:(NSInteger)minPriority
{
	NSMutableSet* idsWithSelectors = [NSMutableSet setWithCapacity:50];
    
	// Custom Selectors
	for(tHashTimerEntry *element=hashForTimers; element != NULL; element=(tHashTimerEntry *)element->hh.next) {
		element->paused = YES;
		[idsWithSelectors addObject:element->target];
	}
    
	// Updates selectors
	tListEntry *entry, *tmp;
	if(minPriority < 0) {
		DL_FOREACH_SAFE( updatesNeg, entry, tmp ) {
			if(entry->priority >= minPriority) {
				entry->paused = YES;
				[idsWithSelectors addObject:entry->target];
			}
		}
	}
	if(minPriority <= 0) {
		DL_FOREACH_SAFE( updates0, entry, tmp ) {
			entry->paused = YES;
			[idsWithSelectors addObject:entry->target];
		}
	}
	DL_FOREACH_SAFE( updatesPos, entry, tmp ) {
		if(entry->priority >= minPriority) {
			entry->paused = YES;
			[idsWithSelectors addObject:entry->target];
		}
	}
    
	return idsWithSelectors;
}

-(void) resumeTargets:(NSSet *)targetsToResume
{
    for(id target in targetsToResume) {
        [self resumeTarget:target];
    }
}

#pragma mark CCScheduler - Main Loop

-(void) update: (hlTime) dt
{
	// all "dt" are going to be ignored if paused
	if( _paused )
		return;
    
    updateHashLocked = YES;
    
	if( _timeScale != 1.0f )
		dt *= _timeScale;
    
	// Iterate all over the Updates selectors
	tListEntry *entry, *tmp;
    
	// updates with priority < 0
	DL_FOREACH_SAFE( updatesNeg, entry, tmp ) {
		if( ! entry->paused && !entry->markedForDeletion )
			entry->impMethod( entry->target, updateSelector, dt );
	}
    
	// updates with priority == 0
	DL_FOREACH_SAFE( updates0, entry, tmp ) {
		if( ! entry->paused && !entry->markedForDeletion )
        {
			entry->impMethod( entry->target, updateSelector, dt );
        }
	}
    
	// updates with priority > 0
	DL_FOREACH_SAFE( updatesPos, entry, tmp ) {
		if( ! entry->paused  && !entry->markedForDeletion )
			entry->impMethod( entry->target, updateSelector, dt );
	}
    
	// Iterate all over the custom selectors (CCTimers)
	for(tHashTimerEntry *elt=hashForTimers; elt != NULL; ) {
        
		currentTarget = elt;
		currentTargetSalvaged = NO;
        
		if( ! currentTarget->paused ) {
            
			// The 'timers' ccArray may change while inside this loop.
			for( elt->timerIndex = 0; elt->timerIndex < [elt->timers count]; elt->timerIndex++) {
                elt->currentTimer = [elt->timers objectAtIndex:elt->timerIndex];
				elt->currentTimerSalvaged = NO;
                
				impMethod( elt->currentTimer, updateSelector, dt);
                
				if( elt->currentTimerSalvaged ) {
					// The currentTimer told the remove itself. To prevent the timer from
					// accidentally deallocating itself before finishing its step, we retained
					// it. Now that step is done, it is safe to release it.
					[elt->currentTimer release];
				}
                
				elt->currentTimer = nil;
			}
		}
        
		// elt, at this moment, is still valid
		// so it is safe to ask this here (issue #490)
		elt = (tHashTimerEntry *)elt->hh.next;
        
		// only delete currentTarget if no actions were scheduled during the cycle (issue #481)
		if( currentTargetSalvaged && [currentTarget->timers count] == 0 )
			[self removeHashElement:currentTarget];
	}
    
    // delete all updates that are morked for deletion
    // updates with priority < 0
	DL_FOREACH_SAFE( updatesNeg, entry, tmp ) {
		if(entry->markedForDeletion )
        {
            [self removeUpdateFromHash:entry];
        }
	}
    
	// updates with priority == 0
	DL_FOREACH_SAFE( updates0, entry, tmp ) {
		if(entry->markedForDeletion )
        {
            [self removeUpdateFromHash:entry];
        }
	}
    
	// updates with priority > 0
	DL_FOREACH_SAFE( updatesPos, entry, tmp ) {
		if(entry->markedForDeletion )
        {
            [self removeUpdateFromHash:entry];
        }
	}
    
    updateHashLocked = NO;
	currentTarget = nil;
}
@end

