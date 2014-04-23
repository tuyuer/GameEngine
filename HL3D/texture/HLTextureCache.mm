//
//  HLTextureCache.m
//  OES
//
//  Created by tuyuer on 14-1-8.
//  Copyright (c) 2014年 tuyuer. All rights reserved.
//

#import "HLTextureCache.h"
#import "HLTextureQuad.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation HLTextureCache

static HLTextureCache * s_sharedTextureCache=nil;
+ (id)sharedTextureCache{
    if (!s_sharedTextureCache) {
        s_sharedTextureCache=[[self alloc] init];
    }
    return s_sharedTextureCache;
}

- (void)dealloc{
    [_dicTextures release];
    [super dealloc];
}

- (id)init{
    if (self=[super init]) {
        _dicTextures=[NSMutableDictionary dictionaryWithCapacity:100];
        [_dicTextures retain];
    }
    return self;
}


- (HLTexture*)addImage:(NSString*)strImageName{
    NSString * imgPath=[[NSBundle mainBundle] pathForResource:strImageName ofType:nil];
    NSAssert(imgPath, @"");
    HLTexture * tex = [_dicTextures objectForKey:imgPath];
   
    if (!tex) {
        // prevents overloading the autorelease pool
        NSString *fullpath = imgPath;
        
        UIImage *image = [ [UIImage alloc] initWithContentsOfFile: fullpath ];
        tex = [ [HLTexture alloc] initWithImage: image ];
        [image release];
        
        if( tex )
            [_dicTextures setObject: tex forKey:fullpath];
        else
            NSLog(@"cocos2d: Couldn't add image:%@ in CCTextureCache", fullpath);

        [tex autorelease];
    }
    return tex;
}

@end




























