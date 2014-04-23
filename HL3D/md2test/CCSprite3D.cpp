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

#include "CCSprite3D.h"
#include "CCDirector.h"
#include "model.h"
#include "kazmath/GL/matrix.h"
#include "shaders/CCShaderCache.h"
#include "effects/CCGrid.h"
#include "md2.h"
#include "support/CCPointExtension.h"

NS_CC_BEGIN

CCSprite3D* CCSprite3D::create(const char* fileName, const char* textureName)
{
	if (!fileName || fileName[0] == 0) {
		return NULL;
	}

	std::string file = fileName;
	CCModel* pModel = NULL;
	if (file.find(".md2") != std::string::npos) {
		pModel = CCModelMd2::create(fileName);

		if (pModel && textureName && textureName[0] != 0) {
			pModel->setSkin(textureName);
		}
	}

	if (pModel == NULL) {
		return NULL;
	}

    CCSprite3D* pRet = new CCSprite3D();
    if (pRet && pRet->init()) {
        pRet->setModel(pModel);
        pRet->autorelease();
    }
    else {
        CC_SAFE_DELETE(pRet);
    }
    return pRet;
}

CCSprite3D::CCSprite3D()
: m_pModel(NULL)
, m_modelRotation(0.0f)
{
    kmVec3Fill(&m_modelPosition, 0, 0, 0);
    kmVec3Fill(&m_modelScale, 1.0f, 1.0f, 1.0f);
}

CCSprite3D::~CCSprite3D()
{
    CC_SAFE_RELEASE(m_pModel);
}

void CCSprite3D::setModel(CCModel* pModel)
{
    CC_SAFE_RETAIN(pModel);
    CC_SAFE_RELEASE(m_pModel);
    m_pModel = pModel;
}

CCModel* CCSprite3D::getModel()
{
    return m_pModel;
}

bool CCSprite3D::init()
{
    CCGLProgram* program = CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTexture);
    setShaderProgram(program);

    return true;
}

void CCSprite3D::setPosition(float x,float y,float z)
{
    kmVec3Fill(&m_modelPosition, x, y, z);
}

void CCSprite3D::setPosition(const CCPoint &position)
{
    m_modelPosition.x = position.x;
    m_modelPosition.y = position.y;
	m_obPosition = position;
	m_bTransformDirty = m_bInverseDirty = true;
}

kmVec3 CCSprite3D::getPosition() const
{
    return m_modelPosition;
}

float CCSprite3D::getRotation()
{
    return CCNode::getRotation();
}

void CCSprite3D::setRotation(float fRotation)
{
    CCNode::setRotation(fRotation);
}

void CCSprite3D::setScale(float x,float y,float z)
{
    kmVec3Fill(&m_modelScale, x, y, z);
}

kmVec3 CCSprite3D::getScale() const
{
    return m_modelScale;
}

void CCSprite3D::setVisible(bool visible)
{
    CCNode::setVisible(visible);
}

bool CCSprite3D::isVisible()
{
    return CCNode::isVisible();
}

void CCSprite3D::showBoundingBox(bool show)
{
    // TODO
}

void CCSprite3D::draw()
{
    m_bDepthTestEnabled = 0 == glIsEnabled(GL_DEPTH_TEST) ? false : true;

    CCDirector::sharedDirector()->setDepthTest(true);
    
    CC_NODE_DRAW_SETUP();

    m_pModel->draw();
    static unsigned int uiStartFrame = 0, uiEndFrame = 182;
    static float fAnimSpeed = 16.5f;
   // ((CCModelMd2*)m_pModel)->animate(fAnimSpeed, uiStartFrame, uiEndFrame, true);
   CCDirector::sharedDirector()->setDepthTest(m_bDepthTestEnabled);
}

void CCSprite3D::transform(void)
{
    kmGLTranslatef(m_modelPosition.x, m_modelPosition.y, m_modelPosition.z);
    kmGLScalef(m_modelScale.x, m_modelScale.y, m_modelScale.z);
    kmGLRotatef(getRotation(), 0, 0, 1.0f);
}

NS_CC_END
