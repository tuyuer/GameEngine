//
//  HL3Light.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL3Foundation.h"

@interface HL3Light : NSObject{
    HL3Vector _direction;
    HL3Vector _position;
    HL3Vector4 _diffuse;
    HL3Vector4 _ambient;
    HL3Vector4 _specular;
    float _shiness;
    
}
@property (nonatomic,assign) HL3Vector direction;
@property (nonatomic,assign) HL3Vector position;
@property (nonatomic,assign) HL3Vector4 diffuse;
@property (nonatomic,assign) HL3Vector4 ambient;
@property (nonatomic,assign) HL3Vector4 specular;
@property (nonatomic,assign) float shiness;

+ (id)light;


@end
