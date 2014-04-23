//
//  HLMD2Animation.cpp
//  GameEngine
//
//  Created by huxiaozhou on 14-4-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLMD2Animation.h"
@implementation HLMD2Animation
@synthesize currentFrame = _currentFrame;
@synthesize startFrame = _startFrame;
@synthesize endFrame = _endFrame;
@synthesize aniTime = _aniTime;
@synthesize bRepeat = _bRepeat;


+ (id)animationWith:(int)startFrame endFrame:(int)endFrame duration:(float)duration{
    return [[[self alloc] initWith:startFrame endFrame:endFrame duration:duration] autorelease];
}

- (id)initWith:(int)startFrame endFrame:(int)endFrame duration:(float)duration{
    if(self = [super init]){
        _startFrame = startFrame;
        _endFrame = endFrame;
        _aniTime = duration;
        _currentFrame = 0;
        _bRepeat = false;
    }
    return self;
}

- (void)reset{
    _currentFrame = 0;
}

- (void)update:(NSTimer *)theTimer{

    _currentFrame += 1 ;
    if (_currentFrame > _endFrame) {
        if (_bRepeat) {
            _currentFrame = 0;
        }else{
            _currentFrame = _endFrame;
            [self stopUpdate];
        }
    }
}

- (void)startUpdate{
    [self reset];
    _timer = [NSTimer scheduledTimerWithTimeInterval:(_aniTime/(_endFrame-_startFrame)) target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [_timer retain];
}

- (void)stopUpdate{
    [_timer invalidate];
    [_timer release];
    _timer = nil;
}

@end


















