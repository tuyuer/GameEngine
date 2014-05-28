//
//  HLScaleTo.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLScaleTo.h"
#import "HLNode.h"

@implementation HLScaleTo

+(id) actionWithDuration: (float) t scale:(float) s
{
	return [[[self alloc] initWithDuration: t scale:s] autorelease];
}

-(id) initWithDuration: (float) t scale:(float) s
{
	if( (self=[super initWithDuration: t]) ) {
		_endScaleX = s;
		_endScaleY = s;
	}
	return self;
}

+(id) actionWithDuration: (float) t scaleX:(float)sx scaleY:(float)sy
{
	return [[[self alloc] initWithDuration: t scaleX:sx scaleY:sy] autorelease];
}

-(id) initWithDuration: (float) t scaleX:(float)sx scaleY:(float)sy
{
	if( (self=[super initWithDuration: t]) ) {
		_endScaleX = sx;
		_endScaleY = sy;
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	HLAction *copy = [[[self class] allocWithZone: zone] initWithDuration:[self duration] scaleX:_endScaleX scaleY:_endScaleY];
	return copy;
}

-(void) startWithTarget:(HLNode *)aTarget
{
	[super startWithTarget:aTarget];
	_startScaleX = [_target scaleX];
	_startScaleY = [_target scaleY];
	_deltaX = _endScaleX - _startScaleX;
	_deltaY = _endScaleY - _startScaleY;
}

-(void) update: (float) t
{
	[_target setScaleX: (_startScaleX + _deltaX * t ) ];
	[_target setScaleY: (_startScaleY + _deltaY * t ) ];
}


@end
