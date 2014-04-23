/****************************************************************************
Copyright (c) 2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

#ifndef MD2_H
#define MD2_H

#include "model.h"

NS_CC_BEGIN

class CCTexture2D;

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
		CC_SAFE_DELETE_ARRAY(verts);
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
    CCTexture2D* m_Image;		//Image file ready for texturing
};

class CC_DLL CCModelMd2 : public CCModel
{
public:
    static CCModelMd2* create(const char* pszFilename);

	//Set skin to one of the files specified in the md2 files itself
	void setSkin(unsigned int uiSkin);
	//Set skin to a different image
	void setSkin(const char* pszFileName);

	//Load the file
	bool load(const char * szFilename);
	
    virtual void draw();
	//Render the file at a certain frame
	void draw(unsigned int uiFrame);

	//Animate the md2 model (start and end frames of 0 and 0 will loop through the WHOLE model
	void animate(float fSpeed = 30.0f, unsigned int uiStartFrame = 0, unsigned int uiEndFrame = 0, bool bLoop = true);

	//constructors/destructo
	CCModelMd2();
	CCModelMd2(const char * szFile);
	~CCModelMd2();

private:
    // TODO
    void toHostEndian() {};

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
	CCTexture2D* m_pCustSkin;
};

NS_CC_END

#endif //MD2_H