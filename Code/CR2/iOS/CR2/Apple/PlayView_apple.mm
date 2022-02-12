//
//  PlayView_apple.m
//  CR2
//
//  Created by Martin Linklater on 26/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "PlayView_apple.h"
#import "FCLua.h"

#include "Shared/Core/FCCore.h"
#include "GameTypes.h"

@implementation PlayView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		self.alpha = 0;
		numCurrentTouches = 0;
		
		_pressed = @0;
		_interactive = @0;
		
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
		
    }
    return self;
}

-(void)dealloc
{
}

-(void)updateColor
{
	if( [_pressed intValue] )
		_imageView.image = _pressedImage;
	else
	{
		_imageView.image = _normalImage;
	}
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	[self setNeedsDisplay];
}

-(void)setColor:(NSNumber *)color
{
	_color = color;
	[self updateColor];
}

-(void)setPressed:(NSNumber *)pressed
{
	_pressed = pressed;
	[self updateColor];
}

-(void)setImageFilename:(NSString *)imageFilename
{
	_normalImage = [UIImage imageNamed:imageFilename];
	FC_ASSERT( _normalImage );
	_imageFilename = imageFilename;
}

-(void)setImagePressedFilename:(NSString *)imagePressedFilename
{
	_pressedImage = [UIImage imageNamed:imagePressedFilename];
	FC_ASSERT( _pressedImage );
	_imagePressedFilename = imagePressedFilename;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(( numCurrentTouches == 0) && [_interactive intValue])
	{
		if (_onTouchBeganLuaFunction && [_onTouchBeganLuaFunction length]) {
			FCLua::Instance()->CoreVM()->CallFuncWithSig([_onTouchBeganLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
		}
		_pressed = @1;
		[self updateColor];
	}
		
	numCurrentTouches += [touches count];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	numCurrentTouches -= [touches count];

	if (numCurrentTouches < 0) {
		numCurrentTouches = 0;
	}
	
	if(( numCurrentTouches == 0) && [_interactive intValue])
	{
		if (_onTouchEndedLuaFunction && [_onTouchEndedLuaFunction length]) {
			FCLua::Instance()->CoreVM()->CallFuncWithSig([_onTouchEndedLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
		}
		_pressed = @0;
		[self updateColor];
	}
}

//- (void)drawRect:(CGRect)rect
//{
//	CGContextRef c = UIGraphicsGetCurrentContext();
//	
//	CGRect f = self.frame;
//
//	f.origin.x = 0;
//	f.origin.y = 0;
//	
//	if ([_interactive intValue] && [_pressed intValue]) {
//		f.origin.x += f.size.width * 0.03;
//		f.origin.y += f.size.height * 0.03;
//		f.size.width *= 0.94;
//		f.size.height *= 0.94;
//	}
//	
//	float w = f.size.width;
//	
//	CGContextSetFillColorWithColor(c, [_realColor CGColor]);
//	CGContextSetLineWidth(c, 0);
//	
//	CGContextBeginPath(c);
//	CGContextAddRect(c, f);
//	CGContextFillPath( c );
//
//	float r, g, b, a;
//	[_realColor getRed:&r green:&g blue:&b alpha:&a];
//
//	CGContextSetStrokeColorWithColor(c, [UIColor colorWithRed:r + 0.1 green:g + 0.1 blue:b + 0.1 alpha:1.0].CGColor);
//	CGContextSetLineWidth(c, w * 0.02f);
//	CGContextBeginPath(c);
//	CGContextAddRect(c, f);
//	CGContextStrokePath( c );
//	
//	if ([_pressed intValue]) {
//		CGGradientRef myGradient;
//		CGColorSpaceRef rgbColorspace;
//		size_t num_locations = 3;
//		CGFloat locations[3] = { 0.0, 0.15, 1.0 };
//		
//		const CGFloat* topColors = CGColorGetComponents( [UIColor colorWithRed:r+0.6 green:g+0.6 blue:b+0.6 alpha:1.0].CGColor );
//		const CGFloat* bottomColors = CGColorGetComponents( [UIColor colorWithRed:r green:g blue:b alpha:0].CGColor );
//		
//		CGFloat components[12] = {   topColors[0], topColors[1], topColors[2], topColors[3],  // Start color
//			topColors[0], topColors[1], topColors[2], topColors[3],
//			bottomColors[0], bottomColors[1], bottomColors[2], bottomColors[3] }; // End color
//		
//		rgbColorspace = CGColorSpaceCreateDeviceRGB();
//		myGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
//
//		CGPoint myStartPoint, myEndPoint;
//		CGFloat myStartRadius, myEndRadius;
//		myStartPoint.x = rect.size.width * 0.5;
//		myStartPoint.y = rect.size.height * 0.5;
//		myEndPoint.x = rect.size.width * 0.5;
//		myEndPoint.y = rect.size.height * 0.5;
//		myStartRadius = 0.0;
//		myEndRadius = w;
//		CGContextDrawRadialGradient (c, myGradient, myStartPoint,
//									 myStartRadius, myEndPoint, myEndRadius,
//									 kCGGradientDrawsAfterEndLocation);
//	}
//}

@end
