//
//  HLCamera.h
//  GameEngine
//
//  Created by tuyuer on 14-4-10.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kazmath.h"

@interface HLCamera : NSObject{
    
    float _eyeX;
    float _eyeY;
    float _eyeZ;
    
    float _centerX;
    float _centerY;
    float _centerZ;
    
    float _upX;
    float _upY;
    float _upZ;
    
    BOOL _dirty;
    
    kmMat4	_lookupMatrix;
}

/** whether of not the camera is dirty */
@property (nonatomic,readwrite) BOOL dirty;


/** returns the Z eye */
+(float) getZEye;

/** sets the camera in the defaul position */
-(void) restore;
/** Sets the camera using gluLookAt using its eye, center and up_vector */
-(void) locate;
/** sets the eye values in points */
-(void) setEyeX: (float)x eyeY:(float)y eyeZ:(float)z;
/** sets the center values in points */
-(void) setCenterX: (float)x centerY:(float)y centerZ:(float)z;
/** sets the up values */
-(void) setUpX: (float)x upY:(float)y upZ:(float)z;

/** get the eye vector values in points */
-(void) eyeX:(float*)x eyeY:(float*)y eyeZ:(float*)z;
/** get the center vector values in points */
-(void) centerX:(float*)x centerY:(float*)y centerZ:(float*)z;
/** get the up vector values */
-(void) upX:(float*)x upY:(float*)y upZ:(float*)z;

@end
