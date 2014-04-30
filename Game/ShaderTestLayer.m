//
//  GameLayer.m
//  GameEngine
//
//  Created by tuyuer on 14-4-10.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "ShaderTestLayer.h"
#import "HLSprite.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"
#import "HLDrawingPrimitives.h"

@implementation ShaderTestLayer

+ (HLScene*)scene{
    HLScene *scene = [HLScene scene];
	
	// 'layer' is an autorelease object.
	ShaderTestLayer *layer = [ShaderTestLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (id)node{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        beginTime = [[NSDate date] retain];
        // add a test sprite
        HLSprite * spriteTest = [HLSprite spriteWithFile:@"icon.png"];
        [spriteTest setPosition:CGPointMake(160, 240)];
        [self addChild:spriteTest];
//        [[spriteTest camera] setEyeX:0 eyeY:0 eyeZ:100];
//        [[spriteTest camera] setUpX:0 upY:1 upZ:0];
//        [[spriteTest camera] setCenterX:160 centerY:0 centerZ:0];
    }
    return self;
}

- (void)draw{
    [super draw];
    
    HLGLProgram * programShader = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_Waves];
    [programShader use];
    [programShader setUniformsForBuiltins];
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    
    ccVertex2F vertices[] =
    {
        {-320.0f,  480.0f},
        {-320.0f, -480.0f},
        { 320.0f, -480.0f},
        { 320.0f,  480.0f},
    };
    glUniform3f(glGetUniformLocation([programShader program], "iResolution"), 640 ,960, 0);
    glUniform1f(glGetUniformLocation([programShader program], "iGlobalTime"), [[NSDate date] timeIntervalSinceDate:beginTime]);

    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, sizeof(ccVertex2F), vertices);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

@end














