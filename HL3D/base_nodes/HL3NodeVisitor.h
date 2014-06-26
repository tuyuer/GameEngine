//
//  HL3NodeVisitor.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-26.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL3Node.h"
#import "HL3Camera.h"
#import "HL3Scene.h"

/**
 HL3NodeVisitor 是在节点继承树遍历过程中传递给节点的一个图形上下文对象
 */
@interface HL3NodeVisitor : NSObject{
    HL3Node * _startingNode;
    HL3Node * _currentNode;
    NSMutableArray * _pendingRemovals;
    HL3Camera * _camera;
    BOOL _shouldVisitChildren : 1;
}

/**
 * Indicates whether this visitor should traverse the child nodes of any node it visits.
 * 标识这个visitor是否要遍历它的所有子节点
 * The initial value of this property is YES.
 * 初始值为YES
 */
@property(nonatomic, assign) BOOL shouldVisitChildren;



/** Allocates and initializes an autoreleased instance. */
+(id) visitor;

/**
 * Visits the specified node, then if the shouldVisitChildren property is set to YES,
 * invokes this visit: method on each child node as well.
 * 遍历指定节点，如果 shouldVisitChildren 为Yes，所有子节点也将调用这个方法
 * Subclasses will override several template methods to customize node visitation behaviour.
 * 子类将重载一些模板方法以自定义节点的遍历方式
 */
-(void) visit: (HL3Node*) aNode;


/**
 * Requests the removal of the specfied node.
 * 请求删除指定的节点
 * During a visitation run, to remove a node from the hierarchy, you must use this method
 * 在节点遍历过程中，如果你想移除节点树中一个节点，你必须使用这个方法
 * instead of directly invoking the remove method on the node itself. Visitation involves
 * iterating through collections of child nodes, and removing a node during the iteration
 * of a collection raises an error.
 *
 * This method can safely be invoked while a node is being visited. The visitor keeps
 * track of the requests, and safely removes all requested nodes as part of the close
 * method, once the visitation of the full node assembly is finished.
 */
-(void) requestRemovalOf: (HL3Node*) aNode;


#pragma mark Accessing node content


/**
 * The HL3Node on which this visitation traversal was intitiated. This is the node
 * on which the visit: method was first invoked to begin a traversal of the node
 * structural hierarchy.
 *
 * This property is only valid during the traversal, and will be nil both before
 * and after the visit: method is invoked.
 */
@property(nonatomic, readonly) HL3Node* startingNode;


/**
 * Returns the HL3Scene.
 *
 * This is a convenience property that returns the scene property of the startingNode property.
 */
@property(nonatomic, readonly) HL3Scene* scene;


/**
 * The camera that is viewing the 3D scene.
 *
 * If this property is not set in advance, it is lazily initialized to the value
 * of the defaultCamera property when first accessed during a visitation run.
 *
 * The value of this property is not cleared at the end of the visitation run.
 */
@property(nonatomic, retain) HL3Camera* camera;

/**
 * The default camera to use when visiting a node assembly.
 *
 * This implementation returns the activeCamera property of the starting node.
 * Subclasses may override.
 */
@property(nonatomic, readonly) HL3Camera* defaultCamera;


/**
 * The CC3Node that is currently being visited.
 *
 * This property is only valid during the traversal of the node returned by this property,
 * and will be nil both before and after the visit: method is invoked on the node.
 */
@property(nonatomic, readonly) HL3Node* currentNode;

@end





























