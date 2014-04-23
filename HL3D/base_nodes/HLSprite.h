//
//  HLSprite.h
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLNode.h"
#import "HLTextureCache.h"
#import "HLTexture.h"
#import "HLTypes.h"

@interface HLSprite : HLNode{
    HLTexture * _texture;
    ccV3F_C4B_T2F_Quad _quad;
    
    //texture rect
    CGRect _rect;
}

@property (nonatomic,assign) HLTexture * texture;

+ (id)spriteWithFile:(NSString*)strFileName;
- (id)initWithTexture:(HLTexture*)texture rect:(CGRect)rect;
@end
