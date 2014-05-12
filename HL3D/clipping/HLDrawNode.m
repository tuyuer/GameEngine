//
//  HLDrawNode.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-11.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLDrawNode.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"

// ccVertex2F == CGPoint in 32-bits, but not in 64-bits (OS X)
// that's why the "v2f" functions are needed
static ccVertex2F v2fzero = (ccVertex2F){0,0};

static inline ccVertex2F v2f( float x, float y )
{
	return (ccVertex2F){x,y};
}

static inline ccVertex2F v2fadd( ccVertex2F v0, ccVertex2F v1 )
{
	return v2f( v0.x+v1.x, v0.y+v1.y );
}

static inline ccVertex2F v2fsub( ccVertex2F v0, ccVertex2F v1 )
{
	return v2f( v0.x-v1.x, v0.y-v1.y );
}

static inline ccVertex2F v2fmult( ccVertex2F v, float s )
{
	return v2f( v.x * s, v.y * s );
}

static inline ccVertex2F v2fperp( ccVertex2F p0 )
{
	return v2f( -p0.y, p0.x );
}

static inline ccVertex2F v2fneg( ccVertex2F p0 )
{
	return v2f( -p0.x, - p0.y );
}

static inline float v2fdot(ccVertex2F p0, ccVertex2F p1)
{
	return  p0.x * p1.x + p0.y * p1.y;
}

static inline ccVertex2F v2fforangle( float _a_)
{
	return v2f( cosf(_a_), sinf(_a_) );
}



static inline ccVertex2F __v2f(CGPoint v )
{
#ifdef __LP64__
	return v2f(v.x, v.y);
#else
	return * ((ccVertex2F*) &v);
#endif
}

static inline ccTex2F __t(ccVertex2F v )
{
	return *(ccTex2F*)&v;
}



@implementation HLDrawNode
@synthesize blendFunc = _blendFunc;


-(void)ensureCapacity:(NSUInteger)count
{
	if(_bufferCount + count > _bufferCapacity){
		_bufferCapacity += MAX(_bufferCapacity, count);
		_buffer = realloc(_buffer, _bufferCapacity*sizeof(ccV2F_C4B_T2F));
		
		NSLog(@"Resized vertex buffer to %d", _bufferCapacity);
	}
}

- (id)init{
    if (self = [super init]) {
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionColorLengthTexture];
        
        [self ensureCapacity:512];
        
        glGenVertexArraysOES(1, &_vao);
        glBindVertexArrayOES(_vao);
        
        glGenBuffers(1, &_vbo);
        glBindBuffer(GL_ARRAY_BUFFER, _vbo);
        glBufferData(GL_ARRAY_BUFFER, sizeof(ccV2F_C4B_T2F)*_bufferCapacity, _buffer, GL_STREAM_DRAW);
        
        glEnableVertexAttribArray(kCCVertexAttrib_Position);
        glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, sizeof(ccV2F_C4B_T2F), (GLvoid *)offsetof(ccV2F_C4B_T2F, vertices));
        
        glEnableVertexAttribArray(kCCVertexAttrib_Color);
        glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(ccV2F_C4B_T2F), (GLvoid *)offsetof(ccV2F_C4B_T2F, colors));
        
        glEnableVertexAttribArray(kCCVertexAttrib_TexCoords);
		glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, sizeof(ccV2F_C4B_T2F), (GLvoid *)offsetof(ccV2F_C4B_T2F, texCoords));
    
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArrayOES(0);
        
        _dirty = YES;
    }
    
    return self;
}

-(void)dealloc
{
	
	free(_buffer); _buffer = NULL;
	
	glDeleteBuffers(1, &_vbo);
    _vbo = 0;
    
	glDeleteVertexArraysOES(1, &_vao);
    _vao = 0;
	
	[super dealloc];
}

-(void)render{
    if (_dirty) {
        glBindBuffer(GL_ARRAY_BUFFER, _vbo);
        glBufferData(GL_ARRAY_BUFFER, sizeof(ccV2F_C4B_T2F)*_bufferCapacity, _buffer, GL_STREAM_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        _dirty = NO;
    }
    
    glBindVertexArrayOES(_vao);
    glDrawArrays(GL_TRIANGLES, 0, _bufferCount);
    glBindVertexArrayOES(0);
}

- (void)draw{

    [_shaderProgram use];
    [_shaderProgram setUniformsForBuiltins];
    
    [self render];
    
}


//draw
-(void)drawDot:(CGPoint)pos radius:(CGFloat)radius color:(ccColor4F)color;
{
	NSUInteger vertex_count = 2*3;
	[self ensureCapacity:vertex_count];
	
	ccV2F_C4B_T2F a = {{pos.x - radius, pos.y - radius}, ccc4BFromccc4F(color), {-1.0, -1.0} };
	ccV2F_C4B_T2F b = {{pos.x - radius, pos.y + radius}, ccc4BFromccc4F(color), {-1.0,  1.0} };
	ccV2F_C4B_T2F c = {{pos.x + radius, pos.y + radius}, ccc4BFromccc4F(color), { 1.0,  1.0} };
	ccV2F_C4B_T2F d = {{pos.x + radius, pos.y - radius}, ccc4BFromccc4F(color), { 1.0, -1.0} };
	
	ccV2F_C4B_T2F_Triangle *triangles = (ccV2F_C4B_T2F_Triangle *)(_buffer + _bufferCount);
	triangles[0] = (ccV2F_C4B_T2F_Triangle){a, b, c};
	triangles[1] = (ccV2F_C4B_T2F_Triangle){a, c, d};
	
	_bufferCount += vertex_count;
	
	_dirty = YES;
}


- (void)clear{
    _bufferCount = 0;
    _dirty = YES;
}

@end























