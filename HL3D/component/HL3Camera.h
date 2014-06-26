//
//  HL3Camera.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Node.h"
#import "HL3Frustum.h"
#import "HL3Foundation.h"


static const GLfloat kHL3DefaultFieldOfView = 45.0f;


/**
 * HL3Camera 代表正在观察3D场景的相机
 * HL3Camera 是一个HL3Node类型，可以组装到Node结构
 * 它可以做为其他node的子node，当然它也可以包含子node
 * 比如，它可以附加到一个拖拉机节点上，这样它就可以跟随拖拉机移动
 * 又或者把一个Light节点添加到Camera上，这样light节点就会跟随相机进行移动
 */

@interface HL3Camera : HL3Node{
    HL3Frustum      *_frustum;
    HL3Viewport     _viewport;
    GLfloat         _fieldOfView;
}
@property(nonatomic, assign) GLfloat fieldOfView;

+(id)camera;
@end









