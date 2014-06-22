//
//  HL3Node.m
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HL3Node.h"
#import "kazmath.h"
#import "kazmath/GL/matrix.h"
#import "TransformUtils.h"
#import "ccMacros.h"

@implementation HL3Node
@synthesize position3D = _position3D;
@synthesize anchorPoint3D = _anchorPoint3D;
@synthesize rotation3D = _rotation3D;
@synthesize scale3D = _scale3D;
@synthesize light3D = _light3D;

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {
        _position3D = hl3v(0, 0, 0);
        _rotation3D = hl3v(0, 0, 0);
        _scale3D = hl3v(1.0, 1.0, 1.0);
        _transform3D = kHL3Matrix4x4Identity;
    }
    return self;
}

- (void)setPosition3D:(HL3Vector)newPos{
    _position3D = newPos;
    _isTransformDirty = _isInverseDirty = YES;
}

- (void)setRotation3D:(HL3Vector)newValue{
    _rotation3D = newValue;
    _isTransformDirty = _isInverseDirty = YES;
}

- (void)setScale3D:(HL3Vector)newValue{
    _scale3D = newValue;
    _isInverseDirty = _isInverseDirty = YES;
}

//需要重载visit
- (void)visit{
    
    kmGLPushMatrix();
    
    [self transform3D];
    
    if ([m_pChildren count] > 0) {
        
        [self draw];
        
        for(NSUInteger i = 0; i < [m_pChildren count]; i++ ) {
			HLNode *child = [m_pChildren objectAtIndex:i];
			[child visit];
		}
    }else{
        [self draw];
    }
    
    kmGLPopMatrix();
}

- (HL3Matrix4x4)nodeToParentTransform3D{
    
    if (_isTransformDirty) {
        // Translate values
        float x = _position3D.x;
        float y = _position3D.y;
        float z = _position3D.z;
        
        kmMat4 matTransform ;
        kmMat4Identity(&matTransform);
        kmMat4Translation(&matTransform, x, y, z);
        
        
        //Rotation values 
        if( _rotation3D.x || _rotation3D.y || _rotation3D.z ) {
			float radiansX = -CC_DEGREES_TO_RADIANS(_rotation3D.x);
			float radiansY = -CC_DEGREES_TO_RADIANS(_rotation3D.y);
            float radiansZ = -CC_DEGREES_TO_RADIANS(_rotation3D.z);
            
            //
            kmMat4 rMatrixX;
            kmMat4 rMatrixY;
            kmMat4 rMatrixZ;
            
            kmMat4Identity(&rMatrixX);
            kmMat4Identity(&rMatrixY);
            kmMat4Identity(&rMatrixZ);
            
            kmMat4RotationX(&rMatrixX, radiansX);
            kmMat4RotationY(&rMatrixY, radiansY);
            kmMat4RotationZ(&rMatrixZ, radiansZ);
            
            kmMat4 rOut1;
            kmMat4Identity(&rOut1);
        
            matTransform = *kmMat4Multiply(&rOut1, &matTransform, &rMatrixX);
            matTransform = *kmMat4Multiply(&rOut1, &matTransform, &rMatrixY);
            matTransform = *kmMat4Multiply(&rOut1, &matTransform, &rMatrixZ);
		}
        
        //Scale values
        if( _scale3D.x || _scale3D.y || _scale3D.z ) {
            
            kmMat4 scaleMatrixX;
            kmMat4Scaling(&scaleMatrixX, _scale3D.x, _scale3D.y, _scale3D.z);
            
            kmMat4 rOut1;
            kmMat4Identity(&rOut1);
            matTransform = *kmMat4Multiply(&rOut1, &matTransform, &scaleMatrixX);
		}

        _transform3D = HL3Matrix4x4(matTransform.mat);
        _isTransformDirty = NO;
    }
    
    return _transform3D;
}

- (void)transform3D{
    
    kmMat4 transfrom4x4;
    
    HL3Matrix4x4 nodeToParentTransform = [self nodeToParentTransform3D];

    kmMat4Fill(&transfrom4x4, nodeToParentTransform.getArray());
    
    kmGLMultMatrix(&transfrom4x4);

    if (_camera) {
        [_camera locate];
    }
}

//3d节点的绘制 , 覆盖2d节点绘制过程
- (void)draw{
    
}


- (bool)is3DNode{
    return true;
}

@end







