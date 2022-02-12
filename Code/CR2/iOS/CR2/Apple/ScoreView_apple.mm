//
//  ScoreView_apple.m
//  CR2
//
//  Created by Martin Linklater on 05/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "ScoreView_apple.h"

@implementation ScoreView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	
		_backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_backgroundImage.backgroundColor = [UIColor clearColor];
		_backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_backgroundImage];

		_bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_bankLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		_bankLabel.backgroundColor = [UIColor clearColor];
		_bankLabel.textAlignment = UITextAlignmentCenter;

		[self addSubview:_bankLabel];

		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setBackgroundImage:(NSString*)filename
{
	_backgroundImage.image = [UIImage imageNamed:filename];
}

-(void)setFrame:(CGRect)frame
{
	_backgroundImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	_bankLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	_bankLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:frame.size.height / 1.8];
	[super setFrame:frame];
}

-(void)setBank:(uint32_t)bank
{
	_bankLabel.text = [NSString stringWithFormat:@"%d", bank];
}

-(void)setShowBar:(NSNumber *)showBar
{
    _showBar = showBar;
    
	[self setNeedsDisplay];
}

@end