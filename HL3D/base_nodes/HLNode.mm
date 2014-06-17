//
//  HLNode.m
//  GameEngine
//
//  Created by tuyuer on 14-3-24.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLNode.h"
#import "kazmath.h"
#import "kazmath/GL/matrix.h"
#import "TransformUtils.h"
#import "HLSprite.h"
#import "ccMacros.h"
#import "HLDirector.h"
#import "HLGridBase.h"

@implementation HLNode

// XXX: Yes, nodes might have a sort problem once every 15 days if the game runs at 60 FPS and each frame sprites are reordered.
static NSUInteger globalOrderOfArrival = 1;

@synthesize contentSize = _contentSize;
@synthesize shaderProgram = _shaderProgram;
@synthesize anchorPoint = _anchorPoint;
@synthesize anchorPointInPoints = _anchorPointInPoints;
@synthesize position = _position;
@synthesize parent = _parent;
@synthesize tag = _tag;
@synthesize zOrder = _zOrder;
@synthesize orderOfArrival = _orderOfArrival;
@synthesize ignoreAnchorPointForPosition = _ignoreAnchorPointForPosition;
@synthesize rotationX = _rotationX, rotationY = _rotationY;
@synthesize scaleX = _scaleX, scaleY = _scaleY;
@synthesize skewX = _skewX, skewY = _skewY;
@synthesize scheduler = _scheduler;
@synthesize blendFunc = _blendFunc;
@synthesize grid = _grid;

+ (id)node{
    return [[[self alloc] init] autorelease];
}

- (void)dealloc{
    [m_pChildren release];
    [_camera release];
    [_scheduler release];
    [_grid release];
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {
        
        _rotationX = _rotationY = 0;
        
        //缩放
        _scaleX = _scaleY = 1.0;
        
        _position = CGPointZero;
        _contentSize = CGSizeZero;
        
        //anchor point
        _anchorPoint = CGPointZero;
        _anchorPointInPoints = CGPointZero;
        
        _tag = 0;
        _zOrder = 0;
        _parent = nil;
        _orderOfArrival = 0;
        
        _isReorderChildDirty = NO;
        _isRunning = NO;
        _ignoreAnchorPointForPosition = NO;
        _isTransformDirty = _isInverseDirty = YES;
        
        m_pChildren = [[NSMutableArray alloc] initWithCapacity:100];
        _camera = nil;
        _grid = nil;
        
        _blendFunc.src = GL_ONE;
		_blendFunc.dst = GL_ONE_MINUS_SRC_ALPHA;
        
        self.actionManager = [[HLDirector sharedDirector] actionManager];
        self.scheduler = [[HLDirector sharedDirector] scheduler];
        return self;
    }
    return nil;
}

-(void) setScheduler:(HLScheduler *)scheduler
{
	if( scheduler != _scheduler ) {
		[self unscheduleAllSelectors];
		[_scheduler release];
        
		_scheduler = [scheduler retain];
	}
}

-(void) setActionManager:(HLActionManager *)actionManager
{
	if( actionManager != _actionManager ) {
//		[self stopAllActions];
		[_actionManager release];
        
		_actionManager = [actionManager retain];
	}
}

-(HLActionManager*) actionManager
{
	return _actionManager;
}

// camera: lazy alloc
-(HLCamera*) camera
{
	if( ! _camera ) {
		_camera = [[HLCamera alloc] init];
	}
    
	return _camera;
}


-(void) reorderChild:(HLNode*) child z:(NSInteger)z
{
	NSAssert( child != nil, @"Child must be non-nil");
    
	_isReorderChildDirty = YES;
    
	[child setOrderOfArrival: globalOrderOfArrival++];
	[child _setZOrder:z];
}

- (void)insertChild:(HLNode*)child z:(NSInteger)z{
    _isReorderChildDirty = YES;
    
    [m_pChildren addObject:child];
    [child setZOrder:z];
}

- (void)_setZOrder:(NSInteger)zOrder{
    _zOrder = zOrder;
}

- (void)setZOrder:(NSInteger)zOrder{
    [self _setZOrder:zOrder];
    
    if (_parent) {
        [_parent reorderChild:self z:zOrder];
    }
}

- (void)addChild:(HLNode*)child{
    [self addChild:child z:child.zOrder];
}

-(void) addChild:(HLNode*)child z:(NSInteger)z{
    NSAssert( child!= nil, @"child is nil~");
    [self addChild:child z:z tag:child.tag];
}

