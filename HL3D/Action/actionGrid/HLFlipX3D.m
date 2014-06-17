//
//  HLFlipX3D.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-17.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLFlipX3D.h"

@implementation HLFlipX3D

+(id) actionWithDuration:(float)d
{
	return [[[self alloc] initWithDuration:d size:CGSizeMake(1,1)] autorelease];
}

-(id) initWithDuration:(float)d
{
	return [super initWithDuration:d size:CGSizeMake(1,1)];
}

-(id)initWithSize:(CGSize)gSize duration:(float)d
{
	if ( gSize.width != 1 || gSize.height != 1 )
	{
		[NSException raise:@"FlipX3D" format:@"Grid size must be (1,1)"];
	}
    
	return [super initWithDuration:d size:gSize];
}




-(void)update:(float)time
{
	CGFloat angle = (CGFloat)M_PI * time; // 180 degrees
	CGFloat mz = sinf( angle );
	angle = angle / 2.0f;     // x calculates degrees from 0 to 90
	CGFloat mx = cosf( angle );
    
	ccVertex3F	v0, v1, v, diff;
    
	v0 = [self originalVertex:ccp(1,1)];
	v1 = [self originalVertex:ccp(0,0)];
    
	CGFloat	x0 = v0.x;
	CGFloat	x1 = v1.x;
	CGFloat x;
	CGPoint	a, b, c, d;
    
	if ( x0 > x1 )
	{
		// Normal Grid
		a = ccp(0,0);
		b = ccp(0,1);
		c = ccp(1,0);
		d = ccp(1,1);
		x = x0;
	}
	else
	{
		// Reversed Grid
		c = ccp(0,0);
		d = ccp(0,1);
		a = ccp(1,0);
		b = ccp(1,1);
		x = x1;
	}
    
	diff.x = ( x - x * mx );
	diff.z = fabsf( floorf( (x * mz) / 4.0f ) );
    
    // bottom-left
	v = [self originalVertex:a];
	v.x = diff.x;
	v.z += diff.z;
	[self setVertex:a vertex:v];
    
    // upper-left
	v = [self originalVertex:b];
	v.x = diff.x;
	v.z += diff.z;
	[self setVertex:b vertex:v];
    
    // bottom-right
	v = [self originalVertex:c];
	v.x -= diff.x;
	v.z -= diff.z;
	[self setVertex:c vertex:v];
    
    // upper-right
	v = [self originalVertex:d];
	v.x -= diff.x;
	v.z -= diff.z;
	[self setVertex:d vertex:v];
}


@end
