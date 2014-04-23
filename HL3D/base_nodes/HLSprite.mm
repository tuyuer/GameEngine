//
//  HLSprite.m
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLSprite.h"
#import "HLGLProgram.h"
#import "kazmath.h"
#import "kazmath/GL/matrix.h"
#import "HLGLStateCache.h"
#import "HLShaderCache.h"

@implementation HLSprite
@synthesize texture = _texture;

+ (id)spriteWithFile:(NSString*)strFileName{
    return [[[self alloc] initWithFile:strFileName] autorelease];
}

- (void)dealloc{
    [_texture release];
    [super dealloc];
}

- (id)initWithFile:(NSString*)strFileName{
    if (self = [super init]) {
        NSAssert(strFileName != nil, @"");
        
        HLTexture * texture = [[HLTextureCache sharedTextureCache] addImage:strFileName];
        if (texture) {
            CGRect rect = CGRectZero;
            rect.size = texture.contentSize;
            return [self initWithTexture:texture rect:rect];
        }
        NSAssert(_texture != nil, @"");
        return self;
    }
    return nil;
}

- (void)setTexture:(HLTexture *)texture{
    if (texture != _texture) {
        [_texture release];
        _texture = [texture retain];
        
        float x1 = _position.x;
		float y1 = _position.y;
		float x2 = x1 + _rect.size.width;
		float y2 = y1 + _rect.size.height;
        
		// Don't update Z.
		_quad.bl.vertices = (ccVertex3F) { x1, y1, 0 };
		_quad.br.vertices = (ccVertex3F) { x2, y1, 0 };
		_quad.tl.vertices = (ccVertex3F) { x1, y2, 0 };
		_quad.tr.vertices = (ccVertex3F) { x2, y2, 0 };
    }
}

- (id)initWithTexture:(HLTexture*)texture rect:(CGRect)rect{
    if (self = [super init]) {
        //设置program
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionTextureColor];
        
        //texture rect
        _rect = rect;
        
        //清空纹理四边形
        bzero(&_quad, sizeof(_quad));
        
        //设置纹理四边形的初始颜色
        ccColor4B tmpColor = {255, 255, 255,255};
        _quad.bl.colors = tmpColor;
		_quad.br.colors = tmpColor;
		_quad.tl.colors = tmpColor;
		_quad.tr.colors = tmpColor;

        //初始化纹理四边形的纹理数据
        //由于还没有使用纹理贴图集,所以以1做为纹理边界
        _quad.bl.texCoords = (ccTex2F) { 0, 0};
        _quad.br.texCoords = (ccTex2F) { 1, 0};
        _quad.tl.texCoords = (ccTex2F) { 0, 1};
        _quad.tr.texCoords = (ccTex2F) { 1, 1};

        //设置纹理
        [self setTexture:texture];
        
        self.contentSize = rect.size;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        return self;
    }
    return nil;
}

- (void)setPosition:(CGPoint)position{
    [super setPosition:position];
}

- (void)updateTransform{
    //only call this method when its parent is batch node
    
    CGSize texSize = _texture.contentSize;
    float x1 = _position.x;
    float y1 = _position.y;
    float x2 = _position.x + texSize.width;
    float y2 = _position.y + texSize.height;
    
    x1 = x1 - texSize.width * _anchorPoint.x;
    x2 = x2 - texSize.width * _anchorPoint.x;
    
    y1 = y1 - texSize.height * _anchorPoint.y;
    y2 = y2 - texSize.height * _anchorPoint.y;
    
    _quad.bl.vertices = (ccVertex3F) { x1, y1, 0};
    _quad.br.vertices = (ccVertex3F) { x2, y1, 0 };
    _quad.tl.vertices = (ccVertex3F) { x1, y2, 0 };
    _quad.tr.vertices = (ccVertex3F) { x2, y2, 0 };
}


- (void)draw{
    
    NSAssert1(_shaderProgram, @"No shader program set for node: %@", self);	
    [_shaderProgram use];
	[_shaderProgram setUniformsForBuiltins];
    
    //绑定纹理
    glBindTexture(GL_TEXTURE_2D, [_texture Name]);
    
    //设置绘图状态
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_PosColorTex);
#define kQuadSize sizeof(_quad.bl)
    long offset = (long)&_quad;

    
	// vertex
	NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
	// texCoods
	diff = offsetof( ccV3F_C4B_T2F, texCoords);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
	// color
	diff = offsetof( ccV3F_C4B_T2F, colors);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));

    //开始绘制
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end











