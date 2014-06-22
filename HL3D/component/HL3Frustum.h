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

@interface HL3Frustum : NSObject{
    HL3Plane    planes[6];
    HL3Vector   vertices[8];

    GLfloat top;
    GLfloat bottom;
    GLfloat left;
    GLfloat right;
    GLfloat near;
    GLfloat far;
    
    BOOL isUsingParallelProjection;
}

/* 表明视锥是否使用平等投影
 * NO代表透视投影，YES代表平等投影
 */
@property (nonatomic,assign) BOOL isUsingParallelProjection;

@end







