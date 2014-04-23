//
//  HLWireframeMobiusStrip.h
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLParametricSurface.h"

@interface HLWireframeMobiusStrip : HLParametricSurface{
    float _scale;
}

+ (id)MobiusStripWithScale:(float)scaleValue;
- (id)initWithScale:(float)scaleValue;

@end
