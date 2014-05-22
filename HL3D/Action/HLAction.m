//
//  HLAction.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLAction.h"

@implementation HLAction
@synthesize tag = _tag;
@synthesize target = _target;
@synthesize originalTarget = _originalTarget;

-(id) copyWithZone: (NSZone*) zone
{
	HLAction *copy = [[[self class] allocWithZone: zone] init];
	copy.tag = _tag;
	return copy;
}

-(void) dealloc
{
	NSLog(@"cocos2d: deallocing %@", self);
	[super dealloc];
}

+(id) action
{
	return [[[self alloc] init] autorelease];
}

-(id) init
{
	if( (self=[super init]) ) {
		_originalTarget = _target = nil;
		_tag = kHLActionTagInvalid;
	}
	return self;
}

-(void) startWithTarget:(id)aTarget
{
	_originalTarget = _target = aTarget;
}

-(void) stop
{
	_target = nil;
}

-(void) step: (float) dt
{
	NSLog(@"[Action step]. override me");
}

-(void) update: (float) time
{
	NSLog(@"[Action update]. override me");
}

-(BOOL) isDone
{
	return YES;
}


@end
