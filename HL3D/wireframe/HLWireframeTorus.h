//
//  HLWireframeTorus.h
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLParametricSurface.h"

@interface HLWireframeTorus : HLParametricSurface{
    float _majorRadius;
    float _minorRadius;
}

+ (id)torusWithMajorRadius:(float)majorRadius minorRadius:(float)minRadius;
- (id)initWithMajorRadius:(float)majorRadius minorRadius:(float)minRadius;
@end
