//
//  HL3Node.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-26.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Identifiable.h"
#import "HL3Foundation.h"

/**
 * CC3Node and its subclasses form the basis of all 3D artifacts in the 3D scene, including
   HL3Node 和它的所有子类构成了3D场景中的反有3D事物，其中包括 
 * visible meshes, structures, cameras, lights, resources, and the 3D scene itself.
   visible meshes, structures, cameras, lights, resources, and the 3D scene itself.

 * Nodes can be moved, rotated and scaled. Rotation can be specified via Euler angles,
   节点可以移动，旋转和缩放。其中旋转可以通过 欧拉角，四元组，旋转轴和角度 
 * quaternions, rotation axis and angle, or changes to any of these properties.
   亦或者改变其中的任意属性
 */



@class HL3Camera;
@class HL3Scene;

@interface HL3Node : HL3Identifiable{
    NSMutableArray * _children;
    HL3Node * _parent;
    
    HL3Vector _location;
    HL3Vector _scale;
    
    BOOL _isTransformDirty : 1;
    BOOL _isTransformInvertedDirty : 1;
    BOOL _visible : 1;
	BOOL _isRunning : 1;
}

/**
 * If this node has been added to the 3D scene, either directly, or as part
   如果这个节点被添加到3D场景，不管是直接还是做为节点的一部分
 * of a node assembly, returns the activeCamera property of the CC3Scene instance,
   都将返回HL3Scene的activeCamera实例
 * as accessed via the scene property, otherwise returns nil.
 *
 * Reading this property traverses up the node hierarchy. If this property
 * is accessed frequently, it is recommended that it be cached.
 */
@property(nonatomic, retain, readonly) HL3Camera* activeCamera;


/**
 * If this node has been added to the 3D scene, either directly, or as part
 * of a node assembly, returns the CC3Scene instance that forms the 3D scene,
 * otherwise returns nil.
 *
 * Reading this property traverses up the node hierarchy. If this property
 * is accessed frequently, it is recommended that it be cached.
 */
@property(nonatomic, readonly) HL3Scene* scene;

@property(nonatomic, readonly) NSMutableArray * children;

@property(nonatomic, readonly) HL3Node * parent;

@property(nonatomic, assign) HL3Vector location;

@property(nonatomic, assign) HL3Vector scale;

@property(nonatomic, assign) HL3Vector rotation;

@property(nonatomic, readonly) BOOL isTransformDirty;

@property(nonatomic, assign) BOOL visible;

@property(nonatomic,assign) BOOL isRunning;



+(id) node;
+(id) nodeWithTag: (GLuint) aTag;

@end















