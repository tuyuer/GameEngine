//
//  HLNode.h
//  GameEngine
//
//  Created by tuyuer on 14-3-24.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLGLProgram.h"
#import "HLCamera.h"

@interface HLNode : NSObject{
    float _rotationX,_rotationY;
    
    float _scaleX, _scaleY;
    
    // skew angles
	float _skewX, _skewY;
    
    CGPoint _position;
    
    //anchor point in points
    CGPoint _anchorPointInPoints;
    
    //anchor point normalized (Not in points)
    CGPoint _anchorPoint;
    
    CGSize _contentSize;
    
    // transform
    CGAffineTransform  _transform, _inverse;
    BOOL _isTransformDirty;
    BOOL _isInverseDirty;
    
    //a camera
    HLCamera * _camera;
    
    // z-order value
    NSInteger _zOrder;
    
    // weak ref to parent
    HLNode * _parent;
    
    // userd to preserve sequence while sorting children with the same z order
    NSUInteger _orderOfArrival;
    
    //a tag. any number you want to assign to the node
    NSInteger _tag;
    
    //check to see if need to reorder children
    BOOL _isReorderChildDirty;
    
    // Is Running...
    BOOL _isRunning;
    
    // If YES, the Anchor Point will be (0,0) when you position the CCNode.
	// Used by CCLayer and CCScene
    BOOL _ignoreAnchorPointForPosition;
    
    NSMutableArray * m_pChildren;
    
    HLGLProgram * _shaderProgram;
}
@property (nonatomic,assign) CGSize contentSize;
@property (nonatomic,assign) CGPoint anchorPoint;
@property (nonatomic,assign) CGPoint position;
@property (nonatomic,readwrite,assign) HLNode * parent;
@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) NSInteger zOrder;
@property (nonatomic,assign) NSUInteger orderOfArrival;
@property (nonatomic,retain) HLGLProgram * shaderProgram;
@property (nonatomic,assign) BOOL ignoreAnchorPointForPosition;

/** The rotation (angle) of the node in degrees. 0 is the default rotation angle. Positive values rotate node CW. */
@property (nonatomic,assign) float rotation;
/** The rotation (angle) of the node in degrees. 0 is the default rotation angle. Positive values rotate node CW. It only modifies the X rotation performing a horizontal rotational skew . */
@property (nonatomic,assign) float rotationX;
/** The rotation (angle) of the node in degrees. 0 is the default rotation angle. Positive values rotate node CW. It only modifies the Y rotation performing a vertical rotational skew . */
@property (nonatomic,assign) float rotationY;


/** The scale factor of the node. 1.0 is the default scale factor. It modifies the X and Y scale at the same time. */
@property(nonatomic,readwrite,assign) float scale;
/** The scale factor of the node. 1.0 is the default scale factor. It only modifies the X scale factor. */
@property(nonatomic,readwrite,assign) float scaleX;
/** The scale factor of the node. 1.0 is the default scale factor. It only modifies the Y scale factor. */
@property(nonatomic,readwrite,assign) float scaleY;

/** The X skew angle of the node in degrees.
 This angle describes the shear distortion in the X direction.
 Thus, it is the angle between the Y axis and the left edge of the shape
 The default skewX angle is 0. Positive values distort the node in a CW direction.
 */
@property(nonatomic,readwrite,assign) float skewX;

/** The Y skew angle of the node in degrees.
 This angle describes the shear distortion in the Y direction.
 Thus, it is the angle between the X axis and the bottom edge of the shape
 The default skewY angle is 0. Positive values distort the node in a CCW direction.
 */
@property(nonatomic,readwrite,assign) float skewY;

/** A CCCamera object that lets you move the node using a gluLookAt */
@property(nonatomic,readonly) HLCamera * camera;

 
+ (id)node;
- (void)addChild:(HLNode*)child;
- (void)addChild:(HLNode*)child z:(NSInteger)z;
- (void)addChild:(HLNode*)child z:(NSInteger)z tag:(NSInteger)tag;
- (void)sortAllChildren;
- (void)visit;
- (void)draw;

- (void)onEnter;
- (void)onEnterTransitionDidFinish;

//about transform ...
- (CGAffineTransform)nodeToParentTransform;
//performs Opengl view - matrix transformation based on position etc...
- (void)transform;
@end
