//
//  HLsurface.h
//  GameEngine
//
//  Created by tuyuer on 14-4-11.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <vector>

using std::vector;

@protocol HLSurface <NSObject>

@required
- (int)GetVertexCount;
- (int)GetLineIndexCount;
- (int)GetTriangleIndexCount;
- (void)GenerateVertices:(vector<float>&)vertices flags:(unsigned char)flags;
- (void)GenerateLineIndices:(vector<unsigned short>&)indices;
- (void)GenerateTriangleIndices:(vector<unsigned short>&)indices;
- (BOOL)InvertNormal:(CGPoint)domain;


@optional

@end
