//
//  HLSequence.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLSequence.h"

@implementation HLSequence

+(id) actions: (HLFiniteTimeAction*) action1, ...
{
	va_list args;
	va_start(args, action1);
    
	id ret = [self actions:action1 vaList:args];
    
	va_end(args);
    
	return  ret;
}

+(id) actions: (HLFiniteTimeAction*) action1 vaList:(va_list)args
{
	HLFiniteTimeAction *now;
	HLFiniteTimeAction *prev = action1;
	
	while( action1 ) {
		now = va_arg(args,HLFiniteTimeAction*);
		if ( now )
			prev = [self actionOne: prev two: now];
		else
			break;
	}
    
	return prev;
}


+(id) actionWithArray: (NSArray*) actions
{
	HLFiniteTimeAction *prev = [actions objectAtIndex:0];
	
	for (NSUInteger i = 1; i < [actions count]; i++)
		prev = [self actionOne:prev two:[actions objectAtIndex:i]];
	
	return prev;
}

+(id) actionOne: (HLFiniteTimeAction*) one two: (HLFiniteTimeAction*) two
{
	return [[[self alloc] initOne:one two:two ] autorelease];
}

-(id) initOne: (HLFiniteTimeAction*) one two: (HLFiniteTimeAction*) two
{
	NSAssert( one!=nil && two!=nil, @"Sequence: arguments must be non-nil");
	NSAssert( one!=_actions[0] && one!=_actions[1], @"Sequence: re-init using the same parameters is not supported");
	NSAssert( two!=_actions[1] && two!=_actions[0], @"Sequence: re-init using the same parameters is not supported");
	
	float d = [one duration] + [two duration];
	
	if( (self=[super initWithDuration: d]) ) {
		
		// XXX: Supports re-init without leaking. Fails if one==_one || two==_two
		[_actions[0] release];
		[_actions[1] release];
		
		_actions[0] = [one retain];
		_actions[1] = [two retain];
	}
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HLAction *copy = [[[self class] allocWithZone:zone] initOne:[[_actions[0] copy] autorelease] two:[[_actions[1] copy] autorelease] ];
	return copy;
}

-(void) dealloc
{
	[_actions[0] release];
	[_actions[1] release];
	[super dealloc];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	_split = [_actions[0] duration] / MAX(_duration, FLT_EPSILON);
	_last = -1;
}

-(void) stop
{
	// Issue #1305
	if( _last != - 1)
		[_actions[_last] stop];
    
	[super stop];
}

-(void) update: (float) t
{
    
	int found = 0;
	float new_t = 0.0f;
	
	if( t < _split ) {
		// action[0]
		found = 0;
		if( _split != 0 )
			new_t = t / _split;
		else
			new_t = 1;
        
	} else {
		// action[1]
		found = 1;
		if ( _split == 1 )
			new_t = 1;
		else
			new_t = (t-_split) / (1 - _split );
	}
	
	if ( found==1 ) {
		
		if( _last == -1 ) {
			// action[0] was skipped, execute it.
			[_actions[0] startWithTarget:_target];
			[_actions[0] update:1.0f];
			[_actions[0] stop];
		}
		else if( _last == 0 )
		{
			// switching to action 1. stop action 0.
			[_actions[0] update: 1.0f];
			[_actions[0] stop];
		}
	}
	else if(found==0 && _last==1 )
	{
		// Reverse mode ?
		// XXX: Bug. this case doesn't contemplate when _last==-1, found=0 and in "reverse mode"
		// since it will require a hack to know if an action is on reverse mode or not.
		// "step" should be overriden, and the "reverseMode" value propagated to inner Sequences.
		[_actions[1] update:0];
		[_actions[1] stop];
	}
	
	// Last action found and it is done.
	if( found == _last && [_actions[found] isDone] ) {
		return;
	}
    
	// New action. Start it.
	if( found != _last )
		[_actions[found] startWithTarget:_target];
	
	[_actions[found] update: new_t];
	_last = found;
}

- (HLActionInterval *) reverse
{
	return [[self class] actionOne: [_actions[1] reverse] two: [_actions[0] reverse ] ];
}


@end
