//
//  HL3Matrix4x4.cpp
//  GameEngine
//
//  Created by tuyuer on 14-4-12.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#include "HL3Matrix4x4.h"


HL3Matrix4x4::HL3Matrix4x4(){
    initMembers();
}

HL3Matrix4x4::HL3Matrix4x4(const float array[16]){
    init(array);
}

HL3Matrix4x4::HL3Matrix4x4(float a0,float a1,float a2,float a3,//col 1
             float a4,float a5,float a6,float a7,//col2
             float a8,float a9,float a10,float a11,//col3
             float a12,float a13,float a14,float a15//col4
            )
{
    init(a0, a1 , a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15);
}

void HL3Matrix4x4::initMembers(){
    memset(_array, 0, sizeof(_array));
}

void HL3Matrix4x4::init(const float array[16]){
    for(int i=0;i<16;i++){
        _array[i]=array[i];
    }
}

void HL3Matrix4x4::init(float a0,float a1,float a2,float a3,//col 1
          float a4,float a5,float a6,float a7,//col2
          float a8,float a9,float a10,float a11,//col3
          float a12,float a13,float a14,float a15//col4
          ){
    _array[0]=a0;
    _array[1]=a1;
    _array[2]=a2;
    _array[3]=a3;
    _array[4]=a4;
    _array[5]=a5;
    _array[6]=a6;
    _array[7]=a7;
    _array[8]=a8;
    _array[9]=a9;
    _array[10]=a10;
    _array[11]=a11;
    _array[12]=a12;
    _array[13]=a13;
    _array[14]=a14;
    _array[15]=a15;
}

HL3Matrix4x4 HL3Matrix4x4::operator*(const HL3Matrix4x4 &mat)const{
    const float *a=this->getArray();
    const float *b=mat.getArray();
    float r[16];//result
    r[0]=b[0]*a[0]+b[1]*a[4]+b[2]*a[8]+b[3]*a[12];
    r[1]=b[0]*a[1]+b[1]*a[5]+b[2]*a[9]+b[3]*a[13];
    r[2]=b[0]*a[2]+b[1]*a[6]+b[2]*a[10]+b[3]*a[14];
    r[3]=b[0]*a[3]+b[1]*a[7]+b[2]*a[11]+b[3]*a[15];
    
    r[4]=b[4]*a[0]+b[5]*a[4]+b[6]*a[8]+b[7]*a[12];
    r[5]=b[4]*a[1]+b[5]*a[5]+b[6]*a[9]+b[7]*a[13];
    r[6]=b[4]*a[2]+b[5]*a[6]+b[6]*a[10]+b[7]*a[14];
    r[7]=b[4]*a[3]+b[5]*a[7]+b[6]*a[11]+b[7]*a[15];
    
    r[8]=b[8]*a[0]+b[9]*a[4]+b[10]*a[8]+b[11]*a[12];
    r[9]=b[8]*a[1]+b[9]*a[5]+b[10]*a[9]+b[11]*a[13];
    r[10]=b[8]*a[2]+b[9]*a[6]+b[10]*a[10]+b[11]*a[14];
    r[11]=b[8]*a[3]+b[9]*a[7]+b[10]*a[11]+b[11]*a[15];
    
    r[12]=b[12]*a[0]+b[13]*a[4]+b[14]*a[8]+b[15]*a[12];
    r[13]=b[12]*a[1]+b[13]*a[5]+b[14]*a[9]+b[15]*a[13];
    r[14]=b[12]*a[2]+b[13]*a[6]+b[14]*a[10]+b[15]*a[14];
    r[15]=b[12]*a[3]+b[13]*a[7]+b[14]*a[11]+b[15]*a[15];
    return HL3Matrix4x4(r);
}














