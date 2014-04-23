//
//  CCDrawingPrimitives.m
//  GameEngine
//
//  Created by tuyuer on 14-4-10.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLDrawingPrimitives.h"
#import "HLShaderCache.h"
#import "HLTypes.h"
#import "HLGLStateCache.h"

static BOOL initialized = NO;
static int colorLocation_ = -1;
static int pointSizeLocation_ = -1;
static HLGLProgram * shader_ = nil;
static ccColor4F color_ = {1,0,0,1};
static GLfloat pointSize_ = 1;


static void lazy_init( void ){
    if ( ! initialized ) {
        
        shader_ = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_Position_uColor];
        [shader_ retain];
        
        colorLocation_ = glGetUniformLocation([shader_ program], "u_color");
        pointSizeLocation_ = glGetUniformLocation([shader_ program], "u_pointSize");
        
        initialized = YES;
    }
}

void hlDrawInit(void)
{
	lazy_init();
}

void hlDrawPoint( CGPoint point ){
    lazy_init();
    
    ccVertex2F p = (ccVertex2F){point.x, point.y};
   
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    
    [shader_ use];
    [shader_ setUniformsForBuiltins];
    
    [shader_ setUniformLocation:colorLocation_ with4fv:(GLfloat*)&color_.r count:1];
    [shader_ setUniformLocation:pointSizeLocation_ withF1:pointSize_];
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, &p);
	glDrawArrays(GL_POINTS, 0, 1);
}


void hlDrawLine( CGPoint origin, CGPoint destination )
{
	lazy_init();
    
	ccVertex2F vertices[2] = {
		{origin.x, origin.y},
		{destination.x, destination.y}
	};
    
	[shader_ use];
	[shader_ setUniformsForBuiltins];
	[shader_ setUniformLocation:colorLocation_ with4fv:(GLfloat*) &color_.r count:1];
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
	glDrawArrays(GL_LINES, 0, 2);
	
}

void hlDrawRect( CGPoint origin, CGPoint destination )
{
	hlDrawLine(CGPointMake(origin.x, origin.y), CGPointMake(destination.x, origin.y));
	hlDrawLine(CGPointMake(destination.x, origin.y), CGPointMake(destination.x, destination.y));
	hlDrawLine(CGPointMake(destination.x, destination.y), CGPointMake(origin.x, destination.y));
	hlDrawLine(CGPointMake(origin.x, destination.y), CGPointMake(origin.x, origin.y));
}

void hlDrawColor4F( GLfloat r, GLfloat g, GLfloat b, GLfloat a )
{
	color_ = (ccColor4F) {r, g, b, a};
}

void hlDrawColor4B( GLubyte r, GLubyte g, GLubyte b, GLubyte a )
{
	color_ =  (ccColor4F) {r/255.0f, g/255.0f, b/255.0f, a/255.0f};
}

void ccPointSize( GLfloat pointSize )
{
	pointSize_ = pointSize ;
}















