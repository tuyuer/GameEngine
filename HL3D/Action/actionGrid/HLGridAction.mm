//
//  HLGridAction.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGridAction.h"

@implementation HLGridAction
@synthesize gridSize = _gridSize;

/* creates the action with size and duration */
+ (id)actionWithDuration:(float)d size:(CGSize)gridSize{
    return [[[self alloc] initWithDuration:d size:gridSize] autorelease];
}

/* initializes the action with size and duration*/
- (id)initWithDuration:(float)d size:(CGSize)gridSize{
    if ( self = [super initWithDuration:d] ) {
        _gridSize = gridSize;
    }
    return self;
}

- (void)startWithTarget:(id)target{
    [super startWithTarget:target];
    
    HLGridBase * newGrid = [self grid];
    
    HLNode *t = (HLNode*)target;
    HLGridBase * targetGrid = [t grid];

    if (targetGrid && targetGrid.reuseGrid > 0 ) {
        if ( targetGrid.active && targetGrid.gridSize.width == _gridSize.width &&
            targetGrid.gridSize.height == _gridSize.height &&
            [targetGrid isKindOfClass:[newGrid class]]) {
            [targetGrid reuse];
        }else{
            [NSException raise:@"GridBase" format:@"Cannot reuse grid"];
        }
    }else{
        if (targetGrid && targetGrid.active) {
            targetGrid.active = NO;
        }
        [t setGrid:newGrid];
        t.grid.active = YES;
    }
}

/* returns the grid */
- (HLGridBase*)grid{
    [NSException raise:@"GridBase" format:@"Abstract class needs implementation"];
	return nil;
}

@end














