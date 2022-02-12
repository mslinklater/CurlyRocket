//
//  GameLabelView_apple.m
//  CR3
//
//  Created by Martin Linklater on 29/11/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "GameLabelView_apple.h"

#include "Shared/Framework/UI/FCViewManagerTypes.h"
#include "Shared/FCPlatformInterface.h"

@implementation GameLabelView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		mLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self addSubview:mLabel];
		mLabel.adjustsFontSizeToFitWidth = YES;
		self.backgroundColor = [UIColor clearColor];
		mLabel.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		
		mLabel.shadowColor = [UIColor whiteColor];
		mLabel.shadowOffset = CGSizeMake(2, 2);
		
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	mLabel.frame = CGRectMake( 0, 0, frame.size.width, frame.size.height );
}

-(void)setFontName:(NSString*)fontName
{
	mFontName = fontName;
}

-(void)setFontSize:(float)size
{
	mLabel.font = [UIFont fontWithName:mFontName size:size];
}

-(void)setTextColor:(UIColor *)color
{
	mLabel.textColor = color;
}

-(void)setText:(NSString *)text
{
	mLabel.text = text;
}

-(void)setTextAlignment:(int)alignment
{
	switch (alignment) {
		case kFCViewTextAlignmentLeft:
			mLabel.textAlignment = NSTextAlignmentLeft;
			break;
		case kFCViewTextAlignmentCenter:
			mLabel.textAlignment = NSTextAlignmentCenter;
			break;
		case kFCViewTextAlignmentRight:
			mLabel.textAlignment = NSTextAlignmentRight;
			break;
			
		default:
			fc_FCError_Fatal("unknown enum");
			break;
	}
}


-(void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
	//	mLabel.backgroundColor = backgroundColor;
}
@end
