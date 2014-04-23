//
//  HLTextureCache.h
//  OES
//
//  Created by tuyuer on 14-1-8.
//  Copyright (c) 2014年 tuyuer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTexture.h"

@interface HLTextureCache : NSObject{
    NSMutableDictionary * _dicTextures;
}
+ (id)sharedTextureCache;
- (HLTexture*)addImage:(NSString*)strImageName;
@end