- (void)addChild:(HLNode*)child z:(NSInteger)z tag:(NSInteger)tag{
    NSAssert( child != nil, @"Argument must be non-nil");
	NSAssert( child.parent == nil, @"child already added. It can't be added again");

    child.tag = tag;
    
    [child setParent:self];
    
    [child setOrderOfArrival:globalOrderOfArrival++];
    
    [self insertChild:child z:z];
    
    if ( _isRunning ) {
        [child onEnter];
        [child onEnterTransitionDidFinish];
    }
}

- (void)sortAllChildren{
    if (_isReorderChildDirty) {
        //对child按zOrder从小到大排序
        for (int i = 0; i< [m_pChildren count]; i++) {
            HLNode * node1 = [m_pChildren objectAtIndex:i];
            for (int j=i+1; j<[m_pChildren count]; j++) {
                HLNode * node2 = [m_pChildren objectAtIndex:j];
                if ([node1 zOrder] > [node2 zOrder]) {
                    [m_pChildren exchangeObjectAtIndex:i withObjectAtIndex:j];
                    node1 = node2;
                }
            }
        }
        
        _isReorderChildDirty = NO;
    }
}

- (void)visit{
    
    kmGLPushMatrix();
    
    if (_grid && _grid.active) {
        [_grid  beforeDraw];
    }
    
    [self transform];
    
    if ([m_pChildren count]> 0) {
        // resort all child
        [self sortAllChildren];
        
        NSUInteger i = 0;
        // draw children zOrder < 0
        for( ; i < [m_pChildren count]; i++ ) {
			HLNode * child = [m_pChildren objectAtIndex:i];
			if ( [child zOrder] < 0 )
				[child visit];
			else
				break;
		}
        
        // self draw
		[self draw];

		// draw children zOrder >= 0
		for(; i < [m_pChildren count]; i++ ) {
			HLNode *child = [m_pChildren objectAtIndex:i];
			[child visit];
		}
    }else{
        [self draw];
    }
    
    _orderOfArrival = 0;
    
    if (_grid && _grid.active) {
        [_grid afterDraw:self];
    }
    
    kmGLPopMatrix();
}

- (void)draw{
    
}

- (void)onEnter{
    [m_pChildren makeObjectsPerformSelector:@selector(onEnter)];
    [_scheduler resumeTarget:self];
    [_actionManager resumeTarget:self];
    _isRunning = YES;
}

- (void)onEnterTransitionDidFinish{

}

- (void)setAnchorPoint:(CGPoint)anchorPoint{
    if (!CGPointEqualToPoint(_anchorPoint, anchorPoint)) {
        _anchorPoint = anchorPoint;
        _anchorPointInPoints = CGPointMake( _contentSize.width * _anchorPoint.x, _contentSize.height * _anchorPoint.y );
        _isTransformDirty = _isInverseDirty = YES;
    }
}

-(void) setContentSize:(CGSize)size
{
	if( ! CGSizeEqualToSize(size, _contentSize) ) {
		_contentSize = size;
		_anchorPointInPoints = CGPointMake( _contentSize.width * _anchorPoint.x, _contentSize.height * _anchorPoint.y );
        _isTransformDirty = _isInverseDirty = YES;
	}
}

- (void)setIgnoreAnchorPointForPosition:(BOOL)newValue{
    if (newValue != _ignoreAnchorPointForPosition) {
        _ignoreAnchorPointForPosition = newValue;
        _isTransformDirty = _isInverseDirty = YES;
    }
}

- (void)setPosition:(CGPoint)newValue {
    _position = newValue;
    _isTransformDirty = _isInverseDirty = YES;
}

- (void)setRotation:(float)newValue{
    _rotationX = _rotationY = newValue;
    _isTransformDirty = _isInverseDirty = YES;
}

- (float)rotation{
    NSAssert(_rotationX == _rotationY, @"CCNode#rotation. RotationX != RotationY. Don't know which one to return");
    return _rotationX;
}

-(void) setRotationX: (float)newX
{
	_rotationX = newX;
	_isTransformDirty = _isInverseDirty = YES;
}

-(void) setRotationY: (float)newY
{
	_rotationY = newY;
	_isTransformDirty = _isInverseDirty = YES;
}


-(void) setScale:(float) s
{
	_scaleX = _scaleY = s;
	_isTransformDirty = _isInverseDirty = YES;
}

-(void) setScaleX: (float)newScaleX
{
	_scaleX = newScaleX;
	_isTransformDirty = _isInverseDirty = YES;
}

-(void) setScaleY: (float)newScaleY
{
	_scaleY = newScaleY;
	_isTransformDirty = _isInverseDirty = YES;
}

-(void) setSkewX:(float)newSkewX
{
	_skewX = newSkewX;
	_isTransformDirty = _isInverseDirty = YES;
}

