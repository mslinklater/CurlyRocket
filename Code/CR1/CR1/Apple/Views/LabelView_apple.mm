//
//  LabelView.m
//  CR1
//
//  Created by Martin Linklater on 28/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import "LabelView_apple.h"

@implementation LabelView_apple

@synthesize managedViewName = _managedViewName;
@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		_style = kLabelViewStyleNormal;
		
		self.textColor = [UIColor colorWithRed:0.045 green:0.04 blue:0.025 alpha:0.9];
		self.backgroundColor = [UIColor clearColor];
		self.textAlignment = NSTextAlignmentCenter;
		self.shadowColor = [UIColor colorWithRed:0.94 green:0.86 blue:0.51 alpha:1];
		self.shadowOffset = CGSizeMake(1, 1);
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
	switch (_style) {
		case kLabelViewStyleTwitter:
			self.font = [UIFont fontWithName:@"Verdana" size:frame.size.height / 2.5];			
			break;
		default:
//			self.font = [UIFont fontWithName:@"Zapfino" size:frame.size.height / 3.5];
			self.font = [UIFont fontWithName:@"Fortune Cookie NF" size:frame.size.height / 2];
			break;
	}
	[super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	// draw box around bounds
	
	switch (_style) {
		case kLabelViewStyleNormal:
			break;
			
		default:
			break;
	}
}

@end
