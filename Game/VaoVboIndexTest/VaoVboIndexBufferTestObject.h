//
//  VaoVboIndexBufferTestObject.h
//  GameEngine
//
//  Created by Tuyuer on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLNode.h"
#import "HL3IndexVBO.h"

@interface VaoVboIndexBufferTestObject : HLNode{
    HL3IndexVBO * _indexVBO;
    BOOL _dirty;
}

@end
