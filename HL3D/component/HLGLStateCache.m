//
//  HLGLStateCache.m
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLGLStateCache.h"
#import "HLGLProgram.h"


static BOOL		_vertexAttribPosition = NO;
static BOOL		_vertexAttribColor = NO;
static BOOL		_vertexAttribNormal = NO;
static BOOL		_vertexAttribTexCoords = NO;


static GLenum	_ccBlendingSource = -1;
static GLenum	_ccBlendingDest = -1;

void ccGLEnableVertexAttribs( unsigned int flags )
{

	/* Position */
	BOOL enablePosition = flags & kCCVertexAttribFlag_Position;
	
	if( enablePosition != _vertexAttribPosition ) {
		if( enablePosition )
			glEnableVertexAttribArray( kCCVertexAttrib_Position );
		else
			glDisableVertexAttribArray( kCCVertexAttrib_Position );
        
		_vertexAttribPosition = enablePosition;
	}
    
	/* Color */
	BOOL enableColor = flags & kCCVertexAttribFlag_Color;
	
	if( enableColor != _vertexAttribColor ) {
		if( enableColor )
			glEnableVertexAttribArray( kCCVertexAttrib_Color );
		else
			glDisableVertexAttribArray( kCCVertexAttrib_Color );
        
		_vertexAttribColor = enableColor;
	}
    
    /* Normal */
	BOOL enableNormal = flags & kCCVertexAttribFlag_Normal;
	
	if( enableNormal != _vertexAttribNormal ) {
		if( enableNormal )
			glEnableVertexAttribArray( kCCVertexAttrib_Normal );
		else
			glDisableVertexAttribArray( kCCVertexAttrib_Normal );
        
		_vertexAttribNormal = enableNormal;
	}
    
    
	/* Tex Coords */
	BOOL enableTexCoords = flags & kCCVertexAttribFlag_TexCoords;
	
	if( enableTexCoords != _vertexAttribTexCoords ) {
		if( enableTexCoords )
			glEnableVertexAttribArray( kCCVertexAttrib_TexCoords );
		else
			glDisableVertexAttribArray( kCCVertexAttrib_TexCoords );
        
		_vertexAttribTexCoords = enableTexCoords;
	}
    
   
}


static void SetBlending(GLenum sfactor, GLenum dfactor)
{
	if(sfactor == GL_ONE && dfactor == GL_ZERO){
		glDisable(GL_BLEND);
	} else {
		glEnable(GL_BLEND);
		glBlendFunc( sfactor, dfactor );
	}
}

void ccGLBlendFunc(GLenum sfactor, GLenum dfactor)
{
	if( sfactor != _ccBlendingSource || dfactor != _ccBlendingDest ) {
		_ccBlendingSource = sfactor;
		_ccBlendingDest = dfactor;
		SetBlending( sfactor, dfactor );
	}
}

