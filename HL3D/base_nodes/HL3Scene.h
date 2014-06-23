//
//  HL3Scene.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-23.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Node.h"
#import "HL3Camera.h"

@class HL3Layer;
@interface HL3Scene : HL3Node{
    NSMutableArray          *_lights;
    HL3Layer                *_hl3Layer;
    HL3Camera               *_activeCamera;
}
@property (nonatomic,assign) HL3Layer *hl3Layer;
@property (nonatomic, readonly) NSMutableArray *lights;
@property (nonatomic, retain, readwrite) HL3Camera *activeCamera;
+ (id)scene;

- (void)open;
- (void)draw3Scene;
@end
