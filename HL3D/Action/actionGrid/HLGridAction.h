//
//  HLGridAction.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLActionInterval.h"
#import "HLGridBase.h"

@interface HLGridAction : HLActionInterval{
    CGSize _gridSize;
}

/* size of the grid*/
@property (nonatomic,readwrite) CGSize gridSize;

/* creates the action with size and duration */
+ (id)actionWithDuration:(float)d size:(CGSize)gridSize;

/* initializes the action with size and duration*/
- (id)initWithDuration:(float)d size:(CGSize)gridSize;

/* returns the grid */
- (HLGridBase*)grid;

@end
