//
//  ViewController.m
//  CR1
//
//  Created by Martin Linklater on 04/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import "ViewController.h"

#include "shared/Core/FCCore.h"
#include "shared/Framework/FCApplication.h"

@implementation ViewController

extern UIViewController* s_rootViewController;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		s_rootViewController = self;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	switch ( interfaceOrientation )
		{
			case UIInterfaceOrientationPortrait:
			case UIInterfaceOrientationPortraitUpsideDown:
				return FCApplication::Instance()->ShouldAutorotateToInterfaceOrientation( kFCInterfaceOrientation_Portrait );
			case UIInterfaceOrientationLandscapeLeft:
			case UIInterfaceOrientationLandscapeRight:
				return FCApplication::Instance()->ShouldAutorotateToInterfaceOrientation( kFCInterfaceOrientation_Landscape );
		}
//	return [[FCApplication_old instance] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
