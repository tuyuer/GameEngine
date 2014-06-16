//
//  HLScaleBy.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLScaleBy.h"

@implementation HLScaleBy
-(void) startWithTarget:(HLNode *)aTarget
{
	[super startWithTarget:aTarget];
	_deltaX = _startScaleX *(_startScaleX + _endScaleX) - _startScaleX;
	_deltaY = _startScaleY * (_startScaleY + _endScaleY) - _startScaleY;
}

-(HLActionInterval*)reverse
{
	return [[self class] actionWithDuration:_duration scaleX:1/_endScaleX scaleY:1/_endScaleY];
}
@end
