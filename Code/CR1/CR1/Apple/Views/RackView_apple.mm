//
//  RackView.m
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "RackView_apple.h"

#include "Shared/Core/FCCore.h"

RackViewRef plt_RackView_Create( std::string name, std::string parent );

RackViewRef plt_RackView_Create( std::string name, std::string parent )
{
	return RackViewRef( new RackViewProxy( name, parent ) );
}

@implementation RackView_apple
@synthesize managedViewName = _managedViewName;
@synthesize currentRack = _currentRack;
@synthesize currentIndex = _currentIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)clear
{
	_currentRack = nil;
	[self setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame
{
	super.frame = frame;
}

-(void)setCurrentIndex:(uint8_t)currentIndex
{
	_currentIndex = currentIndex;
	[self setNeedsDisplay];
}

-(void)update:(float)dt
{
}

-(void)fillWithColors:(NSArray*)colors
{
	_currentRack = colors;
	_currentIndex = 0;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGContextRef c = UIGraphicsGetCurrentContext();

	float xSize = rect.size.width / 5;

	uint32_t numBalls = [_currentRack count];
	
	float xOffset = xSize * (5 - numBalls) * 0.5f;

	for (uint32_t iBall = 0; iBall < numBalls; iBall++) {

		if (iBall >= _currentIndex) 
		{
			NSString* color = [_currentRack objectAtIndex:iBall];
			
			if ([color isEqualToString:[NSString stringWithUTF8String:kFCKeyRed.c_str()]]) {
				CGContextSetFillColorWithColor(c, [UIColor redColor].CGColor);
			}
			if ([color isEqualToString:[NSString stringWithUTF8String:kFCKeyGreen.c_str()]]) {
				CGContextSetFillColorWithColor(c, [UIColor greenColor].CGColor);
			}
			if ([color isEqualToString:[NSString stringWithUTF8String:kFCKeyBlue.c_str()]]) {
				CGContextSetFillColorWithColor(c, [UIColor blueColor].CGColor);
			}
			if ([color isEqualToString:[NSString stringWithUTF8String:kFCKeyYellow.c_str()]]) {
				CGContextSetFillColorWithColor(c, [UIColor yellowColor].CGColor);
			}
			
			CGContextBeginPath(c);
			CGContextAddRect(c, CGRectMake(xOffset + 2, 2, xSize - 4, rect.size.height - 4));
			CGContextFillPath(c);
		}
		xOffset += xSize;
	}
	
	if (numBalls) {
		xOffset = xSize * (5 - numBalls) * 0.5f;
		
		CGContextSetLineWidth(c, 4);
		CGContextSetStrokeColorWithColor(c, [UIColor whiteColor].CGColor);
		CGContextBeginPath(c);
		CGContextAddRect(c, CGRectMake(xOffset + (_currentIndex * xSize), 0, xSize, rect.size.height));
		CGContextDrawPath(c, kCGPathStroke);
	}
}

@end
