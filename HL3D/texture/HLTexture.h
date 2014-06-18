//
//  HLTexture.h
//  OES
//
//  Created by tuyuer on 14-1-8.
//  Copyright (c) 2014年 tuyuer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLGLProgram.h"

typedef enum {
	//! 32-bit texture: RGBA8888
	kHLTexture2DPixelFormat_RGBA8888,
	//! 32-bit texture without Alpha channel. Don't use it.
	kHLTexture2DPixelFormat_RGB888,
	//! 16-bit texture without Alpha channel
	kHLTexture2DPixelFormat_RGB565,
	//! 8-bit textures used as masks
	kHLTexture2DPixelFormat_A8,
	//! 8-bit intensity texture
	kHLTexture2DPixelFormat_I8,
	//! 16-bit textures used as masks
	kHLTexture2DPixelFormat_AI88,
	//! 16-bit textures: RGBA4444
	kHLTexture2DPixelFormat_RGBA4444,
	//! 16-bit textures: RGB5A1
	kHLTexture2DPixelFormat_RGB5A1,
	//! 4-bit PVRTC-compressed texture: PVRTC4
	kHLTexture2DPixelFormat_PVRTC4,
	//! 2-bit PVRTC-compressed texture: PVRTC2
	kHLTexture2DPixelFormat_PVRTC2,
    
	//! Default texture format: RGBA8888
	kHLTexture2DPixelFormat_Default = kHLTexture2DPixelFormat_RGBA8888,
    
} HLTexture2DPixelFormat;


@interface HLTexture : NSObject{
    GLuint                   _uName;
    CGSize                  _size;
    NSUInteger              _width,
                            _height;
    
    HLTexture2DPixelFormat  _format;
    GLfloat                 _maxS,
                            _maxT;
    
    BOOL					_hasPremultipliedAlpha;
	BOOL					_hasMipmaps;
    
    HLGLProgram             *_shaderProgram;
    
    CGSize _tContentSize;
}
@property (nonatomic,readonly) CGSize contentSize;
@property (nonatomic,readonly) GLuint Name;
@property (nonatomic,readonly) NSUInteger width;
@property (nonatomic,readonly) NSUInteger height;
@property (nonatomic,readwrite,retain) HLGLProgram *shaderProgram;
- (id)initWithImage:(UIImage *)uiImage;

/** Initializes with a texture2d with data */
- (id)initWithData:(const void*)data pixelFormat:(HLTexture2DPixelFormat)pixelFormat
         pixelWide:(NSUInteger)width pixelHigh:(NSUInteger)high contentSize:(CGSize)size;


@end









