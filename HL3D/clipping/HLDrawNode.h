//
//  HLDrawNode.h
//  GameEngine
//
//  Created by huxiaozhou on 14-5-11.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLNode.h"
#import "HLTypes.h"

/** HLDrawNode
 Node that draws dots, segments and polygons.
 Faster than the "drawing primitives" since they it draws everything in one single batch.
 
 @since v2.1
 */

@interface HLDrawNode : HLNode{
    GLuint _vao;
    GLuint _vbo;
    
    NSUInteger _bufferCapacity;
    GLsizei _bufferCount;
    ccV2F_C4B_T2F * _buffer;
    
    BOOL _dirty;

}

/** draw a dot at a position, with a given radius and color */
-(void)drawDot:(CGPoint)pos radius:(CGFloat)radius color:(ccColor4F)color;

/** Clear the geometry in the node's buffer. */
- (void)clear;

@end
