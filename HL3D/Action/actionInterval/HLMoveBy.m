//
//  HLMoveBy.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLMoveBy.h"
#import "HLNode.h"
#import "HLTypes.h"

@implementation HLMoveBy

+(id) actionWithDuration: (float) t position: (CGPoint) p
{
	return [[[self alloc] initWithDuration:t position:p ] autorelease];
}

-(id) initWithDuration: (float) t position: (CGPoint) p
{
	if( (self=[super initWithDuration: t]) )
		_positionDelta = p;
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	return [[[self class] allocWithZone: zone] initWithDuration:[self duration] position:_positionDelta];
}

-(void) startWithTarget:(HLNode *)target
{
	[super startWithTarget:target];
	_previousPos = _startPos = [target position];
}

-(HLActionInterval*) reverse
{
	return [[self class] actionWithDuration:_duration position:ccp( -_positionDelta.x, -_positionDelta.y)];
}

-(void) update: (float) t
{
	HLNode *node = (HLNode*)_target;
	[node setPosition: ccpAdd( _startPos, ccpMult(_positionDelta, t))];
}
@end
