//
//  HLGLProgram.h
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCCShader_PositionTextureColor			@"ShaderPositionTextureColor"
#define kCCShader_PositionTexture               @"ShaderPositionTexture"
#define kCCShader_PositionTextureLight          @"ShaderPositionTextureLight"
#define kCCShader_PositionColor                 @"ShaderPositionColor"
#define kCCShader_Position_uColor               @"ShaderPosition_uColor"
#define kCCShader_PositionColorLight            @"ShaderPositionColorLight"
#define kCCShader_Waves                         @"ShaderWaves"

#define	kCCAttributeNameColor			@"a_color"
#define	kCCAttributeNamePosition		@"a_position"
#define	kCCAttributeNameTexCoord		@"a_texCoord"
#define	kCCAttributeNameNormal          @"a_normal"

enum {
    kCCVertexAttrib_Position = 1<<0,
    kCCVertexAttrib_Color = 1<<1,
    kCCVertexAttrib_TexCoords = 1<<2,
    kCCVertexAttrib_Normal= 1<<3,
    
    kCCVertexAttrib_MAX,
};

enum {
	kCCUniformPMatrix,
	kCCUniformMVMatrix,
	kCCUniformMVPMatrix,
	kCCUniformTime,
	kCCUniformSinTime,
	kCCUniformCosTime,
	kCCUniformRandom01,
	kCCUniformSampler,
    
    
    kCCUniformLightPostion,
    kCCUniformLightDirection,
    kCCUniformLightAmbient,
    kCCUniformLightDiffuse,
    kCCUniformLightSpecular,
    
	kCCUniform_MAX,
};

@interface HLGLProgram : NSObject{
    GLuint _program;
    GLuint _vertShader;
    GLuint _fragShader;
    
    GLint _uniforms[kCCUniform_MAX];
}
@property (nonatomic,readonly) GLuint program;

+ (id)programWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename;

- (GLint)uniformLocationForName:(NSString*)name;
/** calls glUniform1i only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location withI1:(GLint)i1;

/** calls glUniform1f only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1;

/** calls glUniform2f only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1 f2:(GLfloat)f2;

/** calls glUniform3f only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1 f2:(GLfloat)f2 f3:(GLfloat)f3;

/** calls glUniform4f only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location withF1:(GLfloat)f1 f2:(GLfloat)f2 f3:(GLfloat)f3 f4:(GLfloat)f4;

/** calls glUniform2fv only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location with2fv:(GLfloat*)floats count:(NSUInteger)numberOfArrays;

/** calls glUniform3fv only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location with3fv:(GLfloat*)floats count:(NSUInteger)numberOfArrays;

/** calls glUniform4fv only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location with4fv:(GLvoid*)floats count:(NSUInteger)numberOfArrays;

/** calls glUniformMatrix4fv only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location withMatrix4fv:(GLvoid*)matrix_array count:(NSUInteger)numberOfMatrix;

/** calls glUniformMatrix3fv only if the values are different than the previous call for this same shader program. */
-(void) setUniformLocation:(GLint)location withMatrix3fv:(GLvoid*)matrix_array count:(NSUInteger)numberOfMatrix;


- (BOOL)link;
- (void)updateUniforms;
- (void)use;
//更新内嵌的uniforms
- (void)setUniformsForBuiltins;

- (id)initWithVertexShaderByteArray:(const GLchar *)vShaderByteArray fragmentShaderByteArray:(const GLchar *)fShaderByteArray;
- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename fragmentShaderFilename:(NSString *)fShaderFilename;

- (void)addAttribute:(NSString *)attributeName index:(GLuint)index;
@end






