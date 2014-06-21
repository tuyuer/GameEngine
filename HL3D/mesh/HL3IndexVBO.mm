//
//  HL3IndexVBO.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3IndexVBO.h"
#import "HLTypes.h"
#import "HL3Vertex.h"
#import "HL3IndexTriangle.h"
#import "HLGLStateCache.h"
#import "HLGLProgram.h"

@implementation HL3IndexVBO
@synthesize vertexBuffer = _vertexBuffer;
@synthesize indexBuffer = _indexBuffer;
@synthesize vertexCount = _vertexCount;
@synthesize indexCount = _indexCount;

- (void)dealloc{
    if (_vertexBuffer != 0 ) {
        glDeleteBuffers(1, &_vertexBuffer);
    }
    if (_indexBuffer != 0 ) {
        glDeleteBuffers(1, &_indexBuffer);
    }
    
    [super dealloc];
}

+ (id)indexVBO{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        
        _vertexBuffer = 0;
        _indexBuffer = 0;
        
        _vertexCount = 0;
        _indexCount = 0;
        
        _vao = 0;
        
        [self genBuffers];
    }
    return self;
}

- (void)genBuffers{
    assert(_vertexCount == 0);
    assert(_indexBuffer == 0);
    assert(_vao == 0);
    
    glGenVertexArraysOES(1, &_vao);
    glGenBuffers(1, &_vertexBuffer);
    glGenBuffers(1, &_indexBuffer);
}

- (void)submitVertex:(NSArray*)vertexArray usage:(GLenum)usage{
    int vertexCount = [vertexArray count];
    _vertexCount = vertexCount;
    if(_vertexCount==0)return;
    
    ccV3F_C4F_T2F_N3F vertexs[_vertexCount];
    for (int i=0; i<[vertexArray count]; i++) {
        HL3Vertex * vertexValue = [vertexArray objectAtIndex:i];
        
        vertexs[i].vertices.x = vertexValue.position.x;
        vertexs[i].vertices.y = vertexValue.position.y;
        vertexs[i].vertices.z = vertexValue.position.z;
        
        vertexs[i].colors.r = vertexValue.color.x;
        vertexs[i].colors.g = vertexValue.color.y;
        vertexs[i].colors.b = vertexValue.color.z;
        vertexs[i].colors.a = vertexValue.color.w;
        
        vertexs[i].texCoords.u = vertexValue.textureCoord.x;
        vertexs[i].texCoords.v = vertexValue.textureCoord.y;
        
        vertexs[i].normals.x = vertexValue.normal.x;
        vertexs[i].normals.y = vertexValue.normal.y;
        vertexs[i].normals.z = vertexValue.normal.z;
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*_vertexCount*(3+4+2+3), vertexs, usage);
}

- (void)submitIndex:(NSArray*)indexTriangleArray usage:(GLenum)usage{
    int indexTriangleCount = [indexTriangleArray count];
    int indexCount = indexTriangleCount * 3;
    _indexCount = indexCount;
    
    if(_indexCount==0)return;
    
    int vertexIndexes[_indexCount];
    for (int i=0; i<indexTriangleCount; i++) {
        HL3IndexTriangle * indexTriangle = [indexTriangleArray objectAtIndex:i];
        int * indexVertex = [indexTriangle vertexIndex];
        vertexIndexes[i*3+0] = indexVertex[0];
        vertexIndexes[i*3+1] = indexVertex[1];
        vertexIndexes[i*3+2] = indexVertex[2];
    }

    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLuint)*_indexCount, vertexIndexes, usage);
}

- (void)bindVAO{
    glBindVertexArrayOES(_vao);
}

- (void)unBindVAO{
    glBindVertexArrayOES(0);
}

- (void)bindVertexBuffer{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
}

- (void)unBindVertexBuffer{
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)bindIndexBuffer{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
}

- (void)unBindIndexBuffer{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (void)drawVBOData{

    [self bindVertexBuffer];
    glEnableVertexAttribArray(kCCVertexAttrib_Position);
    glEnableVertexAttribArray(kCCVertexAttrib_Color);
    
    NSInteger diff = offsetof( ccV3F_C4F_T2F_N3F, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, sizeof(ccV3F_C4F_T2F_N3F), (void*)diff);
    
    diff = offsetof( ccV3F_C4F_T2F_N3F, colors);
    glVertexAttribPointer(kCCVertexAttrib_Color, 3, GL_FLOAT, GL_FALSE, sizeof(ccV3F_C4F_T2F_N3F), (void*)diff);
    
    [self unBindVertexBuffer];
    

    [self bindIndexBuffer];
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_INT, 0);
    [self unBindIndexBuffer];

}

@end


















