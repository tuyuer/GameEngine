//
//  HLMoveTo.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-27.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLMoveTo.h"
#import "HLNode.h"

@implementation HLMoveTo

+(id) actionWithDuration: (float) t position: (CGPoint) p
{
	return [[[self alloc] initWithDuration:t position:p ] autorelease];
}

-(id) initWithDuration: (float) t position: (CGPoint) p
{
	if( (self=[super initWithDuration: t]) ) {
		_endPosition = p;
    }
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HLAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] position: _endPosition];
	return copy;
}

-(void) startWithTarget:(HLNode *)aTarget
{
	[super startWithTarget:aTarget];
	_positionDelta = ccpSub( _endPosition, [(HLNode*)_target position] );
}


@end
