//
//  HLMD2.cpp
//  GameEngine
//
//  Created by tuyuer on 14-4-16.
//  Copyright (c) 2014年 hitjoy. All rights reserved.
//

#include "HLMD2.h"
#import "HLTextureCache.h"
#import "TransformUtils.h"
#import "HLShaderCache.h"
#import "HLGLStateCache.h"
#import "HLGLProgram.h"
#import "kazmath/GL/matrix.h"
#import "HLTypes.h"
#import "ccMacros.h"


//-------------------------------------------------------------
//- Load
//- Loads an MD2 model from file
//-------------------------------------------------------------
bool HL3ModelMd2::load(const char * szFilename)
{
    if (szFilename == NULL || strlen(szFilename) == 0) return false;
    
	unsigned char * ucpBuffer = 0;
	unsigned char * ucpPtr = 0;
	unsigned char * ucpTmpPtr = 0;
    
    NSString * fullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:szFilename] ofType:nil];
    
    ucpBuffer = (unsigned char *)[[NSData dataWithContentsOfFile:fullPath] bytes];
    
	ucpPtr = ucpBuffer;
    
	if(!ucpBuffer)
	{
		NSLog( @"Could not allocate memory for %s", szFilename);
		return false;
	}
    
	//get the header
	memcpy(&m_Head, ucpPtr, sizeof(SMD2Header));
    
	//make sure it is a valid MD2 file before we get going
	if(m_Head.magicNum != 844121161 || m_Head.version != 8)
	{
		NSLog( @"%s is not a valid MD2 file", szFilename);
		return false;
	}
	
	ucpTmpPtr = ucpPtr;
	ucpTmpPtr += m_Head.offsetFrames;
    
	//read the frames
	m_pFrames = new SMD2Frame[m_Head.numFrames];
	
	for(int i = 0; i < m_Head.numFrames; i++)
	{
		float fScale[3];
		float fTrans[3];
		m_pFrames[i].verts = new SMD2Vert[m_Head.numVertices];
		//expand the verices
		memcpy(fScale, ucpTmpPtr, 12);
		memcpy(fTrans, ucpTmpPtr + 12, 12);
		memcpy(m_pFrames[i].name, ucpTmpPtr + 24, 16);
		ucpTmpPtr += 40;
		for(int j = 0; j < m_Head.numVertices; j++)
		{
			//swap y and z coords to convert to the proper orientation on screen
			m_pFrames[i].verts[j].x = ucpTmpPtr[0] * fScale[0] + fTrans[0];
			m_pFrames[i].verts[j].y = ucpTmpPtr[2] * fScale[2] + fTrans[2];
			m_pFrames[i].verts[j].z = ucpTmpPtr[1] * fScale[1] + fTrans[1];
			m_pFrames[i].verts[j].reserved = ucpTmpPtr[3];
			ucpTmpPtr += 4;
		}
	}
    
	//Read in the triangles
	ucpTmpPtr = ucpPtr;
	ucpTmpPtr += m_Head.offsetTriangles;
	m_pTriangles = new SMD2Tri[m_Head.numTriangles];
	memcpy(m_pTriangles, ucpTmpPtr, 12 * m_Head.numTriangles);
    
	//Read the U/V texture coords
	ucpTmpPtr = ucpPtr;
	ucpTmpPtr += m_Head.offsetTexCoords;
	m_pTexCoords = new SMD2TexCoord[m_Head.numTexCoords];
	
	short * sTexCoords = new short[m_Head.numTexCoords * 2];
	memcpy(sTexCoords, ucpTmpPtr, 4 * m_Head.numTexCoords);
    
    NSString * strFileName = [[[NSString stringWithUTF8String:szFilename] componentsSeparatedByString:@"."] objectAtIndex:0];
    strFileName = [NSString stringWithFormat:@"%@.png",strFileName];
    m_pCustSkin = [[HLTextureCache sharedTextureCache] addImage:strFileName];
	for(int i = 0; i < m_Head.numTexCoords; i++)
	{
		m_pTexCoords[i].s = (float)sTexCoords[2*i] / m_pCustSkin.contentSize.width;
		m_pTexCoords[i].t = (float)sTexCoords[2*i+1] / m_pCustSkin.contentSize.height;
	}
	
    delete [] sTexCoords;
    
	//Read the skin filenames
	ucpTmpPtr = ucpPtr;
	ucpTmpPtr += m_Head.offsetSkins;
    
	if (m_Head.numSkins > 0) {
		m_pSkins = new SMD2Skin[m_Head.numSkins];
        
		//Load textures
		for(int i = 0; i < m_Head.numSkins; i++)
		{
			memcpy(m_pSkins[i].skinFileName, ucpTmpPtr, 64);
			//hack off the leading parts and just get the filename
			char * szEnd = strrchr(m_pSkins[i].skinFileName, '/');
            
			if(szEnd)
			{
				szEnd++;
				strcpy(m_pSkins[i].skinFileName, szEnd);
			}
            
			m_pSkins[i].m_Image = [[HLTextureCache sharedTextureCache] addImage:[NSString stringWithUTF8String:m_pSkins[i].skinFileName]];
            
			ucpTmpPtr += 64;
		}
	}
    
	return true;
}

