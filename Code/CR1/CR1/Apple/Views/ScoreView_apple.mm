//
//  ScoreView.m
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "ScoreView_apple.h"

@implementation ScoreView_apple
@synthesize managedViewName = _managedViewName;
@synthesize score = _score;
@synthesize labelView = _labelView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = NO;
		_score = 0;
		
		_labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		[self addSubview:_labelView];
		_labelView.backgroundColor = [UIColor clearColor];
		_labelView.textAlignment = NSTextAlignmentCenter;
		_labelView.shadowColor = [UIColor colorWithRed:0.94 green:0.86 blue:0.51 alpha:1];
		_labelView.shadowOffset = CGSizeMake(1, 1);
    }
    return self;
}

-(void)setScore:(NSNumber*)score
{
	_score = score;
	_labelView.text = [NSString stringWithFormat:@"%@", _score];
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_labelView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	_labelView.font = [UIFont fontWithName:@"helvetica" size:frame.size.height * 0.8];
}

-(void)update:(float)dt
{
	
}

@end
