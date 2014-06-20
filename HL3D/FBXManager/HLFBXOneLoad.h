//
//  HLFBXOneLoad.h
//  GameEngine
//
//  Created by huxiaozhou on 14-4-15.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fbxsdk.h"
#import "HL3Foundation.h"
#import "HLFBXObject.h"

@interface HLFBXOneLoad : NSObject{
    FbxManager * _fbxManager;
    FbxScene * _fbxScene;
    HLFBXObject * _fbxObject;
    char * _fbxFileName;
}
+ (id)oneLoad;
- (void)Init_and_load:(const char *)fbxFileName;
- (void)initSdkObjects:(FbxManager*&)pSdkManager scene:(FbxScene*&)pScene;
- (bool)loadScene:(FbxManager*)pSdkManager document:(FbxDocument*)pScene fileName:(const char*)pFilename;
- (void)readVertex:(FbxMesh*)pMesh ctrlPointIndex:(int)ctrlPIndex vector:(HL3Vector&)pVector;
- (void)readColor:(FbxMesh*)pMesh ctrlPointIndex:(int)ctrlPIndex vertexCounter:(int)vertexCounter vector:(HL3Vector4&)pVector;
- (void)readUV:(FbxMesh*)pMesh ctrlPointIndex:(int)ctrlPIndex textureUVIndex:(int)textureUVIndex uvLayer:(int)uvLayer vector:(HL3Vector2&)pVector;


// Triangulate all NURBS, patch and mesh under this node recursively.
- (void)triangulateRecursive:(FbxNode*)pNode;
- (void)makeSubMeshSetForEachNode:(FbxNode*)pNode;
- (void)makeSubMeshSetForThisNode:(FbxNode*)pNode;

- (HLFBXObject*)getFBXObject;
@end

