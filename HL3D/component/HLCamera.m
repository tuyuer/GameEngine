//
//  HLCamera.m
//  GameEngine
//
//  Created by tuyuer on 14-4-10.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLCamera.h"
#import "kazmath/GL/matrix.h"
#import "kazmath.h"

@implementation HLCamera
@synthesize dirty = _dirty;

- (id)init
{
	if( (self=[super init]) )
		[self restore];
    
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %p | center = (%.2f,%.2f,%.2f)>", [self class], self, _centerX, _centerY, _centerZ];
}

- (void) dealloc
{
	[super dealloc];
}

- (void) restore
{
	_eyeX = _eyeY = 0;
	_eyeZ = [HLCamera getZEye];
    
	_centerX = _centerY = _centerZ = 0;
    
	_upX = 0.0f;
	_upY = 1.0f;
	_upZ = 0.0f;
    
	kmMat4Identity( &_lookupMatrix );
    
	_dirty = NO;
}

- (void)locate
{
	if( _dirty ) {
        
		kmVec3 eye, center, up;
        
		kmVec3Fill( &eye, _eyeX, _eyeY , _eyeZ );
		kmVec3Fill( &center, _centerX, _centerY, _centerZ );
        
		kmVec3Fill( &up, _upX, _upY, _upZ);
		kmMat4LookAt( &_lookupMatrix, &eye, &center, &up);
        
		_dirty = NO;
        
	}
    
	kmGLMultMatrix( &_lookupMatrix );
}

+ (float)getZEye
{
	return FLT_EPSILON;
}


- (void)setEyeX: (float)x eyeY:(float)y eyeZ:(float)z
{
	_eyeX = x;
	_eyeY = y;
	_eyeZ = z;
    
	_dirty = YES;
}

-(void) setCenterX: (float)x centerY:(float)y centerZ:(float)z
{
	_centerX = x;
	_centerY = y;
	_centerZ = z;
    
	_dirty = YES;
}

-(void) setUpX: (float)x upY:(float)y upZ:(float)z
{
	_upX = x;
	_upY = y;
	_upZ = z;
    
	_dirty = YES;
}

-(void) eyeX: (float*)x eyeY:(float*)y eyeZ:(float*)z
{
	*x = _eyeX;
	*y = _eyeY;
	*z = _eyeZ;
}

-(void) centerX: (float*)x centerY:(float*)y centerZ:(float*)z
{
	*x = _centerX;
	*y = _centerY;
	*z = _centerZ;
}

-(void) upX: (float*)x upY:(float*)y upZ:(float*)z
{
	*x = _upX;
	*y = _upY;
	*z = _upZ;
}


@end
















