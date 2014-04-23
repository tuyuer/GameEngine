//
//  ccMacros.h
//  GameEngine
//
//  Created by tuyuer on 14-4-4.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#ifndef GameEngine_ccMacros_h
#define GameEngine_ccMacros_h

#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)


#if !defined(COCOS2D_DEBUG) || COCOS2D_DEBUG == 0
#define CHECK_GL_ERROR_DEBUG()
#else
#define CHECK_GL_ERROR_DEBUG() \
do { \
GLenum __error = glGetError(); \
if(__error) { \
CCLog("OpenGL error 0x%04X in %s %s %d\n", __error, __FILE__, __FUNCTION__, __LINE__); \
} \
} while (false)
#endif

#endif
