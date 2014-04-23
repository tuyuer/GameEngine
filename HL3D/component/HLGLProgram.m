//
//  HLGLProgram.m
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLGLProgram.h"
#import "kazmath.h"
#import "kazmath/GL/matrix.h"



@implementation HLGLProgram
@synthesize program = _program;

+ (id)programWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename{
    return [[[self alloc] initWithVertexShaderFilename:vShaderFilename fragmentShaderFilename:fShaderFilename] autorelease];
}

- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename{
    
    NSString *v = [[NSBundle mainBundle] pathForResource:vShaderFilename ofType:nil];
    NSString *f = [[NSBundle mainBundle] pathForResource:fShaderFilename ofType:nil];
    if( !(v || f) ) {
        if(!v)
            NSLog(@"Could not open vertex shader: %@", vShaderFilename);
        if(!f)
            NSLog(@"Could not open fragment shader: %@", fShaderFilename);
        return nil;
    }
    const GLchar * vertexSource = (GLchar*) [[NSString stringWithContentsOfFile:v encoding:NSUTF8StringEncoding error:nil] UTF8String];
    const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:f encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    return [self initWithVertexShaderByteArray:vertexSource fragmentShaderByteArray:fragmentSource];
}

- (id)initWithVertexShaderByteArray:(const GLchar *)vShaderByteArray fragmentShaderByteArray:(const GLchar *)fShaderByteArray
{
    if ((self = [super init]) )
    {
        _program = glCreateProgram();
		
		_vertShader = _fragShader = 0;
		
		if( vShaderByteArray ) {
			
			if (![self compileShader:&_vertShader
								type:GL_VERTEX_SHADER
						   byteArray:vShaderByteArray] )
				NSLog(@"cocos2d: ERROR: Failed to compile vertex shader");
		}
		
        // Create and compile fragment shader
		if( fShaderByteArray ) {
			if (![self compileShader:&_fragShader
								type:GL_FRAGMENT_SHADER
						   byteArray:fShaderByteArray] )
                
				NSLog(@"cocos2d: ERROR: Failed to compile fragment shader");
		}
		
		if( _vertShader )
			glAttachShader(_program, _vertShader);
		
		if( _fragShader )
			glAttachShader(_program, _fragShader);
    }
	
    return self;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type byteArray:(const GLchar *)source
{
    GLint status;
    
    if (!source)
        return NO;
    
    *shader = glCreateShader(type);

    
    const GLchar *sources[] = {
        "precision mediump float;\n"    
        "uniform mat4 CC_PMatrix;\n"
        "uniform mat4 CC_MVMatrix;\n"
        "uniform mat4 CC_MVPMatrix;\n"
        "uniform vec4 CC_Time;\n"
        "uniform vec4 CC_SinTime;\n"
        "uniform vec4 CC_CosTime;\n"
        "uniform vec4 CC_Random01;\n"
        "//CC INCLUDES END\n\n",
        source,
    };

    glShaderSource(*shader, sizeof(sources)/sizeof(*sources), sources, NULL);

    glCompileShader(*shader);
	
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
	
	if( ! status ) {
		GLsizei length;
		glGetShaderiv(*shader, GL_SHADER_SOURCE_LENGTH, &length);
		GLchar src[length];
		
		glGetShaderSource(*shader, length, NULL, src);
		NSLog(@"cocos2d: ERROR: Failed to compile shader:\n%s", src);
	}
    return ( status == GL_TRUE );
}

- (BOOL)link{
    NSAssert(_program != 0, @"Cannot link invalid program");
	
    GLint status = GL_TRUE;
    glLinkProgram(_program);
	
    if (_vertShader)
        glDeleteShader(_vertShader);
    
    if (_fragShader)
        glDeleteShader(_fragShader);
    
    _vertShader = _fragShader = 0;
	
#if DEBUG
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
	
    if (status == GL_FALSE) {
        NSLog(@"cocos2d: ERROR: Failed to link program: %i ", _program);
    }
#endif
	
    return (status == GL_TRUE);
}

- (void)updateUniforms{

}

- (void)use{
    glUseProgram(_program);
}

- (void)setUniformsForBuiltins{
    kmMat4 matrixP;
    kmMat4 matrixMV;
    
    kmGLGetMatrix(KM_GL_PROJECTION, &matrixP);
    kmGLGetMatrix(KM_GL_MODELVIEW, &matrixMV);
    
    kmMat4 matrixMVP;

    //kmMat4Multiply(&matrixMVP, &matrixMV, &matrixP);
    kmMat4Multiply(&matrixMVP, &matrixP, &matrixMV);
    
    int mvpLocation = glGetUniformLocation(_program, "CC_MVPMatrix");
    [self setUniformLocation:mvpLocation withMatrix4fv:matrixMVP.mat count:1];
}

- (GLint)uniformLocationForName:(NSString*)name
{
    NSAssert(name != nil, @"Invalid uniform name" );
    NSAssert(_program != 0, @"Invalid operation. Cannot get uniform location when program is not initialized");
    
    return glGetUniformLocation(_program, [name UTF8String]);
}

-(void) setUniformLocation:(GLint)location withI1:(GLint)i1
{
    glUniform1i( (GLint)location, i1);
}

-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1
{
    glUniform1f( (GLint)location, f1);
}

-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1 f2:(GLfloat)f2
{
    glUniform2f( (GLint)location, f1, f2);
}

-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1 f2:(GLfloat)f2 f3:(GLfloat)f3
{
    glUniform3f( (GLint)location, f1, f2, f3);
}

-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1 f2:(GLfloat)f2 f3:(GLfloat)f3 f4:(GLfloat)f4
{
    glUniform4f( (GLint)location, f1, f2, f3,f4);
}

-(void) setUniformLocation:(GLint)location with2fv:(GLfloat*)floats count:(NSUInteger)numberOfArrays
{
    glUniform2fv( (GLint)location, (GLsizei)numberOfArrays, floats );
}

-(void) setUniformLocation:(GLint)location with3fv:(GLfloat*)floats count:(NSUInteger)numberOfArrays
{
    glUniform3fv( (GLint)location, (GLsizei)numberOfArrays, floats );
}

-(void) setUniformLocation:(GLint)location with4fv:(GLvoid*)floats count:(NSUInteger)numberOfArrays
{
    glUniform4fv((GLint)location,(GLsizei)numberOfArrays,floats );
}

-(void) setUniformLocation:(GLint)location withMatrix4fv:(GLvoid*)matrixArray count:(NSUInteger)numberOfMatrices
{
    glUniformMatrix4fv( (GLint)location, (GLsizei)numberOfMatrices, GL_FALSE, matrixArray);
}


- (void)addAttribute:(NSString *)attributeName index:(GLuint)index
{
	glBindAttribLocation(_program,
						 index,
						 [attributeName UTF8String]);
}



@end
