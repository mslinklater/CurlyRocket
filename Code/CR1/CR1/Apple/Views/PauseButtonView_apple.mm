//
//  PauseButtonView.m
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "PauseButtonView_apple.h"

#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"

static void PauseHandler( FCNotification note, void* context )
{
	PauseButtonView_apple* instance = (__bridge PauseButtonView_apple*)context;
	
	instance.paused = YES;
	[instance setNeedsDisplay];
}

static void ResumeHandler( FCNotification note, void* context )
{
	PauseButtonView_apple* instance = (__bridge PauseButtonView_apple*)context;
	
	instance.paused = NO;
	[instance setNeedsDisplay];
}

@implementation PauseButtonView_apple
@synthesize managedViewName = _managedViewName;
@synthesize paused = _paused;
@synthesize tapRecogniser = _tapRecogniser;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		_paused = NO;
		_tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pausePressed:)];
		[self addGestureRecognizer:_tapRecogniser];
		
		FCNotificationManager::Instance()->AddSubscription( PauseHandler, kFCNotificationPause, (__bridge void*)self );
		FCNotificationManager::Instance()->AddSubscription( ResumeHandler, kFCNotificationResume, (__bridge void*)self );
    }
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:_tapRecogniser];
	
	FCNotificationManager::Instance()->RemoveSubscription( PauseHandler, kFCNotificationPause );
	FCNotificationManager::Instance()->RemoveSubscription( ResumeHandler, kFCNotificationResume );
}

-(void)pausePressed:(id)sender
{
	if (_paused) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig("ResumePressed", true, "");
	} else {
		FCLua::Instance()->CoreVM()->CallFuncWithSig("PausePressed", true, "");
	}
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

	float eighthX = rect.size.width / 8;
	float eighthY = rect.size.height / 8;
	
	if (_paused) {
		CGContextBeginPath(c);
		CGContextMoveToPoint(c, eighthX, eighthY);
		CGContextAddLineToPoint(c, eighthX * 7, eighthY * 4);
		CGContextAddLineToPoint(c, eighthX, eighthY * 7);
		CGContextClosePath(c);
		CGContextFillPath(c);
	} else {
		CGContextBeginPath(c);
		CGContextAddRect(c, CGRectMake(eighthX, eighthY, eighthX * 2, eighthY * 6));
		CGContextFillPath(c);
		CGContextBeginPath(c);
		CGContextAddRect(c, CGRectMake(eighthX * 5, eighthY, eighthX * 2, eighthY * 6));
		CGContextFillPath(c);
	}
}

@end
