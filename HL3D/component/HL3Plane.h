//
//  HL3Plane.h
//  GameEngine
//
//  Created by Tuyuer on 14-6-22.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#ifndef GameEngine_HL3Plane_h
#define GameEngine_HL3Plane_h

#import "HL3Foundation.h" 

/** 一个三维空间中平面公式里的系数 (ax + by + cz + d = 0). */
typedef struct {
	GLfloat a;				/**< The a coefficient in the planar equation. */
	GLfloat b;				/**< The b coefficient in the planar equation. */
	GLfloat c;				/**< The c coefficient in the planar equation. */
	GLfloat d;				/**< The d coefficient in the planar equation. */
} HL3Plane;

/* 一个未定义的平面 */
static const HL3Plane kHL3PlaneZero = {0,0,0,0};

/* 返回一个平面的字符串的描述 **/
static inline NSString* NSStringFromHL3Plane(HL3Plane p) {
	return [NSString stringWithFormat: @"(%.3f, %.3f, %.3f, %.3f)", p.a, p.b, p.c, p.d];
}

static inline HL3PlaneMake(GLfloat a, GLfloat b, GLfloat c, GLfloat d){
    HL3Plane p;
    p.a = a;
    p.b = b;
    p.c = c;
    p.d = d;
    return p;
}

/** 返回平面的法线, which is (a, b, c) from the planar equation. */
static inline HL3Vector HL3PlaneNormal(HL3Plane p) {
	return *(HL3Vector*)&p;
}

#endif














