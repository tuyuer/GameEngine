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

/**
 * An arbitrary identification. Useful for keeping track of instances. Unique tags are not explicitly
 * required, but are highly recommended. In most cases, it is best to just let the tag be assigned
 * automatically by using an initializer that does not explicitly set the tag.
 */
@property(nonatomic, assign) GLuint tag;

/**
 * An arbitrary name for this object. It is not necessary to give all identifiable objects
 * a name, but can be useful for retrieving objects at runtime, and for identifying objects
 * during development.
 *
 * In general, names need not be unique, are not automatically assigned, and leaving the name
 * as nil is acceptable.
 *
 * Some subclasses are designed so that their instances can be cached. For instances of those
 * subclasses, the name is required, and must be unique.
 */
@property(nonatomic, retain) NSString* name;

/**
 * Returns a string to concatenate to the name of another CC3Identifiable to automatically
 * create a useful name for this instance.
 *
 * This property is used by the deriveNameFrom: method.
 *
 * This implementation simply raises an assertion exception. Each concrete subclass should
 * override this property to return a useful identifiable name suffix. A subclass can return
 * nil from this property to indicate that automatic naming should not be performed.
 */
@property(nonatomic, readonly) NSString* nameSuffix;


#pragma mark User data

/**
 * Application-specific data associated with this object.
 *
 * You can use this property to add any data you want to an instance of CC3Identifiable or its
 * concrete subclasses (CC3Node, CC3Mesh, CC3Material, CC3Texture, etc.). Since this is a generic
 * pointer, you can store any type of data, such as an object, structure, primitive, or array.
 *
 * The data in this property is retained by this instance, and will automatically be freed
 * by the releaseUserData method when this instance is deallocated. If you have instances
 * that share access to common user data, you should use the sharedUserData property instead,
 * which does not automatically free the shared data on deallocation.
 *
 * To assist in managing this data, the methods initUserData and releaseUserData are invoked
 * automatically during the initialization and deallocation of each instance of this class.
 * You can override these methods by subclassing, or by adding extention categories to the
 * concrete subclasses of CC3Identifiable, (CC3Node, CC3Mesh, CC3Material, CC3Texture, etc.),
 * to create, retain and dispose of the data.
 *
 * When copying instances of CC3Identifiable and its subclasses, the copyUserDataFrom: method
 * is invoked in the new copy so that it can copy the data in the original instance to the new
 * instance copy. In this abstract class, the copyUserDataFrom: method does nothing, but, if
 * appropriate, you can override the method by subclassing or by adding extention categories
 * to the concrete subclasses of CC3Identifiable, (CC3Node, CC3Mesh, CC3Material, CC3Texture,
 * etc.), to copy whatever data you have in the userData property.
 */
@property(nonatomic, assign) GLvoid* userData;



/**
 * Invoked automatically from the init* family of methods to initialize the userData property.
 *
 * This implementation simply sets the userData property to NULL. You can override this method
 * in a subclass or by creating extension categories for the concrete subclasses, (CC3Node,
 * CC3Mesh, CC3Material, CC3Texture, etc.), if the userData can be initialized and retained
 * in a self-contained manner.
 *
 * Alternately, you can leave this method unimplemented, and add accessor methods (eg- property
 * methods) that work with the user data content that you define, and have the setter accessor
 * allocate the appropriate content, and then use the userData property to set a pointer to
 * that content in the userData property.
 */
-(void) initUserData;

/**
 * Invoked automatically from the dealloc method to release or dispose of the data referenced
 * in the userData property.
 *
 * This implementation frees the memory pointed to by the userData property, and sets the
 * property to NULL. You can override this method in a subclass or by creating extension
 * categories for the concrete subclasses (CC3Node, CC3Mesh, CC3Material, CC3Texture, etc.),
 * if releasing the user data requires more sophisticated behaviour.
 */
-(void) releaseUserData;



#pragma mark Allocation and initialization

/**
 * Initializes this unnamed instance with an automatically generated unique tag value.
 * The tag value will be generated automatically via the method nextTag.
 */
-(id) init;

/** Initializes this unnamed instance with the specified tag. */
-(id) initWithTag: (GLuint) aTag;

/**
 * Initializes this instance with the specified name and an automatically generated unique
 * tag value. The tag value will be generated automatically via the method nextTag.
 */
-(id) initWithName: (NSString*) aName;

/**
 * Initializes this instance with the specified tag and name.
 * When overriding initialization, subclasses typically need only override this initializer.
 */
-(id) initWithTag: (GLuint) aTag withName: (NSString*) aName;


-(GLuint) nextTag;

/** Resets the allocation of new tags to resume at one again. */
+(void) resetTagAllocation;

/**
 * Indicates the total number of active instances, over all subclasses, that have been allocated
 * and initialized, but not deallocated. This can be useful when creating hordes of 3D objects,
 * to verify that your application is properly deallocating them again when you are done with them.
 */
+(GLint) instanceCount;

/**
 * Returns a string containing a more complete description of this object.
 *
 * This implementation simply invokes the description method. Subclasses with more
 * substantial content can override to provide much more information.
 */
-(NSString*) fullDescription;


@end
