//
//  HL3Layer.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Node.h"
#import "HLLayer.h"
#import "HLNode.h"
@class HL3Scene;
@interface HL3Layer : HLLayer{
    HL3Scene        *_hl3Scene;
}
@property (nonatomic,assign) HL3Scene        *hl3Scene;
+ (id)layer;

/*
 * 根据HL3Layer的尺寸来更新3Scene实例viewport
 */
- (void)updateViewport;
@end
