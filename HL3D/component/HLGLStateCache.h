//
//  HLGLStateCache.h
//  GameEngine
//
//  Created by tuyuer on 14-3-25.
//  Copyright (c) 2014年 hua. All rights reserved.
//


/** vertex attrib flags */
enum {
	kCCVertexAttribFlag_None		= 0,
	
	kCCVertexAttribFlag_Position	= 1 << 0,
	kCCVertexAttribFlag_Color		= 1 << 1,
	kCCVertexAttribFlag_TexCoords	= 1 << 2,
    kCCVertexAttribFlag_Normal      = 1 << 3,
	
	kCCVertexAttribFlag_PosColorTex = ( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color | kCCVertexAttribFlag_TexCoords ),
};

#ifdef __cplusplus
extern "C" {
#endif
    
/** Will enable the vertex attribs that are passed as flags.
 Possible flags:
 
 * kCCVertexAttribFlag_Position
 * kCCVertexAttribFlag_Color
 * kCCVertexAttribFlag_TexCoords
 
 These flags can be ORed. The flags that are not present, will be disabled.
 
 @since v2.0.0
 */
void ccGLEnableVertexAttribs( unsigned int flags );
    
#ifdef __cplusplus
}
#endif