//绘制
void HL3ModelMd2::draw(const int frame){
    
    int uiFrame = frame;
    int vertexNum = m_Head.numTriangles * 9;
    
    float m_pVertices[vertexNum];
    memset(m_pVertices, 0, m_Head.numTriangles * 9);
    
    int uvNum = m_Head.numTriangles * 6;
    float m_pUV[uvNum];
    memset(m_pUV, 0, uvNum);
    
    int colorNum = m_Head.numTriangles * 12;
    float m_pColors[colorNum];
    memset(m_pColors, 0, colorNum);
    
    int vertexIdx = 0;
    int uvIdx = 0;
    int colorIdx = 0;
    
    for (int i =0; i < m_Head.numTriangles; i++)
    {
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[0]].x;
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[0]].y;
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[0]].z;
        
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[1]].x;
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[1]].y;
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[1]].z;
        
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[2]].x;
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[2]].y;
        m_pVertices[vertexIdx++] = m_pFrames[uiFrame].verts[m_pTriangles[i].vertIndices[2]].z;
   
    
        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[0]].s;
        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[0]].t;
        
        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[1]].s;
        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[1]].t;
        
        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[2]].s;
        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[2]].t;
        
        m_pColors[colorIdx++] = 1;
        m_pColors[colorIdx++] = 1;
        m_pColors[colorIdx++] = 1;
        m_pColors[colorIdx++] = 1;
    
    }
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttribFlag_TexCoords);
    glBindTexture(GL_TEXTURE_2D, [m_pCustSkin Name]);
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, m_pVertices);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, m_pUV);
    
    glDrawArrays(GL_TRIANGLES, 0, m_Head.numTriangles*3);
    
    CHECK_GL_ERROR_DEBUG();
}

