//
//  HLGrud3DAction.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGridAction.h"
#import "HLTypes.h"
#import "HLGrid3D.h"


/**
    base class for HLGrid3D actions
    HLGrid3D actions can modify a non-tiled grid
 */
@interface HLGrid3DAction : HLGridAction{

}

/* return the vertex that belongs to certain position in the grid*/
- (ccVertex3F)vertex:(CGPoint)position;

/** return the non-transformed vertex that belongs to certain position in the grid*/
- (ccVertex3F)originalVertex:(CGPoint)position;

/** sest a new vertex to a certain position of the grid*/
-(void)setVertex:(CGPoint)position vertex:(ccVertex3F)vertex;

@end
