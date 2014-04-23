//
//  HLMD2Animation.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLMD2Animation : NSObject{
    int _startFrame;
	int _endFrame;
    int _currentFrame;
    float _aniTime;
    bool _bRepeat;
    NSTimer * _timer;
}
@property (nonatomic,assign) int currentFrame;
@property (nonatomic,assign) int startFrame;
@property (nonatomic,assign) int endFrame;
@property (nonatomic,assign) float aniTime;
@property (nonatomic,assign) bool bRepeat;

+ (id)animationWith:(int)startFrame endFrame:(int)endFrame duration:(float)duration;
- (id)initWith:(int)startFrame endFrame:(int)endFrame duration:(float)duration;
- (void)reset;
- (void)startUpdate;
- (void)stopUpdate;

@end


