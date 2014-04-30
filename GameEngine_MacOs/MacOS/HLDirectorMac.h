//
//  HLDirectorMac.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-28.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLGLView.h"
@interface HLDirectorMac : NSObject{
    HLGLView * _openglView;
    CGSize _winSizeInPixels;
}

@end
