//
//  HL3Node.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-26.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Node.h"
#import "HL3Camera.h"
#import "HL3Scene.h"

@implementation HL3Node
@synthesize parent=_parent, children=_children;
@synthesize location=_location;
@synthesize scale=_scale;
@synthesize visible = _visible;
@synthesize isRunning=_isRunning;
@synthesize isTransformDirty=_isTransformDirty;


+(id) node { return [[[self alloc] init] autorelease]; }
+(id) nodeWithTag: (GLuint) aTag { return [[[self alloc] initWithTag: aTag] autorelease]; }


-(HL3Scene*) scene {
    return _parent.scene;
}

-(HL3Camera*) activeCamera {
    return self.scene.activeCamera;
}

-(HL3Vector) rotation {
//    return _rotator.rotation;
    return hl3v(0, 0, 0);
}

@end
