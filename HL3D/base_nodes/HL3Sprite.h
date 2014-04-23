//
//  HL3Sprite.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-14.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Node.h"
#import "HLMD2.h"
#import "HLMD2Animation.h"

@interface HL3Sprite : HL3Node{
    HL3Model * _model;
    bool _bIsAnimation;
    HLMD2Animation * _runningAnimation;
}

+ (id)spriteWithFile:(NSString*)strFileName;
- (id)initWithFile:(NSString*)strFileName;
- (void)runMD2Action:(HLMD2Animation*)md2Anim;
- (void)stopMD2Action;
@end
