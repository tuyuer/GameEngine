//
//  HL3ClippingNode.m
//  GameEngine
//
//  Created by huxiaozhou on 14-5-14.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3ClippingNode.h"
#import "kazmath/GL/matrix.h"

static GLint _stencilBits = -1;

@implementation HL3ClippingNode

@synthesize stencil = _stencil;
@synthesize alphaThreshold = _alphaThreshold;
@synthesize inverted = _inverted;

- (void)dealloc{
    [_stencil release];
    [super dealloc];
}

+ (id)clippingNode
{
    return [self node];
}

- (id)init{
    return [self initWithStencil:nil];
}

- (id)initWithStencil:(HLNode *)stencil{
    if (self = [super init]) {
        self.stencil = stencil;
        self.alphaThreshold = 1;
        self.inverted = NO;
        
        if (_stencilBits <= 0 ) {
            glGetIntegerv(GL_STENCIL_BITS, &_stencilBits);
        }
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    [_stencil onEnter];
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [_stencil onEnterTransitionDidFinish];
}

- (void)visit{
    
    if (_stencilBits < 1) {
        // draw everything, as if there where no stencil
        [super visit];
        return;
    }
    
    // return fast (draw nothing, or draw everything if in inverted mode) if:
    // - nil stencil node
    if (!_stencil) {
        if (_inverted) {
            // draw everything
            [super visit];
        }
        return;
    }
    
    //store the current stencil layer (position in the stencil buffer)
    //this will allow nesting up to n HLClippingNode
    //where n is the number of bits of the stencil buffer
    static GLint layer = -1;
    
    // all the _stencilBits are in use?
    if (layer +1 == _stencilBits) {
        // warn once
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            NSLog(@"Nesting more than %d stencils is not supported. Everything will be drawn without stencil for this node and its childs.", _stencilBits);
        });
        // draw everything, as if there where no stencil
        [super visit];
        return;
    }
    
    //increment the current layer
    layer++;
    
    //mask of the current layer (ie: for layer 3: 00000100)
    GLint mask_layer = 0x1 << layer;
    
    // mask of all layers less than the current (ie: for layer 3: 00000011)
    GLint mask_layer_l = mask_layer - 1;
    
    // mask of all layers less than or equal to the current (ie: for layer 3: 00000111)
    GLint mask_layer_le = mask_layer | mask_layer_l;
    
    
    // manually save stencil state
    GLboolean currentStencilEnabled = GL_FALSE;
    //~表示按位取反，是位运算符，运算对象是2进制。
    GLuint currentStencilWriteMask = ~0;
    GLenum currentStencilFunc = GL_ALWAYS;
    GLint currentStencilRef = 0;
    GLuint currentStencilValueMask = ~0;
    GLenum currentStencilFail = GL_KEEP;
    GLenum currentStencilPassDepthFail = GL_KEEP;
    GLenum currentStencilPassDepthPass = GL_KEEP;
    
    currentStencilEnabled = glIsEnabled(GL_STENCIL_TEST);
    
    // 读取模版缓冲状态，绘制守成后再进行恢复
    glGetIntegerv(GL_STENCIL_WRITEMASK, (GLint *)&currentStencilWriteMask);
    glGetIntegerv(GL_STENCIL_FUNC, (GLint*)&currentStencilFunc);
    glGetIntegerv(GL_STENCIL_REF, &currentStencilRef);
    glGetIntegerv(GL_STENCIL_VALUE_MASK, (GLint *)&currentStencilValueMask);
    glGetIntegerv(GL_STENCIL_FAIL, (GLint *)&currentStencilFail);
    glGetIntegerv(GL_STENCIL_PASS_DEPTH_FAIL, (GLint *)&currentStencilPassDepthFail);
    glGetIntegerv(GL_STENCIL_PASS_DEPTH_PASS, (GLint *)&currentStencilPassDepthPass);
    
    
    // enable stencil use
    glEnable(GL_STENCIL_TEST);
    
    
    // all bits on the stencil buffer are readonly, except the current layer bit,
    // this means that operation like glClear or glStencilOp will be masked with this value
    glStencilMask(mask_layer);
    
    // manually save the depth test state
    //GLboolean currentDepthTestEnabled = GL_TRUE;
    GLboolean currentDepthWriteMask = GL_TRUE;
    //currentDepthTestEnabled = glIsEnabled(GL_DEPTH_TEST);
    glGetBooleanv(GL_DEPTH_WRITEMASK, &currentDepthWriteMask);
    
    // disable depth test while drawing the stencil
    // glDisable(GL_DEPTH_TEST);
    // disable update to the depth buffer while drawing the stencil,
    // as the stencil is not meant to be rendered in the real scene,
    // it should never prevent something else to be drawn,
    // only disabling depth buffer update should do
    glDepthMask(GL_FALSE);
    
    ///////////////////////////////////
    // CLEAR STENCIL BUFFER
    
    // setup the stencil test func like this:
    // for each pixel in the stencil buffer
    //     never draw it into the frame buffer
    //     if not in inverted mode: set the current layer value to 0 in the stencil buffer
    //     if in inverted mode: set the current layer value to 1 in the stencil buffer
    glClearStencil(!_inverted ? 0 : ~0);
    glClear(GL_STENCIL_BUFFER_BIT);
    
    
    ///////////////////////////////////
    // DRAW CLIPPING STENCIL
    
    // setup the stencil test func like this:
    // for each pixel in the stencil node
    //     never draw it into the frame buffer
    //     if not in inverted mode: set the current layer value to 1 in the stencil buffer
    //     if in inverted mode: set the current layer value to 0 in the stencil buffer
    glStencilFunc(GL_NEVER, mask_layer, mask_layer);
    glStencilOp(!_inverted ? GL_REPLACE : GL_ZERO, GL_KEEP, GL_KEEP);
    
