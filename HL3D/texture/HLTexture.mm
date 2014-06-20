//
//  HLTexture.m
//  OES
//
//  Created by tuyuer on 14-1-8.
//  Copyright (c) 2014年 tuyuer. All rights reserved.
//

#import "HLTexture.h"
#import "TransformUtils.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"

@implementation HLTexture
@synthesize contentSize = _tContentSize;
@synthesize Name = _uName;
@synthesize shaderProgram = _shaderProgram;
@synthesize width = _width;
@synthesize height = _height;

- (id) initWithImage:(UIImage *)uiImage{
    if (self = [super init]) {
        CGImageRef spriteImage=uiImage.CGImage;
        size_t imgWidth = CGImageGetWidth(spriteImage);
        size_t imgHeight= CGImageGetHeight(spriteImage);
        
        _tContentSize = CGSizeMake(imgWidth, imgHeight);
        
        GLubyte * imageData=(GLubyte *)calloc(_tContentSize.width*_tContentSize.height*4, sizeof(GLubyte));

        CGContextRef spriteContext=CGBitmapContextCreate(imageData, _tContentSize.width, _tContentSize.height, 8, _tContentSize.width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        
        //flip the core graphic context
        CGContextTranslateCTM(spriteContext, 0, imgHeight);
        CGContextScaleCTM(spriteContext, 1.0, -1.0);
        
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, imgWidth, imgHeight), spriteImage);
        CGContextRelease(spriteContext);
        
        self = [self initWithData:imageData pixelFormat:kHLTexture2DPixelFormat_RGBA8888 pixelWide:imgWidth pixelHigh:imgHeight contentSize:_tContentSize];

        return self;
    }
    return nil;
}


- (id)initWithData:(const void*)data pixelFormat:(HLTexture2DPixelFormat)pixelFormat
         pixelWide:(NSUInteger)width pixelHigh:(NSUInteger)high contentSize:(CGSize)size{

    if (self = [super init]) {
        // XXX: 32 bits or POT textures uses UNPACK of 4 (is this correct ??)
        if (pixelFormat == kHLTexture2DPixelFormat_RGBA8888 ||
            pixelFormat == (hlNextPOT(width)==width && hlNextPOT(high)==high)) {
            glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
        }else{
            glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        }
        
        glGenTextures(1, &_uName);
        glBindTexture(GL_TEXTURE_2D, _uName);
        
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
        
        // Specify OpenGL texture image
        switch (pixelFormat) {
            case kHLTexture2DPixelFormat_RGBA8888:
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei) width, (GLsizei) high, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
                break;
                
            default:
                break;
        }
        
        _size = size;
        _tContentSize = size;
        _width = width;
        _height = high;
        _format = pixelFormat;
        
        _hasPremultipliedAlpha = NO;
		_hasMipmaps = NO;
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture];
    }
    return self;
}

-(void) generateMipmap
{
	NSAssert( _width == hlNextPOT(_width) && _height == hlNextPOT(_height), @"Mimpap texture only works in POT textures");
	glBindTexture(GL_TEXTURE_2D, _uName );
	glGenerateMipmap(GL_TEXTURE_2D);
	_hasMipmaps = YES;
}


-(void) setAliasTexParameters
{
	glBindTexture(GL_TEXTURE_2D, _uName );
	
	if( ! _hasMipmaps )
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
	else
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST );
    
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
}

-(void) setAntiAliasTexParameters
{
	glBindTexture(GL_TEXTURE_2D, _uName );
	
	if( ! _hasMipmaps )
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	else
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST );
    
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
}


@end



















