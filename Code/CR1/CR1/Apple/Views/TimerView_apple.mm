//
//  TimerView.m
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#include "Shared/Core/FCCore.h"

#import "TimerView_apple.h"

static TimerView_apple* s_pTimerView;

TimerViewRef plt_TimerView_Create( std::string name, std::string parent );

TimerViewRef plt_TimerView_Create( std::string name, std::string parent )
{
	return TimerViewRef( new TimerViewProxy( name, parent ) );
}

#pragma mark - Lua Functions

#pragma mark - ObjC

@implementation TimerView_apple
@synthesize managedViewName = _managedViewName;
@synthesize totalTime = _totalTime;
@synthesize timeRemaining = _timeRemaining;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		s_pTimerView = self;
		
		self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)dealloc
{
}

-(void)update:(float)dt
{
}

-(void)setTotalTime:(float)totalTime
{
	_totalTime = totalTime;
	[self setNeedsDisplay];
}

-(void)setTimeRemaining:(float)timeRemaining
{
	_timeRemaining = timeRemaining;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	CGContextRef c = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
	CGContextBeginPath(c);
	CGContextAddRect(c, rect);
	CGContextFillPath(c);

	CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
	CGContextBeginPath(c);
	float height = rect.size.height * (_timeRemaining / _totalTime);
	CGContextAddRect(c, CGRectMake(2, rect.size.height - height, rect.size.width - 4, height));
	CGContextFillPath(c);
}

@end
