//
//  RoundsView.m
//  CR1
//
//  Created by Martin Linklater on 16/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "RoundsView_apple.h"

RoundsViewRef plt_RoundsView_Create( std::string name, std::string parent );

RoundsViewRef plt_RoundsView_Create( std::string name, std::string parent )
{
	return RoundsViewRef( new RoundsViewProxy( name, parent ) );
}

@implementation RoundsView_apple

@synthesize managedViewName = _managedViewName;
@synthesize numRounds = _numRounds;
@synthesize currentRound = _currentRound;
@synthesize labelView = _labelView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		_labelView.backgroundColor = [UIColor clearColor];
		_labelView.shadowColor = [UIColor colorWithRed:0.94 green:0.86 blue:0.51 alpha:1];
		_labelView.shadowOffset = CGSizeMake(1, 1);
		[self addSubview:_labelView];
    }
    return self;
}

-(void)setNumRounds:(int)numRounds
{
	_numRounds = numRounds;
	[self refreshView];
}

-(void)setCurrentRound:(int)currentRound
{
	_currentRound = currentRound;
	[self refreshView];
}

-(void)refreshView
{
	_labelView.text = [NSString stringWithFormat:@"%d / %d", _currentRound + 1, _numRounds];
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
