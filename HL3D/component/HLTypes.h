//
//  HLTypes.h
//  GameEngine
//
//  Created by tuyuer on 14-3-26.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

typedef struct _ccColor4B{
    GLubyte	r;
	GLubyte	g;
	GLubyte	b;
	GLubyte a;
}ccColor4B;

typedef struct _ccColor4F {
	GLfloat r;
	GLfloat g;
	GLfloat b;
	GLfloat a;
} ccColor4F;

typedef struct _ccVertex3F{
    GLfloat x;
	GLfloat y;
	GLfloat z;
}ccVertex3F;

typedef struct _ccVertex2F
{
	GLfloat x;
	GLfloat y;
} ccVertex2F;

typedef struct _ccTex2F {
    GLfloat u;
    GLfloat v;
} ccTex2F;

typedef struct _ccV3F_C4B_T2F{
	//! vertices (3F)
	ccVertex3F		vertices;			// 12 bytes
    //	char __padding__[4];
    
	//! colors (4B)
	ccColor4B		colors;				// 4 bytes
    //	char __padding2__[4];
    
	// tex coords (2F)
	ccTex2F			texCoords;			// 8 byts
}ccV3F_C4B_T2F;

typedef struct _ccV3F_C4B_T2F_Quad{
    //! top left
	ccV3F_C4B_T2F	tl;
	//! bottom left
	ccV3F_C4B_T2F	bl;
	//! top right
	ccV3F_C4B_T2F	tr;
	//! bottom right
	ccV3F_C4B_T2F	br;
}ccV3F_C4B_T2F_Quad;

@interface HLTypes : NSObject

@end
