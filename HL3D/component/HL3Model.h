//
//  HL3Model.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-16.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#ifndef __GameEngine__HL3Model__
#define __GameEngine__HL3Model__

#include <iostream>


class HL3Model 
{
protected:
    HL3Model() {};
public:
    virtual ~HL3Model() {};
	//Load the model from file
	virtual bool load(const char * szFile) = 0;
	virtual void setSkin(const char* textureName) = 0;
    virtual void draw(const int frame = 0) = 0;
};

#endif /* defined(__GameEngine__HL3Model__) */
