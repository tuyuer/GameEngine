//
//  HL3Matrix4x4.h
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#ifndef __GameEngine__HL3Matrix4x4__
#define __GameEngine__HL3Matrix4x4__

#include <iostream>

class HL3Matrix4x4 {
private:
    float _array[16];
private:
    void initMembers();
public:
    HL3Matrix4x4();
    HL3Matrix4x4(const float array[16]);
    HL3Matrix4x4(float a0,float a1,float a2,float a3,//col 1
                 float a4,float a5,float a6,float a7,//col2
                 float a8,float a9,float a10,float a11,//col3
                 float a12,float a13,float a14,float a15//col4
                 );
    void init(const float array[16]);
    void init(float a0,float a1,float a2,float a3,//col 1
              float a4,float a5,float a6,float a7,//col2
              float a8,float a9,float a10,float a11,//col3
              float a12,float a13,float a14,float a15//col4
              );
    HL3Matrix4x4 operator*(const HL3Matrix4x4 &mat)const;
    const float* getArray()const{return  _array;}
    const float getAt(int index){ return _array[index];};
    

};

#define kHL3Matrix4x4Identity HL3Matrix4x4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)

#endif /* defined(__GameEngine__HL3Matrix4x4__) */





