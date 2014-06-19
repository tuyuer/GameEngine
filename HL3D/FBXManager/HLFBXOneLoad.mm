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
#import "HL3Foundation.h"
using namespace std;
@implementation HLFBXOneLoad

- (void)dealloc{
    [_fbxObject release];
    [super dealloc];
}

+ (id)oneLoad{
    return [[[self alloc] init] autorelease];
}

- (id)init{
    if (self = [super init]) {
        _fbxManager = nil;
        _fbxScene = nil;
        _fbxObject = [[HLFBXObject alloc] init];
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
    
    // Load plugins from the executable directory
    FbxString lPath = FbxGetApplicationDirectory();
    pSdkManager->LoadPluginsDirectory(lPath.Buffer());
    
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
    char lPassword[1024];
    
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

//    const bool lImportStatus = lImporter->Initialize(pFilename, -1, pSdkManager->GetIOSettings());
//    lImporter->GetFileVersion(lFileMajor, lFileMinor, lFileRevision);
    
    if( !lImportStatus )
    {
        FbxString error = lImporter->GetStatus().GetErrorString();
        FBXSDK_printf("Call to FbxImporter::Initialize() failed.\n");
        FBXSDK_printf("Error returned: %s\n\n", error.Buffer());
        FbxStatus status =  lImporter->GetStatus();

        FBXSDK_printf("Error returned: %s\n\n", status.GetErrorString());
        if (lImporter->GetStatus().GetCode() == FbxStatus::eInvalidFileVersion)
        {
            FBXSDK_printf("FBX file format version for this FBX SDK is %d.%d.%d\n", lSDKMajor, lSDKMinor, lSDKRevision);
            FBXSDK_printf("FBX file format version for file '%s' is %d.%d.%d\n\n", pFilename, lFileMajor, lFileMinor, lFileRevision);
        }
        
        return false;
    }
    
    FBXSDK_printf("FBX version number for this FBX SDK is %d.%d.%d\n", lSDKMajor, lSDKMinor, lSDKRevision);
    
    if (lImporter->IsFBX())
    {
        FBXSDK_printf("FBX version number for file %s is %d.%d.%d\n\n", pFilename, lFileMajor, lFileMinor, lFileRevision);
        
        // From this point, it is possible to access animation stack information without
        // the expense of loading the entire file.
        
        FBXSDK_printf("Animation Stack Information\n");
        
        lAnimStackCount = lImporter->GetAnimStackCount();
        
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
    
    if(lStatus == false && lImporter->GetStatus().GetCode() == FbxStatus::ePasswordError)
    {
        FBXSDK_printf("Please enter password: ");
        
        lPassword[0] = '\0';
        
        FBXSDK_CRT_SECURE_NO_WARNING_BEGIN
        scanf("%s", lPassword);
        FBXSDK_CRT_SECURE_NO_WARNING_END
        
        FbxString lString(lPassword);
        
        IOS_REF.SetStringProp(IMP_FBX_PASSWORD,      lString);
        IOS_REF.SetBoolProp(IMP_FBX_PASSWORD_ENABLE, true);
        
        lStatus = lImporter->Import(pScene);
        
        if(lStatus == false && lImporter->GetStatus().GetCode() == FbxStatus::ePasswordError)
        {
            FBXSDK_printf("\nPassword is wrong, import aborted.\n");
        }
    }
    
    // Destroy the importer.
    lImporter->Destroy();
    delete fbxStream;
    return true;
}

//读取节点
- (void)readVertex:(FbxMesh*)pMesh ctrlPointIndex:(int)ctrlPIndex vector:(HL3Vector&)pVector{
    FbxVector4 * pControlPoints = pMesh->GetControlPoints();
    pVector.x = pControlPoints[ctrlPIndex][0];
    pVector.y = pControlPoints[ctrlPIndex][1];
    pVector.z = pControlPoints[ctrlPIndex][2];
}

- (void)readColor:(FbxMesh*)pMesh ctrlPointIndex:(int)ctrlPIndex vertexCounter:(int)vertexCounter vector:(HL3Vector4&)pVector{
    if (pMesh->GetElementVertexColorCount() < 1) {
        return;
    }

    FbxGeometryElementVertexColor* pVertexColor = pMesh->GetElementVertexColor(0);
    switch (pVertexColor->GetMappingMode()) {
        case FbxLayerElement::eByControlPoint:{
            switch (pVertexColor->GetReferenceMode()) {
                    
                case FbxLayerElement::eDirect:{
                    pVector.x = pVertexColor->GetDirectArray().GetAt(ctrlPIndex).mRed;
                    pVector.y = pVertexColor->GetDirectArray().GetAt(ctrlPIndex).mGreen;
                    pVector.z = pVertexColor->GetDirectArray().GetAt(ctrlPIndex).mBlue;
                    pVector.w = pVertexColor->GetDirectArray().GetAt(ctrlPIndex).mAlpha;
                }
                    break;
                case FbxLayerElement::eIndexToDirect:{
                    int idValue = pVertexColor->GetIndexArray().GetAt(ctrlPIndex);
                    pVector.x = pVertexColor->GetDirectArray().GetAt(idValue).mRed;
                    pVector.y = pVertexColor->GetDirectArray().GetAt(idValue).mGreen;
                    pVector.z = pVertexColor->GetDirectArray().GetAt(idValue).mBlue;
                    pVector.w = pVertexColor->GetDirectArray().GetAt(idValue).mAlpha;
                }
                    break;
                    
                default:
                    break;
            }
        
        }
            break;
            
        case FbxLayerElement::eByPolygonVertex:{
            switch (pVertexColor->GetReferenceMode()) {
                    
                case FbxLayerElement::eDirect:{
                    pVector.x = pVertexColor->GetDirectArray().GetAt(vertexCounter).mRed;
                    pVector.y = pVertexColor->GetDirectArray().GetAt(vertexCounter).mGreen;
                    pVector.z = pVertexColor->GetDirectArray().GetAt(vertexCounter).mBlue;
                    pVector.w = pVertexColor->GetDirectArray().GetAt(vertexCounter).mAlpha;
                }
                    break;
                case FbxLayerElement::eIndexToDirect:{
                    int idValue = pVertexColor->GetIndexArray().GetAt(vertexCounter);
                    pVector.x = pVertexColor->GetDirectArray().GetAt(idValue).mRed;
                    pVector.y = pVertexColor->GetDirectArray().GetAt(idValue).mGreen;
                    pVector.z = pVertexColor->GetDirectArray().GetAt(idValue).mBlue;
                    pVector.w = pVertexColor->GetDirectArray().GetAt(idValue).mAlpha;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
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
    
    HL3Vector vertex[3];
    HL3Vector4 color[3];
    HL3Vector normal[3];
    HL3Vector tangent[3];
    
    const int triangleCount = lMesh->GetPolygonCount();
    int vertexCounter = 0;
    for (int i = 0; i < triangleCount; i++)
    {
        for (int j = 0; j < 3; j++) {
            int ctrlPointIndex = lMesh->GetPolygonVertex(i, j);
            
            //读取顶点信息
            [self readVertex:lMesh ctrlPointIndex:ctrlPointIndex vector:vertex[j]];
            
            //读取每个顶点的颜色信息
            [self readColor:lMesh ctrlPointIndex:ctrlPointIndex vertexCounter:vertexCounter vector:color[j]];
            
//            NSLog(@"%f,%f,%f,%f",color[j].x,color[j].y,color[j].z,color[j].w);
            
            _fbxObject.vertices->push_back(vertex[j]);
            _fbxObject.colors->push_back(color[j]);
            vertexCounter++;
        }
    }
    NSLog(@"vertice count = %ld",_fbxObject.vertices->size());
    NSLog(@"vertice color count = %ld",_fbxObject.colors->size());
}

//读取fbx object
- (HLFBXObject*)getFBXObject{
    
    //trianglulate
    [self triangulateRecursive:_fbxScene->GetRootNode()];

    //makeSubMeshes
    [self makeSubMeshSetForEachNode:_fbxScene->GetRootNode()];
    
    return _fbxObject;
}


@end
