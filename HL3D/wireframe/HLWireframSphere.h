//
//  HLWireframSphere.h
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import "HLParametricSurface.h"

@interface HLWireframSphere : HLParametricSurface{
    float _radius;
}

+ (id)sphereWithRadius:(float)radius;
@end
