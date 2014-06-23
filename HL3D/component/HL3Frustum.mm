//
//  HL3Frustum.m
//  GameEngine
//
//  Created by Tuyuer on 14-6-22.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Frustum.h"

// Indices of the six boundary planes
#define kHL3TopIdx		0
#define kHL3BotmIdx		1
#define kHL3LeftIdx		2
#define kHL3RgtIdx		3
#define kHL3NearIdx		4
#define kHL3FarIdx		5

// Indices of the eight boundary vertices
#define kHL3NearTopLeftIdx	0
#define kHL3NearTopRgtIdx	1
#define kHL3NearBtmLeftIdx	2
#define kHL3NearBtmRgtIdx	3
#define kHL3FarTopLeftIdx	4
#define kHL3FarTopRgtIdx	5
#define kHL3FarBtmLeftIdx	6
#define kHL3FarBtmRgtIdx	7

@implementation HL3Frustum
@synthesize camera = _camera;
@synthesize top=_top, bottom=_bottom, left=_left, right=_right, near=_near, far=_far;
@synthesize isUsingParallelProjection = _isUsingParallelProjection;

-(HL3Plane) topPlane { return planes[kHL3TopIdx]; }
-(HL3Plane) bottomPlane { return planes[kHL3BotmIdx]; }
-(HL3Plane) leftPlane { return planes[kHL3LeftIdx]; }
-(HL3Plane) rightPlane { return planes[kHL3RgtIdx]; }
-(HL3Plane) nearPlane { return planes[kHL3NearIdx]; }
-(HL3Plane) farPlane { return planes[kHL3FarIdx]; }

-(HL3Vector) nearTopLeft { return vertices[kHL3NearTopLeftIdx]; }
-(HL3Vector) nearTopRight { return vertices[kHL3NearTopRgtIdx]; }
-(HL3Vector) nearBottomLeft { return vertices[kHL3NearBtmLeftIdx]; }
-(HL3Vector) nearBottomRight { return vertices[kHL3NearBtmRgtIdx]; }
-(HL3Vector) farTopLeft { return vertices[kHL3FarTopLeftIdx]; }
-(HL3Vector) farTopRight { return vertices[kHL3FarTopRgtIdx]; }
-(HL3Vector) farBottomLeft { return vertices[kHL3FarBtmLeftIdx]; }
-(HL3Vector) farBottomRight { return vertices[kHL3FarBtmRgtIdx]; }


@end













