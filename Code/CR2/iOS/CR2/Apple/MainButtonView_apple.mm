//
//  MainButtonView_apple.m
//  CR2
//
//  Created by Martin Linklater on 03/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "MainButtonView_apple.h"
#import "FCLua.h"

#include "Shared/Core/FCCore.h"

@implementation MainButtonView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSelected:)];
		[self addGestureRecognizer:_tapRecognizer];
		self.alpha = 0;
				
		_backgroundImageView = [[UIImageView alloc] initWithImage:nil];
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
		_backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		_backgroundImageView.alpha = 0.8;
		[self addSubview:_backgroundImageView];

		_textClipView = [[UIView alloc] init];
		_textClipView.clipsToBounds = YES;
		[self addSubview:_textClipView];
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_textLabel.textAlignment = UITextAlignmentCenter;
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:self.frame.size.height / 1.2];
		_textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		_textLabel.adjustsFontSizeToFitWidth = YES;
		[_textClipView addSubview:_textLabel];

		_topImageView = [[UIImageView alloc] initWithImage:nil];
		_topImageView.contentMode = UIViewContentModeScaleAspectFit;
		_topImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		[self addSubview:_topImageView];

		self.clipsToBounds = YES;
    }
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:_tapRecognizer];
}

//-(void)setBackgroundColor:(UIColor *)backgroundColor	// DEPRECATE
//{
//	[super setBackgroundColor:backgroundColor];
//}

-(void)setTopImageFilename:(NSString *)filename
{
	UIImage* image = [UIImage imageNamed:filename];
	
	FC_ASSERT( image );
	
	[_topImageView setImage:image];
}

-(void)setBackgroundImageFilename:(NSString *)filename
{
	UIImage* image = [UIImage imageNamed:filename];
	FC_ASSERT( image );
	
	[_backgroundImageView setImage:image];
}

-(void)setText:(NSString*)text
{
	_textLabel.text = text;
	_textLabel.frame = CGRectMake(_textClipView.frame.size.width, 0, _textClipView.frame.size.width, _textClipView.frame.size.height);
	
	[UIView animateWithDuration:6 animations:^{
		_textLabel.frame = CGRectMake(-_textClipView.frame.size.width, 0, _textClipView.frame.size.width, _textClipView.frame.size.height);
	}];
}

-(void)setTextColor:(UIColor*)color
{
	_textLabel.textColor = color;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_textLabel.font = [UIFont fontWithName:@"Helvetica" size:_textClipView.frame.size.height / 1.7];
	
	float yBorder = frame.size.height * 0.15;
	float xBorder = frame.size.width * 0.05;
	_textClipView.frame = CGRectMake(xBorder, yBorder, frame.size.width - xBorder * 2, frame.size.height - yBorder * 2);
	
	_topImageView.frame = CGRectMake(0, yBorder, frame.size.width, frame.size.height - yBorder * 2);
	_backgroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	[self setNeedsDisplay];
}

-(void)buttonSelected:(id)sender;
{
	if (_onSelectLuaFunction && [_onSelectLuaFunction length]) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig([_onSelectLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
	}
}

@end
