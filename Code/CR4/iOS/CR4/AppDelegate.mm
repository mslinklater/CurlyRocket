//
//  AppDelegate.m
//  CR4
//
//  Created by Martin Linklater on 10/01/2013.
//  Copyright (c) 2013 Martin Linklater. All rights reserved.
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
	FCApplication::Instance()->SetAnalyticsID("8BRBQWT9WCR5HCPHMKX7");
#else
	FCApplication::Instance()->SetAnalyticsID("7KBSQGXJF89CRD9N7GXM");	// debug app ID
#endif

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
	self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

	GameAppDelegate* pGameAppDelegate = new GameAppDelegate;
	
	FCApplicationColdBootParams params;
	params.pDelegate = pGameAppDelegate;
	params.allowableOrientationsMask = kFCInterfaceOrientation_Landscape;
	
	// command line arguments

#if !defined( ADHOC )
	NSArray* args = [[NSProcessInfo processInfo] arguments];
	NSMutableString* argsString = [NSMutableString string];
	for( int i = 1 ; i < [args count] ; i++ )
	{
		if(i == 1)
			[argsString appendFormat:@"%@", args[i]];
		else
			[argsString appendFormat:@" %@", args[i]];
	}
	params.commandLineArguments = [argsString UTF8String];
#endif
	
	FCApplication::Instance()->ColdBoot( params );
	FCApplication::Instance()->WarmBoot( );

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
