//
//  HL3IndexVBO.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HL3IndexVBO : NSObject{
    GLuint      _vao;
    GLuint      _vertexBuffer;
    GLuint      _indexBuffer;
    
    int         _vertexCount;
    int         _indexCount;
}

@property (nonatomic,assign) GLuint vertexBuffer;
@property (nonatomic,assign) GLuint indexBuffer;
@property (nonatomic,assign) int vertexCount;
@property (nonatomic,assign) int indexCount;

+ (id)indexVBO;
- (void)submitVertex:(NSArray*)vertexArray usage:(GLenum)usage;
- (void)submitIndex:(NSArray*)indexTriangleArray usage:(GLenum)usage;


// About Binding

- (void)bindVAO;
- (void)unBindVAO;

- (void)bindVertexBuffer;
- (void)unBindVertexBuffer;

- (void)bindIndexBuffer;
- (void)unBindIndexBuffer;

- (void)drawVBOData;

@end
