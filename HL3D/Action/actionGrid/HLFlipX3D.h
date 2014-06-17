//
//  HLFlipX3D.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-17.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGrid3DAction.h"

@interface HLFlipX3D : HLGrid3DAction{
    
}

/** creates the action with duration */
+(id) actionWithDuration:(float)d;
/** initializes the action with duration */
-(id) initWithDuration:(float)d;

@end
