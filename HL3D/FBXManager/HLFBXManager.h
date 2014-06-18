//
//  HLFBXManager.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-14.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLFBXObject.h"


@interface HLFBXManager : NSObject{
    NSMutableDictionary * _dicCache;
}

+ (id)sharedManager;
- (HLFBXObject*)addFBXObjectFromFile:(const char*)fileName;
@end
