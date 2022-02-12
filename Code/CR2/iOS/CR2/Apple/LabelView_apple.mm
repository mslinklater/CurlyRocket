//
//  LabelView.m
//  CR1
//
//  Created by Martin Linklater on 28/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

// TODO: This could move to FC with a bit of work

#import "LabelView_apple.h"

@implementation LabelView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		self.backgroundColor = [UIColor clearColor];
		self.textAlignment = UITextAlignmentCenter;
		self.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		self.shadowOffset = CGSizeMake(2, 2);
		self.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
	self.font = [UIFont fontWithName:@"Helvetica Neue" size:frame.size.height / 1.7];
	[super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
}

@end
