//
//  HLGrud3DAction.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGrid3DAction.h"

@implementation HLGrid3DAction

-(HLGridBase *)grid
{
	return [HLGrid3D gridWithSize:_gridSize];
}

-(ccVertex3F)vertex:(CGPoint)pos
{
	HLGrid3D *g = (HLGrid3D *)[_target grid];
	return [g vertex:pos];
}

-(ccVertex3F)originalVertex:(CGPoint)pos
{
	HLGrid3D *g = (HLGrid3D *)[_target grid];
	return [g originalVertex:pos];
}

-(void)setVertex:(CGPoint)pos vertex:(ccVertex3F)vertex
{
	HLGrid3D *g = (HLGrid3D *)[_target grid];
	[g setVertex:pos vertex:vertex];
}


@end
