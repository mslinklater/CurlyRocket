//
//  BackgroundView_apple.m
//  CR2
//
//  Created by Martin Linklater on 08/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Shared/Framework/FCApplication.h"

#import "BackgroundView_apple.h"

@implementation BackgroundView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		
		_backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;

		[self addSubview:_backgroundImageView];
	}
    return self;
}

-(void)setBackgroundImage:(NSString*)filename
{
	_backgroundImageView.image = [UIImage imageNamed:filename];
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_backgroundImageView.frame = CGRectMake( 0, 0, frame.size.width, frame.size.height );
}

@end