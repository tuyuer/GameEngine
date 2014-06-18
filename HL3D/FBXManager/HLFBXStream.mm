//
//  HLFBXStream.cpp
//  GameEngine
//
//  Created by tuyuer on 14-4-15.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#include "HLFBXStream.h"

HLFBXStream::HLFBXStream( FbxManager* pSdkManager, const char* mode ,const char * filePath)
{
    mFile = NULL;
    
    // expect the mode to contain something
    if (mode == NULL) return;
    
    FBXSDK_strcpy(mFileName, 1000, filePath);
    FBXSDK_strcpy(mMode, 3, (mode) ? mode : "r");
    
    if ( mode[0] == 'r' )
    {
        const char* format = "FBX (*.fbx)";
        mReaderID = pSdkManager->GetIOPluginRegistry()->FindReaderIDByDescription( format );
        mWriterID = -1;
    }
    else
    {
        const char* format = "FBX ascii (*.fbx)";
        mWriterID = pSdkManager->GetIOPluginRegistry()->FindWriterIDByDescription( format );
        mReaderID = -1;
    }
}

HLFBXStream::~HLFBXStream()
{
    Close();
}


FbxStream::EState HLFBXStream::GetState()
{
    return mFile ? FbxStream::eOpen : eClosed;
}

bool HLFBXStream::Open( void* /*pStreamData*/ )
{
    // This method can be called several times during the
    // Initialize phase so it is important that it can handle
    // multiple opens
    if (mFile == NULL)
        FBXSDK_fopen(mFile, mFileName, mMode);
    
    if (mFile != NULL)
        fseek( mFile, 0L, SEEK_SET );
    
    return ( mFile != NULL );
}

bool HLFBXStream::Close()
{
    // This method can be called several times during the
    // Initialize phase so it is important that it can handle multiple closes
    if ( mFile )
        fclose( mFile );
    mFile = NULL;
    return true;
}

bool HLFBXStream::Flush()
{
    return true;
}

int HLFBXStream::Write(const void* pData, int pSize)
{
    if ( mFile == NULL )
        return 0;
    return (int)fwrite( pData, 1, pSize, mFile );
}

int HLFBXStream::Read (void* pData, int pSize) const
{
    if ( mFile == NULL )
        return 0;
    return (int)fread( pData, 1, pSize, mFile );
}

int HLFBXStream::GetReaderID() const
{
    return mReaderID;
}

int HLFBXStream::GetWriterID() const
{
    return mWriterID;
}

void HLFBXStream::Seek( const FbxInt64& pOffset, const FbxFile::ESeekPos& pSeekPos )
{
    switch ( pSeekPos )
    {
        case FbxFile::eBegin:
            fseek( mFile, (long)pOffset, SEEK_SET );
            break;
        case FbxFile::eCurrent:
            fseek( mFile, (long)pOffset, SEEK_CUR );
            break;
        case FbxFile::eEnd:
            fseek( mFile, (long)pOffset, SEEK_END );
            break;
    }
}

long HLFBXStream::GetPosition() const
{
    if ( mFile == NULL )
        return 0;
    return ftell( mFile );
}

void HLFBXStream::SetPosition( long pPosition )
{
    if ( mFile )
        fseek( mFile, pPosition, SEEK_SET );
}

int HLFBXStream::GetError() const
{
    if ( mFile == NULL )
        return 0;
    return ferror( mFile );
}

void HLFBXStream::ClearError()
{
    if ( mFile != NULL )
        clearerr( mFile );
}







