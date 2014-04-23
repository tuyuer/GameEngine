//
//  HL3Node.h
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLNode.h"
#import "HL3Foundation.h"
#import "HL3Matrix4x4.h"
#import "HL3Camera.h"

@interface HL3Node : HLNode{
    HL3Node * _parent3D;
    HL3Vector _position3D;
    HL3Vector _anchorPoint3D;
    HL3Vector _rotation3D;
    HL3Vector _scale3D;
    
    HL3Matrix4x4 _transform3D;
    HL3Matrix4x4 _inverse3D;

    HL3Camera * _camera3D;
}
@property (nonatomic,assign) HL3Vector position3D;
@property (nonatomic,assign) HL3Vector anchorPoint3D;
@property (nonatomic,assign) HL3Vector rotation3D;
@property (nonatomic,assign) HL3Vector scale3D;
@property (nonatomic,assign) HL3Camera * camera3D;


//about transform3D ...
- (HL3Matrix4x4)nodeToParentTransform3D;
//performs Opengl view - matrix transformation based on position etc...
- (void)transform3D;
//遍历节点
- (void)visit;
//重载绘制方法
- (void)draw;

@end
