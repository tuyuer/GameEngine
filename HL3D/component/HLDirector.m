//
//  HLDirector.m
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLDirector.h"
#import "kazmath/GL/matrix.h"
#import "kazmath.h"
#import <QuartzCore/QuartzCore.h>

@implementation HLDirector
@synthesize projection = _projection;
@synthesize scheduler = _scheduler;
@synthesize actionManager = _actionManager;

static HLDirector * s_sharedDirector = nil;
+ (HLDirector *)sharedDirector{
    if (!s_sharedDirector) {
        s_sharedDirector = [[self alloc] init];
    }
    return s_sharedDirector;
}

- (id)init{
    if (self = [super init]) {
        
        _sceneStack = [[NSMutableArray alloc] initWithCapacity:100];
        
        _openglView = nil;
        _runningScene = nil;
        _nextScene = nil;
        
        // scheduler
		_scheduler = [[HLScheduler alloc] init];
        
        _actionManager = [[HLActionManager alloc] init];
        [_scheduler scheduleUpdateForTarget:_actionManager priority:kHLPrioritySystem paused:NO];
        
        return self;
    }
    return nil;
}

- (void)dealloc{
    [_sceneStack release];
    [_openglView release];
    [_scheduler release];
    [_actionManager release];
    [super dealloc];
}

- (CGSize)winSize{
    return _winSizeInPixels;
}

-(float)getZEye{
    return ( _winSizeInPixels.height / 1.1566f  );
}

- (void)setOpenGLView:(HLEGLView *)view{
    NSAssert( view, @"OpenGLView must be non-nil");
    
	if( view != _openglView ) {
		[_openglView release];
		_openglView = [view retain];
		
		// set size
		_winSizeInPixels = [view bounds].size;
	}
}

-(void) setViewport{
	CGSize size = _winSizeInPixels;
	glViewport(0, 0, size.width, size.height );
}

-(void) setProjection:(hlDirectorProjection)projection{
    CGSize size = _winSizeInPixels;
    CGSize sizePoint = _winSizeInPixels;
    //设置视口
    [self setViewport];
    
    switch (projection) {
		case kCCDirectorProjection2D:
            
			kmGLMatrixMode(KM_GL_PROJECTION);
			kmGLLoadIdentity();
            
			kmMat4 orthoMatrix;
			kmMat4OrthographicProjection(&orthoMatrix, 0, size.width, 0, size.height, -1024, 1024 );
			kmGLMultMatrix( &orthoMatrix );
            
			kmGLMatrixMode(KM_GL_MODELVIEW);
			kmGLLoadIdentity();
			break;
        case kCCDirectorProjection3D:{
            float zeye = [self getZEye];
            
			kmMat4 matrixPerspective, matrixLookup;
            
			kmGLMatrixMode(KM_GL_PROJECTION);
			kmGLLoadIdentity();
            
			// issue #1334
			kmMat4PerspectiveProjection( &matrixPerspective, 60, (GLfloat)size.width/size.height, 0.91f, zeye*2000);
			kmGLMultMatrix(&matrixPerspective);
            
			kmGLMatrixMode(KM_GL_MODELVIEW);
			kmGLLoadIdentity();
			kmVec3 eye, center, up;
			kmVec3Fill( &eye, sizePoint.width/2, sizePoint.height/2, zeye );
			kmVec3Fill( &center, sizePoint.width/2, sizePoint.height/2, 0 );
			kmVec3Fill( &up, 0, 1, 0);
			kmMat4LookAt(&matrixLookup, &eye, &center, &up);
			kmGLMultMatrix(&matrixLookup);
        }
            break;
		default:
			NSLog(@"cocos2d: Director: unrecognized projection");
			break;
	}
    
	_projection = projection;

}

- (void)startAnimation{
    displayLink = [CADisplayLink displayLinkWithTarget:self
                                              selector:@selector(mainLoop:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
}

- (void)runWithScene:(HLScene*)scene{
    NSAssert( scene != nil, @"Argument must be non-nil");
	NSAssert( _runningScene == nil, @"You can't run an scene if another Scene is running. Use replaceScene or pushScene instead");
    
    [self pushScene:scene];
    [self startAnimation];
}

- (void)pushScene:(HLScene*)scene{
    NSAssert( scene != nil, @"Argument must be non-nil");
    [_sceneStack addObject: scene];
    _nextScene = scene;
}

-(void) setNextScene
{
	[_runningScene release];

	_runningScene = [_nextScene retain];
	_nextScene = nil;
    
    //
    [_runningScene onEnter];
    [_runningScene onEnterTransitionDidFinish];
}

- (void) mainLoop:(id)sender{
	[self drawScene];
}

-(void) calculateDeltaTime
{
	struct timeval now;
    
	if( gettimeofday( &now, NULL) != 0 ) {
		_dt = 0;
		return;
	}
    
	// new delta time
	if( _nextDeltaTimeZero ) {
		_dt = 0;
		_nextDeltaTimeZero = NO;
	} else {
		_dt = (now.tv_sec - _lastUpdate.tv_sec) + (now.tv_usec - _lastUpdate.tv_usec) / 1000000.0f;
		_dt = MAX(0,_dt);
    }
    
	_lastUpdate = now;
}


- (void)drawScene{
    
    /* calculate "global" dt */
	[self calculateDeltaTime];
    
    //更新scheduler
    [_scheduler update: _dt];
    
    [EAGLContext setCurrentContext:[_openglView esContext]];
    
    glClearColor(0.5f, 0.5f, 0.5f, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
   
    if (_nextScene) {
        [self setNextScene];
    }
    //清理背景
    kmGLPushMatrix();
    
    //遍历节点
    [_runningScene visit];
   
    kmGLPopMatrix();
    
    [_openglView swapBuffers];
}
@end






