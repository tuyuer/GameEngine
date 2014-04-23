//
//  HLShaderCache.h
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLGLProgram;
@interface HLShaderCache : NSObject{
    NSMutableDictionary	* _programs;
}

+ (id)sharedShaderCache;
- (HLGLProgram *)programForKey:(NSString*)key;
@end
