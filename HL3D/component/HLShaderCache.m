//
//  HLShaderCache.m
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLShaderCache.h"
#import "HLGLProgram.h"

@implementation HLShaderCache

static HLShaderCache * s_sharedShaderCache = nil;
+ (id)sharedShaderCache{
    if (!s_sharedShaderCache) {
        s_sharedShaderCache = [[HLShaderCache alloc] init];
    }
    return s_sharedShaderCache;
}

- (id)init{
    if (self = [super init]) {
        _programs = [NSMutableDictionary dictionaryWithCapacity:100];
        [_programs retain];
        
        [self loadDefaultShaders];
        return self;
    }
    return nil;
}

- (void)loadDefaultShaders{
    
    // shader for Position Color
    HLGLProgram *p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShader_PositionColor.vert" fragmentShaderFilename:@"ccShader_PositionColor.frag"];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    
    [p link];
    [p updateUniforms];
    [_programs setObject:p forKey:kCCShader_PositionColor];
    [p release];
    
    
    //
	// Position, Legth(TexCoords, Color (used by Draw Node basically )
	//
	p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShader_PositionColorLengthTexture.vert"
								   fragmentShaderFilename:@"ccShader_PositionColorLengthTexture.frag"];
	
	[p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
	[p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [_programs setObject:p forKey:kCCShader_PositionColorLengthTexture];
    [p link];
    [p updateUniforms];
    [p release];
    
    //shader for Position Texture Color
    p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShader_PositionTextureColor.vert" fragmentShaderFilename:@"ccShader_PositionTextureColor.frag"];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    
    [p link];
    [p updateUniforms];
    [_programs setObject:p forKey:kCCShader_PositionTextureColor];
    [p release];
    
    //shader for Position Texture
    p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShader_PositionTexture.vert" fragmentShaderFilename:@"ccShader_PositionTexture.frag"];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    
    [p link];
    [p updateUniforms];
    [_programs setObject:p forKey:kCCShader_PositionTexture];
    [p release];
    
    //shader for Position Texture Light
    p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShader_PositionTextureLight.vert" fragmentShaderFilename:@"ccShader_PositionTextureLight.frag"];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [p addAttribute:kCCAttributeNameNormal index:kCCVertexAttrib_Normal];
    
    [p link];
    [p updateUniforms];
    [_programs setObject:p forKey:kCCShader_PositionTextureLight];
    [p release];
    
    
    
    //shader for Position uColor
    p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShader_Position_uColor.vert" fragmentShaderFilename:@"ccShader_Position_uColor.frag"];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    
    [p link];
    [p updateUniforms];
    [_programs setObject:p forKey:kCCShader_Position_uColor];
    [p release];
    
    
    //shader for Position uColor
    p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShader_PositionColorLight.vert" fragmentShaderFilename:@"ccShader_PositionColorLight.frag"];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p addAttribute:kCCAttributeNameNormal index:kCCVertexAttrib_Normal];
    
    [p link];
    [p updateUniforms];
    [_programs setObject:p forKey:kCCShader_PositionColorLight];
    [p release];
    
    
    //shader for Position uColor
    p = [[HLGLProgram alloc] initWithVertexShaderFilename:@"ccShaderWaves.vert"
                                   fragmentShaderFilename:@"ccShaderWaves.frag"];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p link];
    [p updateUniforms];
    [_programs setObject:p forKey:kCCShader_Waves];
    [p release];
    
    

}

- (HLGLProgram *)programForKey:(NSString*)key
{
	return [_programs objectForKey:key];
}

@end

















