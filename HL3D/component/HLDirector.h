//
//  HLDirector.h
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLEGLView.h"
#import "HLScene.h"

/** @typedef ccDirectorProjection
 Possible OpenGL projections used by director
 */
typedef enum {
	/// sets a 2D projection (orthogonal projection).
	kCCDirectorProjection2D,
    
	/// sets a 3D projection with a fovy=60, znear=0.5f and zfar=1500.
	kCCDirectorProjection3D,
    
	/// it calls "updateProjection" on the projection delegate.
	kCCDirectorProjectionCustom,
    
	/// Detault projection is 3D projection
	kCCDirectorProjectionDefault = kCCDirectorProjection3D,
    
} hlDirectorProjection;

@interface HLDirector : NSObject{
    HLEGLView * _openglView;
    CGSize _winSizeInPixels;
    
    //running scene
    HLScene * _runningScene;
    HLScene * _nextScene;
    
    //all scenes
    NSMutableArray * _sceneStack;
    
    /* projection used */
	hlDirectorProjection _projection;
    
    id displayLink;
}
@property (nonatomic,readwrite) hlDirectorProjection projection;
+ (HLDirector *)sharedDirector;
- (CGSize)winSize;
- (void)setOpenGLView:(HLEGLView *)view;
- (void)startAnimation;
- (void)runWithScene:(HLScene*)scene;
-(float)getZEye;
@end
