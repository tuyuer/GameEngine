//
//  HL3Identifiable.m
//  GameEngine
//
//  Created by huxiaozhou on 14-6-20.
//  Copyright (c) 2014年 Hoolai. All rights reserved.
//

#import "HL3Identifiable.h"

@implementation HL3Identifiable

@synthesize tag=_tag, name=_name;

static GLint instanceCount = 0;

-(void) dealloc {
	[self releaseUserData];
	[_name release];
	instanceCount--;
	[super dealloc];
}


-(NSString*) nameSuffix {
//	CC3Assert(NO, @"%@ must override the nameSuffix property.", [self class]);
	return nil;
}

-(GLvoid*) userData { return _userData; }

-(void) setUserData: (GLvoid*) userData {
	[self releaseUserData];
	_userData = userData;
}


#pragma mark Allocation and initialization

-(id) init { return [self initWithName: nil]; }

-(id) initWithTag: (GLuint) aTag { return [self initWithTag: aTag withName: nil]; }

-(id) initWithName: (NSString*) aName {
	return [self initWithTag: [self nextTag] withName: aName];
}

-(id) initWithTag: (GLuint) aTag withName: (NSString*) aName {
	if ( (self = [super init]) ) {
		instanceCount++;
		self.tag = aTag;
		self.name = aName;
		[self initUserData];
	}
	return self;
}

-(void) initUserData { _userData = NULL; }

-(void) releaseUserData {
	free(_userData);
	_userData = NULL;
}


// Class variable tracking the most recent tag value assigned. This class variable is
// automatically incremented whenever the method nextTag is called.
static GLuint lastAssignedTag;

-(GLuint) nextTag { return ++lastAssignedTag; }

-(NSString*) description {
	return [NSString stringWithFormat: @"%@ '%@':%u", [self class], (_name ? _name : @"Unnamed"), _tag];
}

-(NSString*) fullDescription { return [self description]; }

+(GLint) instanceCount { return instanceCount; }



@end
