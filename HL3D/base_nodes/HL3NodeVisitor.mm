//
//  HL3NodeVisitor.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-26.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3NodeVisitor.h"

@implementation HL3NodeVisitor
@synthesize currentNode=_currentNode, startingNode=_startingNode;
@synthesize shouldVisitChildren=_shouldVisitChildren, camera=_camera;

-(void) dealloc {
	_currentNode = nil;				// not retained
	_startingNode = nil;			// not retained
	[_camera release];
	[_pendingRemovals release];
	[super dealloc];
}

+ (id)visitor{
    return [[[self alloc] init] autorelease];
}

-(HL3Camera*) camera {
	if ( !_camera ) self.camera = self.defaultCamera;
	return _camera;
}

-(HL3Camera*) defaultCamera { return _startingNode.activeCamera; }

-(void) visit: (HL3Node*) aNode {
	if (!aNode) return;					// Must have a node to work on
	
	_currentNode = aNode;				// Make the node being processed available.
    
	if (!_startingNode) {				// If this is the first node, start up
		_startingNode = aNode;			// Not retained
		[self open];					// Open the visitor
	}
    
	[self process: aNode];				// Process the node and its children recursively
    
	if (aNode == _startingNode) {		// If we're back to the first node, finish up
		[self close];					// Close the visitor
		_startingNode = nil;			// Not retained
	}
	
	_currentNode = nil;					// Done with this node now.
}

/** Template method that is invoked automatically during visitation to process the specified node. */
-(void) process: (HL3Node*) aNode {
	NSLog(@"%@ visiting %@ %@ children", self, aNode, (_shouldVisitChildren ? @"and" : @"but not"));
	
	[self processBeforeChildren: aNode];	// Heavy lifting before visiting children
	
	// Recurse through the child nodes if required
	if (_shouldVisitChildren) [self processChildrenOf: aNode];
    
	[self processAfterChildren: aNode];		// Heavy lifting after visiting children
}

/**
 * Template method that is invoked automatically to process the specified node when
 * that node is visited, before the visit: method is invoked on the child nodes of
 * the specified node.
 *
 * This abstract implementation does nothing. Subclasses will override to process
 * each node as it is visited.
 */
-(void) processBeforeChildren: (HL3Node*) aNode {}

/**
 * If the shouldVisitChildren property is set to YES, this template method is invoked
 * automatically to cause the visitor to visit the child nodes of the specified node .
 *
 * This implementation invokes the visit: method on this visitor for each of the
 * children of the specified node. This establishes a depth-first traveral of the
 * node hierarchy.
 *
 * Subclasses may override this method to establish a different traversal.
 */
-(void) processChildrenOf: (HL3Node*) aNode {
	HL3Node* currNode = _currentNode;	// Remember current node
	
	NSMutableArray * children = [aNode ch];
//	for (HL3Node* child in children) [self visit: child];
    
	_currentNode = currNode;				// Restore current node
}

/**
 * Invoked automatically to process the specified node when that node is visited,
 * after the visit: method is invoked on the child nodes of the specified node.
 *
 * This abstract implementation does nothing. Subclasses will override to process
 * each node as it is visited.
 */
-(void) processAfterChildren: (HL3Node*) aNode {}

/**
 * Template method that prepares the visitor to perform a visitation run. This method
 * is invoked automatically prior to the first node being visited. It is not invoked
 * for each node visited.
 *
 * This implementation does nothing. Subclasses can override to initialize their state,
 * or to set any external state needed, such as GL state, prior to starting a visitation
 * run, and should invoke this superclass implementation.
 */
-(void) open {}

/**
 * Invoked automatically after the last node has been visited during a visitation run.
 * This method is invoked automatically after all nodes have been visited.
 * It is not invoked for each node visited.
 *
 * This implementation processes the removals of any nodes that were requested to
 * be removed via the requestRemovalOf: method during the visitation run. Subclasses
 * can override to clean up their state, or to reset any external state, such as GL
 * state, upon completion of a visitation run, and should invoke this superclass
 * implementation to process any removal requests.
 */
-(void) close { [self processRemovals]; }

-(void) requestRemovalOf: (HL3Node*) aNode {
	if (!_pendingRemovals) _pendingRemovals = [[NSMutableArray array] retain];
	[_pendingRemovals addObject: aNode];
}

-(void) processRemovals {
//	for (HL3Node* n in _pendingRemovals) [n remove];
//	[_pendingRemovals removeAllObjects];
}


@end









