//
//  ViewController.m
//  CR2
//
//  Created by Martin Linklater on 20/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "ViewController.h"

extern UIViewController* s_rootViewController;

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		s_rootViewController = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
