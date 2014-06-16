//
//  HLGridBase.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-6.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLNode.h"
#import "HLTexture.h"
#import "HLGrabber.h"
#import "HLDirector.h"

@interface HLGridBase : NSObject{
    BOOL            _active;
    int             _reuseGrid;
    CGSize          _gridSize;
    HLTexture *     _texture;
    CGPoint         _step;
    HLGrabber *     _grabber;
    BOOL            _isTextureFlipped;
    HLGLProgram *   _shaderProgram;
    
    hlDirectorProjection _directorProjection;
}

/* whether or not the grid is active */
@property (nonatomic,readwrite) BOOL active;

/* number of times that the grid will be reuse */
@property (nonatomic,readwrite) int reuseGrid;

/* size of the grid */
@property (nonatomic,readonly) CGSize gridSize;

/* pixels between the grids */
@property (nonatomic,readwrite) CGPoint step;

/* texture used */
@property (nonatomic,retain) HLTexture * texture;

/* grabber used */
@property (nonatomic,retain) HLGrabber * grabber;

/** is texture flipped */
@property (nonatomic,readwrite) BOOL isTextureFlipped;

/** shader program */
@property (nonatomic, readwrite, assign) HLGLProgram *shaderProgram;


+(id)gridWithSize:(CGSize)gridSize texture:(HLTexture*)texture flippedTexture:(BOOL)flipped;
+(id)gridWithSize:(CGSize)gridSize;

-(id)initWithSize:(CGSize)gridSize texture:(HLTexture*)texture flippedTexture:(BOOL)flipped;
-(id)initWithSize:(CGSize)gridSize;
-(void)beforeDraw;
-(void)afterDraw:(HLNode*)target;
-(void)blit;
-(void)reuse;

-(void)calculateVertexPoints;

@end












