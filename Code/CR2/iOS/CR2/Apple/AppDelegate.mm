//
//  AppDelegate.m
//  CR2
//
//  Created by Martin Linklater on 19/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#include "Shared/Framework/FCApplication.h"
#include "GameAppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	FCApplication::Instance()->RegisterExceptionHandler();
	FCApplication::Instance()->SetAnalyticsID("7FK2WPD45C9XQWRZNNYW");
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];

	self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
	self.window.rootViewController = self.viewController;
    
    // Override point for customization after application launch.
	
    [self.window makeKeyAndVisible];

	GameAppDelegate* pGameAppDelegate = new GameAppDelegate;
	
	FCApplicationColdBootParams params;
	params.pDelegate = pGameAppDelegate;
	params.allowableOrientationsMask = kFCInterfaceOrientation_Portrait;
	
	FCApplication::Instance()->ColdBoot( params );

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	FCApplication::Instance()->WillResignActive();
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	FCApplication::Instance()->DidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	FCApplication::Instance()->WillEnterForeground();
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	FCApplication::Instance()->DidBecomeActive();
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	FCApplication::Instance()->WillTerminate();
}

@end
