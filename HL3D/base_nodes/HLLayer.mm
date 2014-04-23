//
//  HLLayer.m
//  GameEngine
//
//  Created by tuyuer on 14-4-4.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLLayer.h"
#import "HLDirector.h"

@implementation HLLayer

- (id)init{
    if (self = [super init]) {
        
        CGSize s = [[HLDirector sharedDirector] winSize];
		_anchorPoint = CGPointMake(0.5f, 0.5f);
		[self setContentSize:s];
		self.ignoreAnchorPointForPosition = YES;
        
        return self;
    }
    return nil;
}

@end
