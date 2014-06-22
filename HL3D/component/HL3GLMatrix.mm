//
//  HL3GLMatrix.m
//  GameEngine
//
//  Created by Tuyuer on 14-6-22.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3GLMatrix.h"

@implementation HL3GLMatrix
@synthesize isIdentity;

/**
 * Abstract class simply returns NULL.
 * Subclasses will provide concrete access to the appropriate structure.
 */
-(GLfloat*) glMatrix { return NULL; }

// Setting this property is ignored. Subclasses that permit this may override.
-(void) setGlMatrix: (GLfloat*) aGLMtx {}

@end
