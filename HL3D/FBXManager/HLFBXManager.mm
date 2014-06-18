//
//  HLFBXManager.m
//  GameEngine
//
//  Created by huxiaozhou on 14-4-14.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLFBXManager.h"
#import "HLFBXOneLoad.h"

@implementation HLFBXManager

static HLFBXManager * s_sharedFBXManager = nil;
+ (id)sharedManager{
    if (!s_sharedFBXManager) {
        s_sharedFBXManager = [[self alloc] init];
    }
    return s_sharedFBXManager;
}

- (void)dealloc{
    [_dicCache release];
    
    [super dealloc];
}

- (id)init{
    if (self = [super init]) {
        _dicCache = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    return self;
}

- (HLFBXObject*)addFBXObjectFromFile:(const char*)fileName{
    
    HLFBXOneLoad * oneLoad = [HLFBXOneLoad oneLoad];
    [oneLoad Init_and_load:fileName];
    //添加到缓存
    [_dicCache setObject:oneLoad forKey:[NSString stringWithUTF8String:fileName]];
    return [oneLoad getFBXObject];
}


@end








