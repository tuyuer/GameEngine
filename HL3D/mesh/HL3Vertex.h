//
//  HL3Vertex.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-21.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HL3Foundation.h"

@interface HL3Vertex : NSObject{
    HL3Vector       _position;
    HL3Vector2      _textureCoord;
    HL3Vector       _normal;
    HL3Vector4      _color;
}
@property (nonatomic,assign) HL3Vector  position;
@property (nonatomic,assign) HL3Vector2 textureCoord;
@property (nonatomic,assign) HL3Vector  normal;
@property (nonatomic,assign) HL3Vector4 color;

+ (id)vertex;
+ (id)vertexWithPosition:(HL3Vector)pos color:(HL3Vector4)color texCoord:(HL3Vector2)texCoord normal:(HL3Vector)normal;
- (id)initWithPosition:(HL3Vector)pos color:(HL3Vector4)color texCoord:(HL3Vector2)texCoord normal:(HL3Vector)normal;
@end
