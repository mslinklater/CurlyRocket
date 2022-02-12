//
//  ViewCommon.m
//  CR1
//
//  Created by Martin Linklater on 02/03/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "ViewCommon_apple.h"

@implementation ViewCommon_apple

+(void)drawButtonStyle1:(CGRect)rect
{
	float width = rect.size.width;
	float height = rect.size.height;
	
	float scale = 1.0f;
	
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		scale = 2.4f;
	}
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	// background
	
	CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    const CGFloat* topColors = CGColorGetComponents( [UIColor colorWithRed:0.09 green:0.08 blue:0.05 alpha:0.9].CGColor );
    const CGFloat* bottomColors = CGColorGetComponents( [UIColor colorWithRed:0.045 green:0.04 blue:0.025 alpha:0.9].CGColor );
    
    CGFloat components[8] = {   topColors[0], topColors[1], topColors[2], topColors[3],  // Start color
        bottomColors[0], bottomColors[1], bottomColors[2], bottomColors[3] }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGPoint topCenter = CGPointMake( width * 0.5f, 0.0f);
    CGPoint bottomCenter = CGPointMake( width * 0.5f, height + 1);
    CGContextDrawLinearGradient(c, glossGradient, topCenter, bottomCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
	
	CGContextSetStrokeColorWithColor(c, [UIColor colorWithRed:.95 green:0.86 blue:0.5 alpha:1].CGColor );
	CGContextSetLineWidth(c, scale);
	
	// outside bottom right
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, width * 0.5f, height - (1 * scale) );
	CGContextAddLineToPoint(c, width - ( 1.5f * scale ), height - ( 1 * scale ) );
	CGContextAddLineToPoint(c, width - ( 1.5f * scale ), height * 0.5f);
	CGContextStrokePath(c);
	
	// lower curl
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 1 * scale, 3 * scale);
	CGContextAddCurveToPoint(c, 10 * scale, 10 * scale, 14 * scale, 14 * scale, 14 * scale, 18 * scale);
	CGContextAddCurveToPoint(c, 14 * scale, 19 * scale, 13 * scale, 20 * scale, 12 * scale, 20 * scale);
	CGContextAddCurveToPoint(c, 8 * scale, 20 * scale, 4 * scale, 15 * scale, 2 * scale, 8 * scale);
	CGContextStrokePath(c);
	
	// upper curl
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 3 * scale, 1 * scale);
	CGContextAddCurveToPoint(c, 10 * scale, 10 * scale, 14 * scale, 14 * scale, 18 * scale, 14 * scale);
	CGContextAddCurveToPoint(c, 19 * scale, 14 * scale, 20 * scale, 13 * scale, 20 * scale, 12 * scale);
	CGContextAddCurveToPoint(c, 20 * scale, 8 * scale, 15 * scale, 4 * scale, 8 * scale, 2 * scale);
	CGContextStrokePath(c);
	
	// diamond
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 16 * scale, 16 * scale);
	CGContextAddLineToPoint(c, 19 * scale, 18 * scale);
	CGContextAddLineToPoint(c, 20 * scale, 20 * scale);
	CGContextAddLineToPoint(c, 18 * scale, 19 * scale);
	CGContextClosePath(c);
	CGContextStrokePath(c);
	
	// left vert lines
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 1.5f * scale, 14 * scale);
	CGContextAddLineToPoint(c, 1.5f * scale, height - ( 1 * scale ));
	CGContextStrokePath(c);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 3.5f * scale, 19 * scale);
	CGContextAddLineToPoint(c, 3.5f * scale, height - ( 3 * scale ) );
	CGContextStrokePath(c);
	
	// top horiz lines
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 14 * scale, 1 * scale);
	CGContextAddLineToPoint(c, width - ( 1.5f * scale ), 1 * scale);
	CGContextStrokePath(c);
	
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, 17 * scale, 3 * scale);
	CGContextAddLineToPoint(c, width - ( 6.5f * scale ), 3 * scale);
	CGContextStrokePath(c);
}

@end
