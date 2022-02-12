//
//  AppDelegate.m
//  CR3
//
//  Created by Martin Linklater on 04/10/2012.
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
#if defined(ADHOC)
	FCApplication::Instance()->SetAnalyticsID("SJPPP6JSY9RNQ4R6SCNB");
#else
	FCApplication::Instance()->SetAnalyticsID("7KBSQGXJF89CRD9N7GXM");	// debug app ID
#endif
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor blackColor];
    // Override point for customization after application launch.
	
	self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];

	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	GameAppDelegate* pGameAppDelegate = new GameAppDelegate;
	
	FCApplicationColdBootParams params;
	params.pDelegate = pGameAppDelegate;
	params.allowableOrientationsMask = kFCInterfaceOrientation_Portrait;
	FCApplication::Instance()->ColdBoot( params );
	FCApplication::Instance()->WarmBoot();

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	FCApplication::Instance()->WillResignActive();
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	FCApplication::Instance()->DidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	FCApplication::Instance()->WillEnterForeground();
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	FCApplication::Instance()->DidBecomeActive();
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	FCApplication::Instance()->WillTerminate();
}

@end
