//
//  HLFBXStream.h
//  GameEngine
//
//  Created by tuyuer on 14-4-15.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#ifndef __GameEngine__HLFBXStream__
#define __GameEngine__HLFBXStream__

#include <iostream>
#include "fbxsdk.h"

class HLFBXStream:public FbxStream{
private:
    FILE*   mFile;
    int             mReaderID;
    int             mWriterID;
    char    mFileName[1000];
    char    mMode[3];
public:
    HLFBXStream( FbxManager* pSdkManager, const char* mode,const char * filePath );
    ~HLFBXStream();
    
    virtual EState GetState();
    virtual bool Open( void* /*pStreamData*/ );
    virtual bool Close();
    virtual bool Flush();
    virtual int Write(const void* pData, int pSize);
    virtual int Read (void* pData, int pSize) const;
    virtual int GetReaderID() const;
    virtual int GetWriterID() const;
    void Seek( const FbxInt64& pOffset, const FbxFile::ESeekPos& pSeekPos );
    
    virtual long GetPosition() const;
    virtual void SetPosition( long pPosition );
    virtual int GetError() const;
    virtual void ClearError();
};

#endif /* defined(__GameEngine__HLFBXStream__) */
