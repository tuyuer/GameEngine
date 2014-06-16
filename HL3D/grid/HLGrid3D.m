//
//  HLGrid3D.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-8.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGrid3D.h"
#import "HLGLStateCache.h"

@implementation HLGrid3D

-(void)dealloc
{
	free(_texCoordinates);
	free(_vertices);
	free(_indices);
	free(_originalVertices);
	[super dealloc];
}

-(void)blit
{
	NSInteger n = _gridSize.width * _gridSize.height;
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_TexCoords );
	[_shaderProgram use];
	[_shaderProgram setUniformsForBuiltins];
    
	//
	// Attributes
	//
    
	// position
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, _vertices);
    
	// texCoods
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, _texCoordinates);
    
	glDrawElements(GL_TRIANGLES, (GLsizei) n*6, GL_UNSIGNED_SHORT, _indices);
	
}

-(void)calculateVertexPoints
{
	float width = (float)_texture.width;
	float height = (float)_texture.height;
	float imageH = _texture.contentSize.height;
    
	int x, y, i;
    
	if (_vertices) free(_vertices);
	if (_originalVertices) free(_originalVertices);
	if (_texCoordinates) free(_texCoordinates);
	if (_indices) free(_indices);
	
	NSUInteger numOfPoints = (_gridSize.width+1) * (_gridSize.height+1);
	
	_vertices = malloc(numOfPoints * sizeof(ccVertex3F));
	_originalVertices = malloc(numOfPoints * sizeof(ccVertex3F));
	_texCoordinates = malloc(numOfPoints * sizeof(ccVertex2F));
	_indices = malloc( (_gridSize.width * _gridSize.height) * sizeof(GLushort)*6);
    
	GLfloat *vertArray = (GLfloat*)_vertices;
	GLfloat *texArray = (GLfloat*)_texCoordinates;
	GLushort *idxArray = (GLushort *)_indices;
    
	for( x = 0; x < _gridSize.width; x++ )
	{
		for( y = 0; y < _gridSize.height; y++ )
		{
			NSInteger idx = (y * _gridSize.width) + x;
            
			GLfloat x1 = x * _step.x;
			GLfloat x2 = x1 + _step.x;
			GLfloat y1 = y * _step.y;
			GLfloat y2 = y1 + _step.y;
            
			GLushort a = x * (_gridSize.height+1) + y;
			GLushort b = (x+1) * (_gridSize.height+1) + y;
			GLushort c = (x+1) * (_gridSize.height+1) + (y+1);
			GLushort d = x * (_gridSize.height+1) + (y+1);
            
			GLushort	tempidx[6] = { a, b, d, b, c, d };
            
			memcpy(&idxArray[6*idx], tempidx, 6*sizeof(GLushort));
            
			int l1[4] = { a*3, b*3, c*3, d*3 };
			ccVertex3F	e = {x1,y1,0};
			ccVertex3F	f = {x2,y1,0};
			ccVertex3F	g = {x2,y2,0};
			ccVertex3F	h = {x1,y2,0};
            
			ccVertex3F l2[4] = { e, f, g, h };
            
			int tex1[4] = { a*2, b*2, c*2, d*2 };
			CGPoint tex2[4] = { ccp(x1, y1), ccp(x2, y1), ccp(x2, y2), ccp(x1, y2) };
            
			for( i = 0; i < 4; i++ )
			{
				vertArray[ l1[i] ] = l2[i].x;
				vertArray[ l1[i] + 1 ] = l2[i].y;
				vertArray[ l1[i] + 2 ] = l2[i].z;
                
				texArray[ tex1[i] ] = tex2[i].x / width;
				if( _isTextureFlipped )
					texArray[ tex1[i] + 1 ] = (imageH - tex2[i].y) / height;
				else
					texArray[ tex1[i] + 1 ] = tex2[i].y / height;
			}
		}
	}
    
	memcpy(_originalVertices, _vertices, (_gridSize.width+1)*(_gridSize.height+1)*sizeof(ccVertex3F));
}

-(ccVertex3F)vertex:(CGPoint)pos
{
	NSAssert( pos.x == (NSUInteger)pos.x && pos.y == (NSUInteger) pos.y , @"Numbers must be integers");
    
	NSInteger index = (pos.x * (_gridSize.height+1) + pos.y) * 3;
	float *vertArray = (float *)_vertices;
    
	ccVertex3F	vert = { vertArray[index], vertArray[index+1], vertArray[index+2] };
    
	return vert;
}

-(ccVertex3F)originalVertex:(CGPoint)pos
{
	NSAssert( pos.x == (NSUInteger)pos.x && pos.y == (NSUInteger) pos.y , @"Numbers must be integers");
    
	NSInteger index = (pos.x * (_gridSize.height+1) + pos.y) * 3;
	float *vertArray = (float *)_originalVertices;
    
	ccVertex3F	vert = { vertArray[index], vertArray[index+1], vertArray[index+2] };
    
	return vert;
}

-(void)setVertex:(CGPoint)pos vertex:(ccVertex3F)vertex
{
	NSAssert( pos.x == (NSUInteger)pos.x && pos.y == (NSUInteger) pos.y , @"Numbers must be integers");
    
	NSInteger index = (pos.x * (_gridSize.height+1) + pos.y) * 3;
	float *vertArray = (float *)_vertices;
	vertArray[index] = vertex.x;
	vertArray[index+1] = vertex.y;
	vertArray[index+2] = vertex.z;
}

-(void)reuse
{
	if ( _reuseGrid > 0 )
	{
		memcpy(_originalVertices, _vertices, (_gridSize.width+1)*(_gridSize.height+1)*sizeof(ccVertex3F));
		_reuseGrid--;
	}
}


@end
