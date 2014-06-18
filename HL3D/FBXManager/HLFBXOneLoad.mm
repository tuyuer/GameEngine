//
//  HLFBXOneLoad.m
//  GameEngine
//
//  Created by huxiaozhou on 14-4-15.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HLFBXOneLoad.h"
#include <iostream>
#include "HLFBXStream.h"
using namespace std;
@implementation HLFBXOneLoad

+ (id)oneLoad{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        _fbxManager = nil;
        _fbxScene = nil;
        _fbxFileName = nil;
    }
    return self;
}


- (void)Init_and_load:(const char *)fbxFileName{
    _fbxFileName = (char *)fbxFileName;
    [self initSdkObjects:_fbxManager scene:_fbxScene];
    [self loadScene:_fbxManager document:_fbxScene fileName:fbxFileName];
}

- (void)initSdkObjects:(FbxManager*&)pSdkManager scene:(FbxScene*&)pScene{
    pSdkManager = FbxManager::Create();
    if (!pSdkManager) {
        FBXSDK_printf("nable to create the FBX SDK manager\n");
        system("pause");
        exit(0);
    }else{
        FBXSDK_printf("FBX SDK version %s\n\n", pSdkManager->GetVersion());
    }
    
    // create an IOSettings object
    FbxIOSettings * ios = FbxIOSettings::Create(pSdkManager, IOSROOT);
    pSdkManager->SetIOSettings(ios);
    
//    // Load plugins from the executable directory
//    FbxString lPath = FbxGetApplicationDirectory();
//    pSdkManager->LoadPluginsDirectory(lPath.Buffer());
    
    // Create the entity that will hold the scene.
    pScene = FbxScene::Create(pSdkManager, "");
}

- (bool)loadScene:(FbxManager*)pSdkManager document:(FbxDocument*)pScene fileName:(const char*)pFilename{

#ifdef IOS_REF
#undef  IOS_REF
#define IOS_REF (*(pSdkManager->GetIOSettings()))
#endif
    
    int lFileMajor, lFileMinor, lFileRevision;
    int lSDKMajor,  lSDKMinor,  lSDKRevision;
    //int lFileFormat = -1;
    int i, lAnimStackCount;
    bool lStatus;
    
    // Get the file version number generate by the FBX SDK.
    FbxManager::GetFileFormatVersion(lSDKMajor, lSDKMinor, lSDKRevision);
    
    // Create an importer.
    FbxImporter* lImporter = FbxImporter::Create(pSdkManager,"");

    NSString * filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"girl.fbx"] ofType:nil];
    HLFBXStream * fbxStream = new HLFBXStream( pSdkManager, "rb",[filePath UTF8String]);
    fbxStream->Open(NULL);
    // initialize the importer with a stream
    const bool lImportStatus = lImporter->Initialize( fbxStream, NULL, -1,pSdkManager->GetIOSettings());
    lImporter->GetFileVersion(lFileMajor, lFileMinor, lFileRevision);
    
    
    if( !lImportStatus )
    {
        FBXSDK_printf("Call to FbxImporter::Initialize() failed.\n");
        FbxStatus status =  lImporter->GetStatus();

        FBXSDK_printf("Error returned: %s\n\n", status.GetErrorString());
    
        
        return false;
    }
    
    FBXSDK_printf("FBX version number for this FBX SDK is %d.%d.%d\n", lSDKMajor, lSDKMinor, lSDKRevision);
    
    if (lImporter->IsFBX())
    {
        FBXSDK_printf("FBX version number for file %s is %d.%d.%d\n\n", pFilename, lFileMajor, lFileMinor, lFileRevision);
        
        // From this point, it is possible to access animation stack information without
        // the expense of loading the entire file.
        
        FBXSDK_printf("Animation Stack Information\n");
        lAnimStackCount = lImporter->GetDstObjectCount(FbxCriteria::ObjectType(FbxObject::ClassId));
//        lImporter->GetDstObjectCount(<#const fbxsdk_2014_2_1::FbxCriteria &pCriteria#>)
//        FbxTypeComponentCount(<#const fbxsdk_2014_2_1::EFbxType pType#>)
        FBXSDK_printf("    Number of Animation Stacks: %d\n", lAnimStackCount);
        FBXSDK_printf("    Current Animation Stack: \"%s\"\n", lImporter->GetActiveAnimStackName().Buffer());
        FBXSDK_printf("\n");
        
        for(i = 0; i < lAnimStackCount; i++)
        {
            FbxTakeInfo* lTakeInfo = lImporter->GetTakeInfo(i);
            
            FBXSDK_printf("    Animation Stack %d\n", i);
            FBXSDK_printf("         Name: \"%s\"\n", lTakeInfo->mName.Buffer());
            FBXSDK_printf("         Description: \"%s\"\n", lTakeInfo->mDescription.Buffer());
            
            // Change the value of the import name if the animation stack should be imported
            // under a different name.
            FBXSDK_printf("         Import Name: \"%s\"\n", lTakeInfo->mImportName.Buffer());
            
            // Set the value of the import state to false if the animation stack should be not
            // be imported.
            FBXSDK_printf("         Import State: %s\n", lTakeInfo->mSelect ? "true" : "false");
            FBXSDK_printf("\n");
        }
        
        // Set the import states. By default, the import states are always set to
        // true. The code below shows how to change these states.
        IOS_REF.SetBoolProp(IMP_FBX_MATERIAL,        true);
        IOS_REF.SetBoolProp(IMP_FBX_TEXTURE,         true);
        IOS_REF.SetBoolProp(IMP_FBX_LINK,            true);
        IOS_REF.SetBoolProp(IMP_FBX_SHAPE,           true);
        IOS_REF.SetBoolProp(IMP_FBX_GOBO,            true);
        IOS_REF.SetBoolProp(IMP_FBX_ANIMATION,       true);
        IOS_REF.SetBoolProp(IMP_FBX_GLOBAL_SETTINGS, true);
    }
    
    // Import the scene.
    lStatus = lImporter->Import(pScene);
    
    // Destroy the importer.
    lImporter->Destroy();
    delete fbxStream;
    return true;
}

