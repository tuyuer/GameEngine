//
//  HLMD2.h
//  GameEngine
//
//  Created by tuyuer on 14-4-16.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#ifndef __GameEngine__HLMD2__
#define __GameEngine__HLMD2__

#include <iostream>
#import "HLTexture.h"
#include "HL3Model.h"

//-------------------------------------------------------------
//- SMD2Header
//- Header for all Md2 files,
struct SMD2Header
{
    int magicNum; //Always IDP2 (844121161)
    int version;  //8
    int skinWidthPx;
    int skinHeightPx;
    int frameSize;
    int numSkins;
    int numVertices;
    int numTexCoords;
    int numTriangles;
    int numGLCommands;
    int numFrames;
    int offsetSkins;
    int offsetTexCoords;
    int offsetTriangles;
    int offsetFrames;
    int offsetGlCommands;
    int fileSize;
};

//-------------------------------------------------------------
//- SMD2Vert
//- Vertex structure for MD2
struct SMD2Vert
{
	float x, y, z;
	unsigned char reserved;
};

//-------------------------------------------------------------
//- SMD2Frame
//- Frame information for the model file
struct SMD2Frame
{
	float scale[3];
	float trans[3];
	char name[16];
	SMD2Vert* verts;
    
	//Cleans up after itself
	SMD2Frame()
	{
		verts = 0;
	}
    
	~SMD2Frame()
	{
        if (verts) {
            free(verts);
        }
	}
};

//-------------------------------------------------------------
//- SMD2Tri
//- Triangle information for the MD2
struct SMD2Tri
{
	unsigned short vertIndices[3];
	unsigned short texIndices[3];
};

//-------------------------------------------------------------
//- SMD2TexCoord
//- Texture coord information for the MD2
struct SMD2TexCoord
{
	float s;
    float t;
};

//-------------------------------------------------------------
//- SMD2Skin
//- Name of a single skin in the md2 file
struct SMD2Skin
{
    char skinFileName[64];	//filename
    HLTexture * m_Image;		//Image file ready for texturing
};

class HL3ModelMd2 : public HL3Model
{
public:
    static HL3ModelMd2* create(const char* pszFilename);
    
	//Set skin to one of the files specified in the md2 files itself
	void setSkin(unsigned int uiSkin);
	//Set skin to a different image
	void setSkin(const char* pszFileName);
    
	//Load the file
	bool load(const char * szFilename);
	
    //绘制
    virtual void draw(const int frame = 0);
    
	//Animate the md2 model (start and end frames of 0 and 0 will loop through the WHOLE model
	void animate(float fSpeed = 30.0f, unsigned int uiStartFrame = 0, unsigned int uiEndFrame = 0, bool bLoop = true);
    
	//constructors/destructor
	HL3ModelMd2();
	HL3ModelMd2(const char * szFile);
	~HL3ModelMd2();
    
public:
    
    //file header information
	SMD2Header m_Head;
	//Frame information
	SMD2Frame * m_pFrames;
	//Triangles
	SMD2Tri * m_pTriangles;
	//Texure coords
	SMD2TexCoord * m_pTexCoords;
	//Skin files
	SMD2Skin * m_pSkins;
	//Interpolated vertices
	SMD2Vert * m_pVerts;
	//Current skin
	unsigned int m_uiSkin;
	//Using a custom skin?
	bool m_bIsCustomSkin;
	//The custom skin
	HLTexture * m_pCustSkin;
};

#endif /* defined(__GameEngine__HLMD2__) */
