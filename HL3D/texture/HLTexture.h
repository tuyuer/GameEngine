//
//  HLTexture.h
//  OES
//
//  Created by tuyuer on 14-1-8.
//  Copyright (c) 2014年 tuyuer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTexture : NSObject{
    //about texture
    GLint _uName;
    
    CGSize _tContentSize;
}
@property (nonatomic,readonly) CGSize contentSize;
@property (nonatomic,readonly) GLint Name;
- (id)initWithImage:(UIImage *)uiImage;
@end
