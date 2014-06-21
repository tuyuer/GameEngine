//
//  HL3Material.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL3Foundation.h"

@interface HL3Material : NSObject{
    HL3Vector4          _color;
    HL3Vector4          _diffuse;
    HL3Vector4          _ambient;
    HL3Vector4          _specular;
    float               _shiness;
}
@property (nonatomic,assign) HL3Vector4  color;
@property (nonatomic,assign) HL3Vector4  diffuse;
@property (nonatomic,assign) HL3Vector4  ambient;
@property (nonatomic,assign) HL3Vector4  specular;
@property (nonatomic,assign) float       shiness;

+ (id)material;

+ (id)materialWithColor:(HL3Vector4)color diffuse:(HL3Vector4)diffuse
                ambient:(HL3Vector4)ambient specular:(HL3Vector4)specular
                shiness:(float)shiness;

- (id)initWithColor:(HL3Vector4)color diffuse:(HL3Vector4)diffuse
                ambient:(HL3Vector4)ambient specular:(HL3Vector4)specular
                shiness:(float)shiness;

@end
