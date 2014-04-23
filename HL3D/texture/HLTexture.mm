//
//  HLTexture.m
//  OES
//
//  Created by tuyuer on 14-1-8.
//  Copyright (c) 2014年 tuyuer. All rights reserved.
//

#import "HLTexture.h"

@implementation HLTexture
@synthesize contentSize = _tContentSize;
@synthesize Name = _uName;

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
        
        GLuint textureName;
        glGenTextures(1, &textureName);
        glBindTexture(GL_TEXTURE_2D, textureName);
        
        //如果启用NPOT，设置如下参数 ...
        glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _tContentSize.width, _tContentSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        
        //开启纹理
        glEnable(GL_TEXTURE_2D);
        //纹理混合
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        glEnable(GL_BLEND);
        
        _uName = textureName;
        return self;
    }
    return nil;
}

@end
