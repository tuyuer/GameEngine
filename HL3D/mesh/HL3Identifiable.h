//
//  HL3Identifiable.h
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 这个类是所有使用tags或names标识唯一实例的基类
 *  此实例可以使用tag 或 name进行初使化，
 *  没有使用显式声明的实例将会生成一个唯一标识
 *  你可以传数据到userData
 */

@interface HL3Identifiable : NSObject{
    GLuint _tag;
    NSString * _name;
    GLvoid * _userData;
}


@property(nonatomic, assign) GLuint tag;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, readonly) NSString* nameSuffix;
@property(nonatomic, assign) GLvoid* userData;

-(void) initUserData;
-(void) releaseUserData;

-(id) init;
-(id) initWithTag: (GLuint) aTag;
-(id) initWithName: (NSString*) aName;
-(id) initWithTag: (GLuint) aTag withName: (NSString*) aName;

-(GLuint) nextTag;
+(void) resetTagAllocation;
+(GLint) instanceCount;
-(NSString*) fullDescription;


@end
