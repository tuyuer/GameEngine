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

#ifndef __CCSPRITE3D_H__
#define __CCSPRITE3D_H__

#include "base_nodes/CCNode.h"
#include "kazmath/vec3.h"

/**
 * @addtogroup Sprite3D
 * @{
 */

NS_CC_BEGIN

class CCModel;

class CC_DLL CCSprite3D : public CCNode
{
public:
    CCSprite3D();
    virtual ~CCSprite3D();
    
    static CCSprite3D* create(const char* fileName, const char* textureName);
    virtual bool init();

    void setModel(CCModel* pModel);
    CCModel* getModel();
    /***************************************************
     *                  Transform                      *
     ***************************************************/

    // Override CCNode functions
    virtual void setPosition(const CCPoint &position);
    virtual float getRotation();
    virtual void setRotation(float fRotation);
    //
    virtual void setPosition(float x,float y,float z);

    virtual kmVec3 getPosition() const;

    virtual void setScale(float x,float y,float z);
    virtual kmVec3 getScale() const;
    
    /***************************************************
     *              Rendering and Visiting             *
     ***************************************************/

    /**
     * visible switcher
     */
    virtual void setVisible(bool visible);
    virtual bool isVisible();
    
    /**
     * Show or hide the bounding box, useful when debugging.
     */
    void showBoundingBox(bool show);
    
    /**
     *  draw. This method is called by this->visit();
     */
    virtual void draw();
    
    virtual void transform(void);
    /***************************************************
    *                     Mesh                        *
    ***************************************************/
    
    /**
    * Load a mesh into cache.
    *
    * @param  meshName  	The name which is invovled in .ckb file, assigned by artist.
    * @return true         if loading successful
    * @return false        if the material can not be found at this path
    */
    //bool loadMesh(const char* meshName);
    
    /**
    * Load a mesh into cache.
    *
    * @param  meshName  	It should equal to the meshName param of loadMesh method
    * @return true         if loading successful
    * @return false        if the material can not be found at this path
    */
    //bool unloadMesh(const char* meshName);

    
    /***************************************************
        *                     Materials                   *
        ***************************************************/
    
    /**
    * Load a material into cache.
    *
    * @param materialPath 	Path of a material file. This string is also a key
    *                      in the subsequent process to get this material
    * @return true         if loading successful
    * @return false        if the material can not be found at this path
    */
    //bool loadMaterial(const char* materialPath);
    
    /**
    * Unload a material from cache.
    *
    * @param materialPath 	Path of a material file
    * @return 
    */
    //bool unloadMaterial(const char* materialPath);
    
    /**
    * change to the next material for the special type part of the avatar model.
    *
    * @param 	materialPath 	the materialPath param used in addMaterial
    * @param 	meshName 	the mesh name which is contained in .ckb file
    * @return 	true 		process suceessfully
    * @return 	false  	can not find materialName or partName
    */
//     bool setMaterialToMesh(const char* materialPath,
//                             const char* meshName );

    /**
    * add valid config info for the avatar model. 
    *
    * @param type part type
    * @param canNone whether the part of avata model can been 1to removed.
    * @param meshName the mesh name of the part.
    * @param matName the material name of the part.
    */	
//     void addPartConfig(std::string type,bool canNone);
// 
//     void addPart(std::string type,std::string meshName,std::string matName);
	
    /**
    * set the cur materials of the avatar model. 
    *
    * @param type The part type of the avatar model.
    * @param index The part index in the parts of special type.
    */
//     void setPart(std::string type,int index);
// 
//     void loadParts();
    
    /***************************************************
        *                     Morphs                      *
        ***************************************************/
    
    //void createMorph(const char*  meshName);

    /**
        * change to the morph for the special type part of the avatar model.
        *
        * @param	partIndex		The part type of the avatar model.
        * @param	morpthTargetIndex	The index number of morph which is assigned in
        .ckb file
        * @param	weight			Define the morph¡¯s transform ratio,
        should be 0.0f~1.0f
        */
//     void setMorphToMesh(const char*  type,
// 		                unsigned int morphTargetIndex,                        
//                         float        weight);
    
protected:
    kmVec3 m_modelPosition;
    float m_modelRotation;
    kmVec3 m_modelScale;
    CCModel* m_pModel;
    bool m_bDepthTestEnabled;
};

NS_CC_END

// end of Network group
/// @}

#endif // __CCSPRITE3D_H__