//
//  HLActionInterval.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLActionInterval.h"

@implementation HLActionInterval
@synthesize elapsed = _elapsed;


-(id) init
{
	NSAssert(NO, @"IntervalActionInit: Init not supported. Use InitWithDuration");
	[self release];
	return nil;
}

+(id) actionWithDuration: (float) d
{
	return [[[self alloc] initWithDuration:d ] autorelease];
}

-(id) initWithDuration: (float) d
{
	if( (self=[super init]) ) {
		_duration = d;
        
		// prevent division by 0
		// This comparison could be in step:, but it might decrease the performance
		// by 3% in heavy based action games.
		if( _duration == 0 )
			_duration = FLT_EPSILON;
		_elapsed = 0;
		_firstTick = YES;
	}
	return self;
}


-(id) copyWithZone: (NSZone*) zone
{
	HLAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] ];
	return copy;
}

- (BOOL) isDone
{
	return (_elapsed >= _duration);
}

-(void) step: (float) dt
{
	if( _firstTick ) {
		_firstTick = NO;
		_elapsed = 0;
	} else
		_elapsed += dt;
    
    
	[self update: MAX(0,					// needed for rewind. elapsed could be negative
					  MIN(1, _elapsed/
						  MAX(_duration,FLT_EPSILON)	// division by 0
						  )
					  )
	 ];
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	_elapsed = 0.0f;
	_firstTick = YES;
}

- (HLActionInterval*) reverse
{
	NSAssert(NO, @"CCIntervalAction: reverse not implemented.");
	return nil;
}


@end
