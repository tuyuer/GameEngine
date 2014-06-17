//
//  HLWave3D.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-16.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//-

#import "HLWave3D.h"

@implementation HLWave3D

@synthesize amplitude=_amplitude;
@synthesize amplitudeRate=_amplitudeRate;

+(id)actionWithDuration:(float)duration size:(CGSize)gridSize waves:(NSUInteger)wav amplitude:(float)amp
{
	return [[[self alloc] initWithDuration:duration size:gridSize waves:wav amplitude:amp] autorelease];
}

-(id)initWithDuration:(float)duration size:(CGSize)gridSize waves:(NSUInteger)wav amplitude:(float)amp
{
	if ( (self = [super initWithDuration:duration size:gridSize]) )
	{
		_waves = wav;
		_amplitude = amp;
		_amplitudeRate = 1.0f;
	}
    
	return self;
}

-(void)update:(float)time
{
	int i, j;
    
	for( i = 0; i < (_gridSize.width+1); i++ )
	{
		for( j = 0; j < (_gridSize.height+1); j++ )
		{
			ccVertex3F	v = [self originalVertex:ccp(i,j)];
			v.z += (sinf((CGFloat)M_PI*time*_waves*2 + (v.y+v.x) * .01f) * _amplitude * _amplitudeRate);
            [self setVertex:ccp(i,j) vertex:v];
		}
	}
}


@end
