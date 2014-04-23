//
//  HLScene.m
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLScene.h"
#import "HLDirector.h"
@implementation HLScene

+ (id)scene{
    return [[[self alloc] init] autorelease];
}

- (id)init{
	if((self=[super init]) ) {
		CGSize s = [[HLDirector sharedDirector] winSize];
        
        self.ignoreAnchorPointForPosition = YES;
        _anchorPoint = CGPointMake(0.5, 0.5);
		[self setContentSize:s];
	}
	
	return self;
}
@end
