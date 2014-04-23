//
//  HL3Sprite.m
//  GameEngine
//
//  Created by huxiaozhou on 14-4-14.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Sprite.h"
#import "TransformUtils.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"
#import "HLGLProgram.h"
#import "kazmath/GL/matrix.h"
#import "HLTypes.h"
#import "ccMacros.h"

@implementation HL3Sprite

+ (id)spriteWithFile:(NSString*)strFileName{
    return [[[self alloc] initWithFile:strFileName] autorelease];
}
- (id)initWithFile:(NSString*)strFileName{
    if (self = [super init]) {
        _model = new HL3ModelMd2();
        _model->load([strFileName UTF8String]);
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture];
    }
    return self;
}

- (void)draw{
    [super draw];
    
    NSAssert1(_shaderProgram, @"No shader program set for node: %@", self);
    [_shaderProgram use];
	[_shaderProgram setUniformsForBuiltins];
    
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




