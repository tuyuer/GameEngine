//
//  HLAppDelegate.m
//  GameEngine
//
//  Created by tuyuer on 14-3-24.
//  Copyright (c) 2014年 hua. All rights reserved.
//

#import "HLAppDelegate.h"

#import "HLViewController.h"
#import "HLTextureCache.h"
#import "HLEGLView.h"
#import "HLDirector.h"
#import "HLSprite.h"
#import "ShaderTestLayer.h"
#import "GameLayer.h"
#import "BlendLayer.h"
#import "StencilTestLayer.h"
#import "LightTestLayer.h"
#import "FBOTestLayer.h"
#import "MipmapTestLayer.h"
#import "VBOTestLayer.h"
#import "IndexBufferTestObject.h"
#import "IndexBufferTestLayer.h"
#import "VaoVboIndexBufferTestLayer.h"

@implementation HLAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    self.viewController = [[[HLViewController alloc] init] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    //open gl view
    HLEGLView * eglView=[[[HLEGLView alloc] initWithFrame:[self.window bounds]] autorelease];
    [self.viewController.view addSubview:eglView];
    
    //bind open gl view to Director
    [[HLDirector sharedDirector] setOpenGLView:eglView];
    //set projection type
    [[HLDirector sharedDirector] setProjection:kCCDirectorProjection3D];
    
    //run game scene --- 
    [[HLDirector sharedDirector] runWithScene:[VaoVboIndexBufferTestLayer scene]];
    
    NSLog(@"Game Engine Runing...");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
