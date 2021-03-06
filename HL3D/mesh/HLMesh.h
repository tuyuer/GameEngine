//
//  HLMesh.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Node.h"
#import "HL3Material.h"
#import "HL3IndexVBO.h"

@interface HLMesh : HL3Node{
    HL3Material * _material;
    HL3IndexVBO * _indexVBO;
}

+ (id)mesh;

@end
