//
//  ViewController.m
//  CR4
//
//  Created by Martin Linklater on 10/01/2013.
//  Copyright (c) 2013 Martin Linklater. All rights reserved.
//

#import "ViewController.h"
#import "FCApplication_apple.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		FCSetRootViewController( self );
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		return YES;
	}
	return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
