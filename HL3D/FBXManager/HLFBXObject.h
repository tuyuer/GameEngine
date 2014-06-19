//
//  HLFBXObject.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-15.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <iostream>
#include <vector>
#import "HL3Node.h"
#import "HL3Foundation.h"
using namespace std;

@interface HLFBXObject : HL3Node{
    std::vector<HL3Vector> * _vertices;
    std::vector<HL3Vector4> * _colors;
}
@property (nonatomic,readonly) std::vector<HL3Vector> * vertices;
@property (nonatomic,readonly) std::vector<HL3Vector4> * colors;

@end
