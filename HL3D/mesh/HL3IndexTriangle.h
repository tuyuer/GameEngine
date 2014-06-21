//
//  HL3IndexTriangle.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HL3IndexTriangle : NSObject{
    int     vertexIndex[3];
}

+ (id)indexTriangle;
- (void)setIndexes:(int)indexOne two:(int)indexTwo three:(int)indexThree;
- (int*)vertexIndex;
@end
