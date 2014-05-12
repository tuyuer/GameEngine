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



//!	A 2D Quad. 4 * 2 floats
typedef struct _ccQuad2 {
	ccVertex2F		tl;
	ccVertex2F		tr;
	ccVertex2F		bl;
	ccVertex2F		br;
} ccQuad2;


//!	A 3D Quad. 4 * 3 floats
typedef struct _ccQuad3 {
	ccVertex3F		bl;
	ccVertex3F		br;
	ccVertex3F		tl;
	ccVertex3F		tr;
} ccQuad3;

//! a Point with a vertex point, a tex coord point and a color 4B
typedef struct _ccV2F_C4B_T2F
{
	//! vertices (2F)
	ccVertex2F		vertices;
	//! colors (4B)
	ccColor4B		colors;
	//! tex coords (2F)
	ccTex2F			texCoords;
} ccV2F_C4B_T2F;

//! a Point with a vertex point, a tex coord point and a color 4F
typedef struct _ccV2F_C4F_T2F
{
	//! vertices (2F)
	ccVertex2F		vertices;
	//! colors (4F)
	ccColor4F		colors;
	//! tex coords (2F)
	ccTex2F			texCoords;
} ccV2F_C4F_T2F;

//! a Point with a vertex point, a tex coord point and a color 4F
typedef struct _ccV3F_C4F_T2F
{
	//! vertices (3F)
	ccVertex3F		vertices;
	//! colors (4F)
	ccColor4F		colors;
	//! tex coords (2F)
	ccTex2F			texCoords;
} ccV3F_C4F_T2F;

//! 4 ccV3F_C4F_T2F
typedef struct _ccV3F_C4F_T2F_Quad
{
	//! top left
	ccV3F_C4F_T2F	tl;
	//! bottom left
	ccV3F_C4F_T2F	bl;
	//! top right
	ccV3F_C4F_T2F	tr;
	//! bottom right
	ccV3F_C4F_T2F	br;
} ccV3F_C4F_T2F_Quad;



//! A Triangle of ccV2F_C4B_T2F
typedef struct _ccV2F_C4B_T2F_Triangle
{
	//! Point A
	ccV2F_C4B_T2F a;
	//! Point B
	ccV2F_C4B_T2F b;
	//! Point B
	ccV2F_C4B_T2F c;
} ccV2F_C4B_T2F_Triangle;

//! A Quad of ccV2F_C4B_T2F
typedef struct _ccV2F_C4B_T2F_Quad
{
	//! bottom left
	ccV2F_C4B_T2F	bl;
	//! bottom right
	ccV2F_C4B_T2F	br;
	//! top left
	ccV2F_C4B_T2F	tl;
	//! top right
	ccV2F_C4B_T2F	tr;
} ccV2F_C4B_T2F_Quad;


//! 4 ccVertex2FTex2FColor4F Quad
typedef struct _ccV2F_C4F_T2F_Quad
{
	//! bottom left
	ccV2F_C4F_T2F	bl;
	//! bottom right
	ccV2F_C4F_T2F	br;
	//! top left
	ccV2F_C4F_T2F	tl;
	//! top right
	ccV2F_C4F_T2F	tr;
} ccV2F_C4F_T2F_Quad;

//! Blend Function used for textures
typedef struct _ccBlendFunc
{
	//! source blend function
	GLenum src;
	//! destination blend function
	GLenum dst;
} ccBlendFunc;

static inline ccColor4B ccc4BFromccc4F(ccColor4F c)
{
	return (ccColor4B){(GLubyte)(c.r*255), (GLubyte)(c.g*255), (GLubyte)(c.b*255), (GLubyte)(c.a*255)};
}

static inline CGPoint ccp( CGFloat x, CGFloat y )
{
	return CGPointMake(x, y);
}


static inline CGFloat
ccpDot(const CGPoint v1, const CGPoint v2)
{
	return v1.x*v2.x + v1.y*v2.y;
}

static inline CGPoint
ccpMult(const CGPoint v, const CGFloat s)
{
	return ccp(v.x*s, v.y*s);
}

static inline CGFloat
ccpLengthSQ(const CGPoint v)
{
	return ccpDot(v, v);
}

static inline CGFloat
ccpLength(const CGPoint v)
{
	return sqrtf(ccpLengthSQ(v));
}

static inline CGPoint
ccpNormalize(const CGPoint v)
{
	return ccpMult(v, 1.0f/ccpLength(v));
}



//! helper that creates a ccColor4f type
static inline ccColor4F ccc4f(const GLfloat r, const GLfloat g, const GLfloat b, const GLfloat a)
{
	return (ccColor4F){r, g, b, a};
}

