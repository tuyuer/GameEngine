//
//  HLScaleTo.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLActionInterval.h"

@interface HLScaleTo : HLActionInterval <NSCopying>{
	float _scaleX;
	float _scaleY;
	float _startScaleX;
	float _startScaleY;
	float _endScaleX;
	float _endScaleY;
	float _deltaX;
	float _deltaY;
}

/** creates the action with the same scale factor for X and Y */
+(id) actionWithDuration: (float)duration scale:(float) s;
/** initializes the action with the same scale factor for X and Y */
-(id) initWithDuration: (float)duration scale:(float) s;
/** creates the action with and X factor and a Y factor */
+(id) actionWithDuration: (float)duration scaleX:(float) sx scaleY:(float)sy;
/** initializes the action with and X factor and a Y factor */
-(id) initWithDuration: (float)duration scaleX:(float) sx scaleY:(float)sy;

@end
