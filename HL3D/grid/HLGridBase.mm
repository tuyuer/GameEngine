//
//  HLGridBase.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-6.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLGridBase.h"
#import "HLShaderCache.h"
#import "TransformUtils.h"
#import "HLEGLView.h"
#import "HLDirector.h"

#import "kazmath/GL/matrix.h"
#import "TransformUtils.h"

@implementation HLGridBase
@synthesize reuseGrid = _reuseGrid;
@synthesize texture = _texture;
@synthesize grabber = _grabber;
@synthesize gridSize = _gridSize;
@synthesize step = _step;
@synthesize shaderProgram = _shaderProgram;

+(id) gridWithSize:(CGSize)gridSize texture:(HLTexture*)texture flippedTexture:(BOOL)flipped
{
	return [[[self alloc] initWithSize:gridSize texture:texture flippedTexture:flipped] autorelease];
}

+(id) gridWithSize:(CGSize)gridSize
{
	return [[(HLGridBase*)[self alloc] initWithSize:gridSize] autorelease];
}

-(id) initWithSize:(CGSize)gridSize texture:(HLTexture*)texture flippedTexture:(BOOL)flipped{
    if (self = [super init]) {
        _active = NO;
        _reuseGrid = 0;
        _gridSize = gridSize;
        
        self.texture = texture;
        _isTextureFlipped = flipped;
        
        CGSize texSize = [_texture contentSize];
//        CGSize texSize = CGSizeMake(_texture.width, _texture.height);
        _step.x = texSize.width / _gridSize.width;
        _step.y = texSize.height / _gridSize.height;
        
        _grabber = [[HLGrabber alloc] init];
        [_grabber grab:_texture];
        
        self.shaderProgram = [[HLShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture];
        [self calculateVertexPoints];
    }
    
    return self;
}

- (id)initWithSize:(CGSize)gridSize{

    HLDirector * director = [HLDirector sharedDirector];
    CGSize s = [director winSize];
    
    unsigned long POTWide = hlNextPOT(s.width);
    unsigned long POTHigh = hlNextPOT(s.height);
    
    // bytes per pixel
    int bpp = 4;
    void * data = calloc((size_t)(POTWide*POTHigh*bpp), 1);
    
    if (!data) {
        NSLog(@"HLGrid: not enough memory");
        [self release];
        return nil;
    }
    
    HLTexture * texture = [[HLTexture alloc] initWithData:data pixelFormat:kHLTexture2DPixelFormat_RGBA8888 pixelWide:POTWide pixelHigh:POTHigh contentSize:s];
    free(data);
    
    if (!texture) {
        [self release];
        return nil;
    }
    
    self = [self initWithSize:gridSize texture:texture flippedTexture:NO];
    [texture release];
    
    return self;
}

-(void)set2DProjection
{
	HLDirector *director = [HLDirector sharedDirector];

	CGSize	size = [director winSize];

	glViewport(0, 0, size.width, size.height);
	kmGLMatrixMode(KM_GL_PROJECTION);
	kmGLLoadIdentity();

	kmMat4 orthoMatrix;
	kmMat4OrthographicProjection(&orthoMatrix, 0, size.width, 0, size.height, -1, 1);
	kmGLMultMatrix( &orthoMatrix );
	
	kmGLMatrixMode(KM_GL_MODELVIEW);
	kmGLLoadIdentity();

}

-(void)beforeDraw{
    // save projection
    HLDirector * director = [HLDirector sharedDirector];
    _directorProjection = [director projection];
    
    //
    [self set2DProjection];
    
    [_grabber beforeRender:_texture];
}

-(void)afterDraw:(HLNode*)target{
    [_grabber afterRender:_texture];
    
    //restore projection
    HLDirector * director = [HLDirector sharedDirector];
    [director setProjection:_directorProjection];
    
    if ( target.camera.dirty ) {
        CGPoint offset = [target anchorPointInPoints];
        
        // Camera should be applied in AnchorPoint
        kmGLTranslatef(offset.x, offset.y, 0);
        [target.camera locate];
        kmGLTranslatef(-offset.x, -offset.y, 0);
    }
    
    glBindTexture(GL_TEXTURE_2D, _texture.Name);
    [self blit];
}


-(void)blit
{
	[NSException raise:@"GridBase" format:@"Abstract class needs implementation"];
}

-(void)reuse
{
	[NSException raise:@"GridBase" format:@"Abstract class needs implementation"];
}

-(void)calculateVertexPoints
{
	[NSException raise:@"GridBase" format:@"Abstract class needs implementation"];
}



@end


