//-------------------------------------------------------------
//- Animate
//- Animates the MD2 file  fspeed is frames per second
//-------------------------------------------------------------
void HL3ModelMd2::animate(float fSpeed, unsigned int uiStartFrame, unsigned int uiEndFrame, bool bLoop)
{
//	static unsigned int uiTotalFrames = 0;			//total number of frames
//	static unsigned int uiLastStart = 0, uiLastEnd = 0;	//last start/end parems passed to the function
//	static unsigned int uiLastFrame = 0;			//lastframe rendered
//	static unsigned int uiMSPerFrame = 0;			//number of milliseconds per frame
//	static float fLastInterp = 0;					//Last interpolation value
//    static struct cc_timeval oldTime;
//    static bool isFirst = true;
//    int i = 0;
//    if (isFirst) {
//        CCTime::gettimeofdayCocos2d(&oldTime, NULL);
//        isFirst = false;
//    }
//	//alloc a place to put the interpolated vertices
//	if(!m_pVerts)
//		m_pVerts = new SMD2Vert[m_Head.numVertices];
//    
//	//Prevent invalid frame counts
//	if(uiEndFrame >= (unsigned)m_Head.numFrames)
//		uiEndFrame = m_Head.numFrames - 1;
//	if(uiStartFrame > (unsigned)m_Head.numFrames)
//		uiStartFrame = 0;
//    
//	//avoid calculating everything every frame
//	if(uiLastStart != uiStartFrame || uiLastEnd != uiEndFrame)
//	{
//		uiLastStart = uiStartFrame;
//		uiLastEnd = uiEndFrame;
//		if(uiStartFrame > uiEndFrame)
//		{
//			uiTotalFrames = m_Head.numFrames - uiStartFrame + uiEndFrame + 1;
//		}
//		else
//		{
//			uiTotalFrames = uiEndFrame - uiStartFrame;
//		}
//	}
//	uiMSPerFrame = (unsigned int)(1000 / fSpeed);
//	
//	//Calculate the next frame and the interpolation value
//	unsigned int uiTime = 0;//GetMS();
//    struct cc_timeval tp;
//    CCTime::gettimeofdayCocos2d(&tp, NULL);
//    uiTime = CCTime::timersubCocos2d(&oldTime, &tp);
//	float fInterpValue = ((float) uiTime / uiMSPerFrame) + fLastInterp;
//	fLastInterp = fInterpValue;
//    
//	//If the interpolation value is greater than 1, we must increment the frame counter
//	while(fInterpValue > 1.0f)
//	{
//		uiLastFrame ++;
//		if(uiLastFrame >= uiEndFrame)
//		{
//			uiLastFrame = uiStartFrame;
//		}
//		fInterpValue -= 1.0f;
//		fLastInterp = 0.0f;
//	}
//    
//	SMD2Frame* pCurFrame = &m_pFrames[uiLastFrame];
//	SMD2Frame* pNextFrame = &m_pFrames[uiLastFrame+1];
//    
//	if(uiLastFrame == uiEndFrame-1)
//		pNextFrame = &m_pFrames[uiStartFrame];
//	
//    //
//	//interpolate the vertices
//	for(i = 0; i < m_Head.numVertices; i++)
//	{
//		m_pVerts[i].x = pCurFrame->verts[i].x + (pNextFrame->verts[i].x - pCurFrame->verts[i].x) * fInterpValue;
//		m_pVerts[i].y = pCurFrame->verts[i].y + (pNextFrame->verts[i].y - pCurFrame->verts[i].y) * fInterpValue;
//		m_pVerts[i].z = pCurFrame->verts[i].z + (pNextFrame->verts[i].z - pCurFrame->verts[i].z) * fInterpValue;
//	}
//    
//    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position | kCCVertexAttribFlag_TexCoords);
//    float* m_pUV = new float[m_Head.numTriangles * 6];
//    memset(m_pUV, 0, m_Head.numTriangles * 6);
//    
//    float* m_pVertices = new float[m_Head.numTriangles * 9];
//    memset(m_pVertices, 0, m_Head.numTriangles * 9);
//    int uvIdx = 0;
//    int vertexIdx = 0;
//    for (int i =0; i < m_Head.numTriangles; i++)
//    {
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[0]].x;
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[0]].y;
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[0]].z;
//        
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[1]].x;
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[1]].y;
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[1]].z;
//        
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[2]].x;
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[2]].y;
//        m_pVertices[vertexIdx++] = m_pVerts[m_pTriangles[i].vertIndices[2]].z;
//        
//        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[0]].s;
//        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[0]].t;
//        
//        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[1]].s;
//        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[1]].t;
//        
//        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[2]].s;
//        m_pUV[uvIdx++] = m_pTexCoords[m_pTriangles[i].texIndices[2]].t;
//    }
//    
//    if(!m_bIsCustomSkin) {
//		if (m_pSkins) {
//			ccGLBindTexture2D(m_pSkins[m_uiSkin].m_Image->getName());
//		}
//	} else {
//        ccGLBindTexture2D(m_pCustSkin->getName());
//	}
//    
//    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, 0, m_pVertices);
//    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, m_pUV);
//    
//    glDrawArrays(GL_TRIANGLES, 0, m_Head.numTriangles * 3);
//    
//    CC_INCREMENT_GL_DRAWS(1);
//    CHECK_GL_ERROR_DEBUG();
//    CC_SAFE_DELETE_ARRAY(m_pUV);
//    CC_SAFE_DELETE_ARRAY(m_pVertices);
//    
//    CCTime::gettimeofdayCocos2d(&oldTime, NULL);
//	//Print debug info
//	CCLOG("Frame: %i : %s", uiLastFrame, m_pFrames[uiLastFrame].name);
}



//-------------------------------------------------------------
//- SetSkin
//- Sets the current skin to one of the skins predefined by the md2 itself
//-------------------------------------------------------------
void HL3ModelMd2::setSkin(unsigned int uiSkin)
{
	m_uiSkin = uiSkin;
	m_bIsCustomSkin = false;
}

//-------------------------------------------------------------
//- SetSkin
//- Sets the skin to an image loaded elsewhere using a CIMAGE object
//-------------------------------------------------------------
void HL3ModelMd2::setSkin(const char* pszFileName)
{
	m_pCustSkin = [[HLTextureCache sharedTextureCache] addImage:[NSString stringWithUTF8String:pszFileName]];
	m_bIsCustomSkin = true;
}


//-------------------------------------------------------------
//- Constructors
//- 1. Default Constructor
//- 2. takes filename, calls load
//-------------------------------------------------------------
HL3ModelMd2::HL3ModelMd2()
{
	m_pFrames = 0;
	m_pTriangles = 0;
	m_pTexCoords = 0;
	m_pSkins = 0;
	m_pVerts = 0;
	m_uiSkin = 0;
	m_bIsCustomSkin = false;
	m_pCustSkin = 0;
}

HL3ModelMd2::HL3ModelMd2(const char * szFile)
{
	m_pFrames = 0;
	m_pTriangles = 0;
	m_pTexCoords = 0;
	m_pSkins = 0;
	m_bIsCustomSkin = false;
	m_pCustSkin = 0;
	m_pVerts = 0;
	m_uiSkin = 0;
	load(szFile);
}

HL3ModelMd2::~HL3ModelMd2()
{
//    CC_SAFE_DELETE_ARRAY(m_pFrames);
//    CC_SAFE_DELETE_ARRAY(m_pTexCoords);
//    CC_SAFE_DELETE_ARRAY(m_pTriangles);
//    CC_SAFE_DELETE_ARRAY(m_pSkins);
//    CC_SAFE_DELETE_ARRAY(m_pVerts);
}