-(void) setSkewY:(float)newSkewY
{
	_skewY = newSkewY;
	_isTransformDirty = _isInverseDirty = YES;
}

- (CGAffineTransform)nodeToParentTransform{

    if (_isTransformDirty) {
        
        // Translate values
        float x = _position.x;
        float y = _position.y;
        
        if (_ignoreAnchorPointForPosition) {
            x += _anchorPointInPoints.x;
            y += _anchorPointInPoints.y;
        }
        
        // Rotation values
		// Change rotation code to handle X and Y
		// If we skew with the exact same value for both x and y then we're simply just rotating
		float cx = 1, sx = 0, cy = 1, sy = 0;
		if( _rotationX || _rotationY ) {
			float radiansX = -CC_DEGREES_TO_RADIANS(_rotationX);
			float radiansY = -CC_DEGREES_TO_RADIANS(_rotationY);
			cx = cosf(radiansX);
			sx = sinf(radiansX);
			cy = cosf(radiansY);
			sy = sinf(radiansY);
		}
        
        BOOL needsSkewMatrix = ( _skewX || _skewY );
        
		// optimization:
		// inline anchor point calculation if skew is not needed
		// Adjusted transform calculation for rotational skew
		if( !needsSkewMatrix && !CGPointEqualToPoint(_anchorPointInPoints, CGPointZero) ) {
			x += cy * -_anchorPointInPoints.x * _scaleX + -sx * -_anchorPointInPoints.y * _scaleY;
			y += sy * -_anchorPointInPoints.x * _scaleX +  cx * -_anchorPointInPoints.y * _scaleY;
		}
        
        _transform = CGAffineTransformMake(cy * _scaleX, sy * _scaleX, -sx * _scaleY, cx * _scaleY, x, y);
        
        
        if( needsSkewMatrix ) {
			CGAffineTransform skewMatrix = CGAffineTransformMake(1.0f, tanf(CC_DEGREES_TO_RADIANS(_skewY)),
																 tanf(CC_DEGREES_TO_RADIANS(_skewX)), 1.0f,
																 0.0f, 0.0f );
			_transform = CGAffineTransformConcat(skewMatrix, _transform);
		}
        
        _isTransformDirty = NO;
    }
    return _transform;
}

- (void)transform{
    
    kmMat4 transfrom4x4;

    //Convert 3x3 to 4x4 matrix
    CGAffineTransform tmpAffine = [self nodeToParentTransform];
    
    CGAffineToGL(&tmpAffine, transfrom4x4.mat);
    
    // Update Z vertex manually
	transfrom4x4.mat[14] = 0;
    
    kmGLMultMatrix(&transfrom4x4);
    
    if (_camera && !(_grid && _grid.active)) {
        //锚点移动
        BOOL translate = (_anchorPointInPoints.x != 0.0f || _anchorPointInPoints.y != 0.0f);
        if( translate )
            kmGLTranslatef(_anchorPointInPoints.x, _anchorPointInPoints.y, 0 );
        
        [_camera locate];
        
		if( translate )
			kmGLTranslatef(-_anchorPointInPoints.x, -_anchorPointInPoints.y, 0);
    }
    

}


- (void) resumeSchedulerAndActions
{
	[_scheduler resumeTarget:self];
}

- (void) pauseSchedulerAndActions
{
	[_scheduler pauseTarget:self];
}

-(HLAction*) runAction:(HLAction*) action{
	NSAssert( action != nil, @"Argument must be non-nil");
    
	[_actionManager addAction:action target:self paused:!_isRunning];
	return action;
}


-(void) schedule:(SEL)selector
{
	[self schedule:selector interval:0 repeat:(INT_MAX-1) delay:0];
}

-(void) schedule:(SEL)selector interval:(float)interval
{
	[self schedule:selector interval:interval repeat:(INT_MAX-1) delay:0];
}

-(void) schedule:(SEL)selector interval:(float)interval repeat: (uint) repeat delay:(float) delay
{
	NSAssert( selector != nil, @"Argument must be non-nil");
	NSAssert( interval >=0, @"Arguemnt must be positive");
    
	[_scheduler scheduleSelector:selector forTarget:self interval:interval repeat:repeat delay:delay paused:!_isRunning];
}

- (void) scheduleOnce:(SEL) selector delay:(float) delay
{
	[self schedule:selector interval:0.f repeat:0 delay:delay];
}

-(void) unschedule:(SEL)selector
{
	// explicit nil handling
	if (selector == nil)
		return;
    
	[_scheduler unscheduleSelector:selector forTarget:self];
}

-(void) unscheduleAllSelectors
{
	[_scheduler unscheduleAllForTarget:self];
}

- (bool) is3DNode{
    return false;
}

@end












