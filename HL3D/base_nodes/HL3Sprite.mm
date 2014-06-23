//
//  HL3Sprite.m
//  GameEngine
//
//  Created by tuyuer on 14-4-14.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HL3Sprite.h"
#import "TransformUtils.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"
#import "HLGLProgram.h"
#import "kazmath/GL/matrix.h"
#import "HLTypes.h"
#import "ccMacros.h"
#import "HL3Node.h"
#import "HL3Light.h"

@implementation HL3Sprite

+ (id)spriteWithFile:(NSString*)strFileName{
    return [[[self alloc] initWithFile:strFileName] autorelease];
}
- (id)initWithFile:(NSString*)strFileName{
    if (self = [super init]) {
        _model = new HL3ModelMd2();
        _model->load([strFileName UTF8String]);
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture];
        
        _uniformHandles.u_lightDirection = [_shaderProgram uniformLocationForName:@"u_lightDirection"];
        _uniformHandles.u_lightPosition = [_shaderProgram uniformLocationForName:@"u_lightPosition"];
        _uniformHandles.u_lightAmbient = [_shaderProgram uniformLocationForName:@"u_lightAmbient"];
        _uniformHandles.u_lightDiffuse = [_shaderProgram uniformLocationForName:@"u_lightDiffuse"];
        _uniformHandles.u_lightSpecular = [_shaderProgram uniformLocationForName:@"u_lightSpecular"];
        _uniformHandles.u_lightShiness = [_shaderProgram uniformLocationForName:@"u_lightShiness"];
    }
    return self;
}

- (void)draw{
    ccGLBlendFunc(_blendFunc.src, _blendFunc.dst);
    
    [super draw];
    
    NSAssert1(_shaderProgram, @"No shader program set for node: %@", self);
    [_shaderProgram use];
	[_shaderProgram setUniformsForBuiltins];
    
    //可以设置一些光照值
    HL3Vector v4LightPos = [_light3D position3D];
    HL3Vector v4LightDir = [_light3D direction];
    
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightPosition with3fv:&v4LightPos.x count:1];
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightDirection with3fv:&v4LightDir.x count:1];
    
    
    HL3Vector4 v4LightAmbient = [_light3D ambient];
    HL3Vector4 v4LightDiffuse = [_light3D diffuse];
    HL3Vector4 v4LightSpecular = [_light3D specular];
    
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightAmbient with4fv:&v4LightAmbient.x count:1];
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightDiffuse with4fv:&v4LightDiffuse.x count:1];
    [_shaderProgram setUniformLocation:_uniformHandles.u_lightSpecular with4fv:&v4LightSpecular.x count:1];
    
    if (_bIsAnimation) {
        _model->draw([_runningAnimation currentFrame]);
    }else{
        //绘制模型
        _model->draw();
    }
}

- (void)runMD2Action:(HLMD2Animation*)md2Anim{
    _bIsAnimation = true;
    _runningAnimation = md2Anim;
    [_runningAnimation reset];
    [_runningAnimation startUpdate];
    [_runningAnimation retain];
}

- (void)stopMD2Action{
    _bIsAnimation = false;
    if (_runningAnimation) {
        [_runningAnimation release];
        _runningAnimation = nil;
    }
}

@end