//    glStencilFunc(GL_NEVER, mask_layer, mask_layer);
//    glStencilOp(GL_REPLACE, GL_KEEP, GL_KEEP);
    
//    glStencilFunc(GL_ALWAYS, mask_layer, mask_layer);
//    glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
    
    // draw the stencil node as if it was one of our child
    // (according to the stencil test func/op and alpha (or alpha shader) test)
    kmGLPushMatrix();
    [self transform];
    [_stencil visit];
    kmGLPopMatrix();
    
    // restore alpha test state
    if (_alphaThreshold < 1) {
        // XXX: we need to find a way to restore the shaders of the stencil node and its childs
    }
    
    // restore the depth test state
    glDepthMask(currentDepthWriteMask);
    //if (currentDepthTestEnabled) {
    //    glEnable(GL_DEPTH_TEST);
    //}
    
    ///////////////////////////////////
    // DRAW CONTENT
    
    // setup the stencil test func like this:
    // for each pixel of this node and its childs
    //     if all layers less than or equals to the current are set to 1 in the stencil buffer
    //         draw the pixel and keep the current layer in the stencil buffer
    //     else
    //         do not draw the pixel but keep the current layer in the stencil buffer
    glStencilFunc(GL_EQUAL, mask_layer_le, mask_layer_le);
    glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
    
    // draw (according to the stencil test func) this node and its childs
    [super visit];
    
    ///////////////////////////////////
    // CLEANUP
    
    // manually restore the stencil state
    glStencilFunc(currentStencilFunc, currentStencilRef, currentStencilValueMask);
    glStencilOp(currentStencilFail, currentStencilPassDepthFail, currentStencilPassDepthPass);
    glStencilMask(currentStencilWriteMask);
    if (!currentStencilEnabled) {
        glDisable(GL_STENCIL_TEST);
    }
    
    // we are done using this layer, decrement
    layer--;
}


@end
