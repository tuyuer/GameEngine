//
//  HLWave3D.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-16.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGrid3DAction.h"

@interface HLWave3D : HLGrid3DAction{

    NSUInteger _waves;
    float _amplitude;
    float _amplitudeRate;
}

/* amplitude of the wave */
@property(nonatomic,readwrite) float amplitude;
/* amplitude rate of the wave */
@property(nonatomic,readwrite) float amplitudeRate;

/** creates an action with duration, grid size, waves and amplitud */
+(id)actionWithDuration:(float)duration size:(CGSize)gridSize waves:(NSUInteger)wav amplitude:(float)amp;
/** initializeds an action with duration, grid size, waves and amplitud */
-(id)initWithDuration:(float)duration size:(CGSize)gridSize waves:(NSUInteger)wav amplitude:(float)amp;

@end
