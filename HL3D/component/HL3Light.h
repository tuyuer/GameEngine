//
//  HL3Light.h
//  GameEngine
//
//  Created by tuyuer on 14-4-23.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL3Foundation.h"
#import "HL3Node.h"

@interface HL3Light : HL3Node{
    HL3Vector _direction;
    HL3Vector4 _diffuse;
    HL3Vector4 _ambient;
    HL3Vector4 _specular;
    float _shiness;
}
@property (nonatomic,assign) HL3Vector direction;
@property (nonatomic,assign) HL3Vector4 diffuse;
@property (nonatomic,assign) HL3Vector4 ambient;
@property (nonatomic,assign) HL3Vector4 specular;
@property (nonatomic,assign) float shiness;

+ (id)light;


@end
