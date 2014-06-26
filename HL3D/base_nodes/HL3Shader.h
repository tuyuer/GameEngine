//
//  HL3Shader.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-26.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Identifiable.h"

/**
 * HL3Shader represents an OpenGL shader, complied from GLSL source code
 * HL3Shader is an abstract class. You should instantiate one of the concrete classes:
 * HL3VertexShader or HL3FragmentShader.
 * In most cases, you will create an instance of one of these subclasses by loading and
 * compiling GLSL code from a file using the shaderFromSourceCodeFile: method.
 * Since a single shader can be used by more than one shader program, shaders are cached.
 * The application can use the class-side getShaderNamed: method to retrieve a compiled shader
 * from the cache, and the class-side addShader: method to add a new shader to the cache.
 * The shaderFromSourceCodeFile: method automatically retrieves existing instances from the
 * cache and adds any new instances to the cache.
 */


@interface HL3Shader : HL3Identifiable{
    GLuint _shaderID;
    NSString * _shaderPreamble;
}
@property (nonatomic,readonly) GLuint shaderID;
@property (nonatomic, retain) NSString* shaderPreamble;
@property (nonatomic, readonly) NSString* defaultShaderPreamble;

// returns the type of shader either GL_VERTEX_SHADER or GL_FRAGMENT_SHADER
- (GLenum)shaderType;

#pragma mark Compiling
-(void) compileFromSource: (NSString*) glslSource;

#pragma mark Allocation and initialization
-(id) initWithName: (NSString*) name fromSourceCode: (NSString*) glslSource;
-(id) initFromSourceCodeFile: (NSString*) aFilePath;
+(id) shaderFromSourceCodeFile: (NSString*) aFilePath;
+(NSString*) shaderNameFromFilePath: (NSString*) aFilePath;
-(NSString*) constructorDescription;

#pragma mark Shader cache
-(void) remove;
+(void) addShader: (HL3Shader*) shader;
+(HL3Shader*) getShaderNamed: (NSString*) name;
+(void) removeShader: (HL3Shader*) shader;
+(void) removeShaderNamed: (NSString*) name;
+(void) removeAllShaders;
+(BOOL) isPreloading;
+(void) setIsPreloading: (BOOL) isPreloading;
+(NSString*) cachedShadersDescription;

@end





















