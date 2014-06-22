//
//  HL3GLMatrix.h
//  GameEngine
//
//  Created by Tuyuer on 14-6-22.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 一个4x4矩阵的的数据封装
 */

@interface HL3GLMatrix : NSObject{
    BOOL isIdentity;
}

/*代表此矩阵是否是单位矩阵
 **/
@property (nonatomic,readonly) BOOL isIdentity;

/*Returns a pointer to the underlying array of 16 GLfloats stored in column-major order.
 */
@property (nonatomic,assign) GLfloat *glMatrix;



@end




