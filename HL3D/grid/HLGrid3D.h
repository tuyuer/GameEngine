//
//  HLGrid3D.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGridBase.h"

/**
    HLGrid3D is a 3D grid implementation.
    each vertex has three dimensions:x,y,z
 */

@interface HLGrid3D : HLGridBase{
    GLvoid          *_texCoordinates;
    GLvoid          *_vertices;
    GLvoid          *_originalVertices;
	GLushort        *_indices;
}

/** returns the vertex at a given position */
-(ccVertex3F)vertex:(CGPoint)pos;
/** returns the original (non-transformed) vertex at a given position */
-(ccVertex3F)originalVertex:(CGPoint)pos;
/** sets a new vertex at a given position */
-(void)setVertex:(CGPoint)pos vertex:(ccVertex3F)vertex;

@end
