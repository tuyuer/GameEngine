//
//  HL3Frustum.h
//  GameEngine
//
//  Created by Tuyuer on 14-6-22.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

/*
 代表相机的视锥体，每一个相机都有一个此类的实例
 每一个视锥体有四个面:top,bottom,left,right,有near,far两个面
 上面六个构成6个平面
 
 视锥体是一个截断的金字塔，其中截顶代表相机的位置
 视锥体控制并填充相机里的matrix,其中的6个视截面与模型视图矩阵结合
 */

#import <Foundation/Foundation.h>
#import "HL3Plane.h"
#import "HL3Vertex.h"
#import "HL3Frustum.h"
#import "HL3Matrix4x4.h"
#import "HLCamera.h"

@interface HL3Frustum : NSObject{
    
    HLCamera * _camera;
    
    HL3Plane    planes[6];
    HL3Vector   vertices[8];

    GLfloat top;
    GLfloat bottom;
    GLfloat left;
    GLfloat right;
    GLfloat near;
    GLfloat far;
    
    HL3Matrix4x4 * _finiteProjectionMatrix;
    HL3Matrix4x4 * _infiniteProjectionMatrix;
    BOOL isUsingParallelProjection;
}

/**
 * The camera whose frustum this is.
 *
 * This link-back property is set automatically when this frustum is set into the frustum
 * property of the camera. Usually the application should never set this property directly.
 *
 * This is a weak reference to avoid a retain cycle between the camera and the frustum.
 */
@property(nonatomic, assign) HLCamera* camera;

/** The distance from view center to the top of this frustum at the near clipping plane. */
@property(nonatomic, readonly) GLfloat top;

/** The distance from view center to the bottom of this frustum at the near clipping plane. */
@property(nonatomic, readonly) GLfloat bottom;

/** The distance from view center to the left edge of this frustum at the near clipping plane. */
@property(nonatomic, readonly) GLfloat left;

/** The distance from view center to the right edge of this frustum at the near clipping plane. */
@property(nonatomic, readonly) GLfloat right;

/** The distance to the near end of this frustum. */
@property(nonatomic, readonly) GLfloat near;

/** The distance to the far end of this frustum. */
@property(nonatomic, readonly) GLfloat far;


/** The clip plane at the top of this frustum(视锥), in global coordinates. */
@property(nonatomic, readonly) HL3Plane topPlane;

/** The clip plane at the bottom of this frustum, in global coordinates. */
@property(nonatomic, readonly) HL3Plane bottomPlane;

/** The clip plane at the left side of this frustum, in global coordinates. */
@property(nonatomic, readonly) HL3Plane leftPlane;

/** The clip plane at the right side of this frustum, in global coordinates. */
@property(nonatomic, readonly) HL3Plane rightPlane;

/** The clip plane at the near end of this frustum, in global coordinates. */
@property(nonatomic, readonly) HL3Plane nearPlane;

/** The clip plane at the far end of this frustum, in global coordinates. */
@property(nonatomic, readonly) HL3Plane farPlane;


/** Returns the location of the near top left corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector nearTopLeft;

/** Returns the location of the near top right corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector nearTopRight;

/** Returns the location of the near bottom left corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector nearBottomLeft;

/** Returns the location of the near bottom right corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector nearBottomRight;

/** Returns the location of the far top left corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector farTopLeft;

/** Returns the location of the far top right corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector farTopRight;

/** Returns the location of the far bottom left corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector farBottomLeft;

/** Returns the location of the far bottom right corner of this frustum, in the global coordinate system. */
@property(nonatomic, assign, readonly) HL3Vector farBottomRight;



/* 表明视锥是否使用平等投影
 * NO代表透视投影，YES代表平等投影
 */
@property (nonatomic,assign) BOOL isUsingParallelProjection;

/** A finite projection matrix with the far end at the distance given by the far property. */
@property(nonatomic, readonly) HL3Matrix4x4* finiteProjectionMatrix;

/** An infinite projection matrix with the far end at infinity. */
@property(nonatomic, readonly) HL3Matrix4x4* infiniteProjectionMatrix;

@end







