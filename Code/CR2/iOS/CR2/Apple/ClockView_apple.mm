//
//  ClockView_apple.m
//  CR2
//
//  Created by Martin Linklater on 05/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "ClockView_apple.h"

@implementation ClockView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	
		_backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_backgroundImage.backgroundColor = [UIColor clearColor];
		_backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_backgroundImage];

		self.backgroundColor = [UIColor clearColor];
		
		_roundScore = 0;
		_roundScoreMax = 0;
    }
    return self;
}

-(void)setRoundScore:(uint32_t)roundScore
{
	_roundScore = roundScore;
	[self setNeedsDisplay];
}

-(void)setRoundScoreMax:(uint32_t)roundScoreMax
{
	_roundScoreMax = roundScoreMax;
	[self setNeedsDisplay];
}

-(void)setBackgroundImage:(NSString*)filename
{
	_backgroundImage.image = [UIImage imageNamed:filename];
}

-(void)setFrame:(CGRect)frame
{
	_backgroundImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	[super setFrame:frame];
}

-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	if ((_roundScoreMax == 0.0f) || (_roundScore == 0.0f) ) {
		return;
	}
	
	int maxSegments = 16;
	
	CGContextRef c = UIGraphicsGetCurrentContext();

	float timeFraction;
	if (_roundScoreMax > 0.0f) {
		timeFraction = (float)_roundScore / (float)_roundScoreMax;
	} else {
		timeFraction = 1.0f;
	}
	int numSegments = (int)(timeFraction * maxSegments) + 1;
	if( numSegments > maxSegments)
	{
		numSegments = maxSegments;
	}

//	CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
	CGContextSetLineWidth(c, 0);
	CGContextSetFillColorWithColor(c, [UIColor colorWithRed:1.0f - timeFraction green:timeFraction blue:0 alpha:1].CGColor);
//	CGContextSetStrokeColorWithColor(c, [UIColor colorWithRed:1.0f - timeFraction green:timeFraction blue:0 alpha:1].CGColor);
	
	CGSize center = CGSizeMake(rect.size.width * 0.5, rect.size.height * 0.5);
	float radius = rect.size.width / 3;
	
	for (int i = 0; i < numSegments; i++) {
		float para = (float)i / (float)maxSegments;
		CGContextSetFillColorWithColor(c, [UIColor colorWithRed:1.0f - para green:para blue:0 alpha:1].CGColor);
		float angle1 = ((float)i * 6.28f / (float)maxSegments) + 3.14f;
		float angle2 = ((float)(i+1) * 6.28f / (float)maxSegments) + 3.14f;

		CGContextBeginPath(c);
		CGContextMoveToPoint(c, center.width, center.height);
		CGContextAddLineToPoint(c,	center.width + sin(angle1) * radius,
									center.height + cos(angle1) * radius );
		CGContextAddLineToPoint(c,	center.width + sin(angle2) * radius,
									center.height + cos(angle2) * radius );
		CGContextFillPath(c);
	}
	
}

@end