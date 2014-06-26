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

@class HL3Light;
@class HL3Camera;
@class HL3Scene;
typedef struct _HL3NodeUniformHandles {

    GLuint u_lightPosition;
    GLuint u_lightDirection;
    
    GLuint u_lightAmbient;
    GLuint u_lightDiffuse;
    GLuint u_lightSpecular;
    
    GLuint u_lightShiness;
    
    GLuint u_normalMatrix;
    GLuint u_sampler;
}HL3NodeUniformHandles;

@interface HL3Node : HLNode{
    HL3Node * _parent3D;
    HL3Vector _position3D;
    HL3Vector _anchorPoint3D;
    HL3Vector _rotation3D;
    HL3Vector _scale3D;
    
    HL3Matrix4x4 _transform3D;
    HL3Matrix4x4 _inverse3D;

    HL3Light * _light3D;
    HL3NodeUniformHandles _uniformHandles;
    
    BOOL _isLight;
    BOOL _isCamera;
}
@property (nonatomic,assign) HL3Vector position3D;
@property (nonatomic,assign) HL3Vector anchorPoint3D;
@property (nonatomic,assign) HL3Vector rotation3D;
@property (nonatomic,assign) HL3Vector scale3D;
@property (nonatomic,assign) HL3Light * light3D;
@property (nonatomic,retain, readonly) HL3Camera* activeCamera;
/**
 * If this node has been added to the 3D scene, either directly, or as part
 * of a node assembly, returns the CC3Scene instance that forms the 3D scene,
 * otherwise returns nil.
 *
 * Reading this property traverses up the node hierarchy. If this property
 * is accessed frequently, it is recommended that it be cached.
 */
@property(nonatomic, readonly) HL3Scene * scene;

@property (nonatomic,assign) BOOL isLight;
@property (nonatomic,assign) BOOL isCamera;



//about transform3D ...
- (HL3Matrix4x4)nodeToParentTransform3D;
//performs Opengl view - matrix transformation based on position etc...
- (void)transform3D;
//遍历节点
- (void)visit;
//重载绘制方法
- (void)draw;

@end