//读取节点
- (void)readVertex:(FbxMesh*)pMesh ctrlPointIndex:(int)ctrlPIndex vector:(HL3Vector&)pVector{
  
}

//处理mesh
- (void)processMesh:(FbxNode*)pNode{
    
}

// Triangulate all NURBS, patch and mesh under this node recursively.
- (void)triangulateRecursive:(FbxNode*)pNode{
    FbxNodeAttribute* lNodeAttribute = pNode->GetNodeAttribute();
    
    if (lNodeAttribute)
    {
        if (lNodeAttribute->GetAttributeType() == FbxNodeAttribute::eMesh ||
            lNodeAttribute->GetAttributeType() == FbxNodeAttribute::eNurbs ||
            lNodeAttribute->GetAttributeType() == FbxNodeAttribute::eNurbsSurface ||
            lNodeAttribute->GetAttributeType() == FbxNodeAttribute::ePatch)
        {
            FbxGeometryConverter lConverter(pNode->GetFbxManager());
            lConverter.Triangulate(lNodeAttribute, true);
        }
    }
    
    const int lChildCount = pNode->GetChildCount();
    for (int lChildIndex = 0; lChildIndex < lChildCount; ++lChildIndex)
    {
        [self triangulateRecursive:pNode->GetChild(lChildIndex)];
    }
}

//
- (void)makeSubMeshSetForEachNode:(FbxNode*)pNode{
    FbxNodeAttribute* lNodeAttribute = pNode->GetNodeAttribute();
    if (lNodeAttribute
        &&lNodeAttribute->GetAttributeType() == FbxNodeAttribute::eMesh//ÇÒÊôÐÔ½ÚµãÎªµÄÀàÐÍÎªeMesh
        )
    {
        [self makeSubMeshSetForThisNode:pNode];
    }
    const int lChildCount = pNode->GetChildCount();
    for (int lChildIndex = 0; lChildIndex < lChildCount; ++lChildIndex)
    {
        [self makeSubMeshSetForEachNode:pNode->GetChild(lChildIndex)];
    }
}

- (void)makeSubMeshSetForThisNode:(FbxNode*)pNode{
    FbxMesh * lMesh=pNode->GetMesh();
    const int lVertexCount = lMesh->GetControlPointsCount();
    if(!lMesh){
        cout<<"error: lMesh==NULL!"<<endl;
        return;
    }

    const int triangleCount = lMesh->GetPolygonCount();
    for (int i = 0; i < triangleCount; i++)
    {
        
    }
}

//读取fbx object
- (HLFBXObject*)getFBXObject{
    
    //trianglulate
    [self triangulateRecursive:_fbxScene->GetRootNode()];

    //makeSubMeshes
    [self makeSubMeshSetForEachNode:_fbxScene->GetRootNode()];
    
    return nil;
}


@end
