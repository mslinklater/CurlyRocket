//
//  AppDelegate.m
//  CR1
//
//  Created by Martin Linklater on 04/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TestFlight.h"

#import "FCApplication_apple.h"

#include "Shared/Framework/FCApplication.h"
#include "GameAppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	FCApplication::Instance()->RegisterExceptionHandler();
	FCApplication::Instance()->SetAnalyticsID("G91JI6NGVKS9VHEQDZR4");
	FCApplication::Instance()->SetTestFlightID("c9dd01f96088d4e12f0bb19a3963658d_NzIzODEyMDEyLTAzLTE3IDE1OjEyOjE2LjM5NjM1Mw");
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    // Override point for customization after application launch.

	self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

	GameAppDelegate* pGameAppDelegate = new GameAppDelegate;
	
	FCApplication::Instance()->ColdBoot( pGameAppDelegate );
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
	
	FCApplication::Instance()->WillResignActive();
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
	FCApplication::Instance()->DidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
	FCApplication::Instance()->WillEnterForeground();
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
	FCApplication::Instance()->DidBecomeActive();
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
	FCApplication::Instance()->WillTerminate();
}

@end
