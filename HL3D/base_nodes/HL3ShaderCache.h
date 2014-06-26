//
//  HL3ShaderCache.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-26.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HL3ShaderProgram;
@interface HL3ShaderCache : NSObject{
    NSMutableDictionary	* _programs;
}
+ (id)sharedShaderCache;
- (HL3ShaderProgram *)programForKey:(NSString*)key;
@end
