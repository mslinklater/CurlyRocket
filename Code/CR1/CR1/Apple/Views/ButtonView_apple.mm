//
//  ButtonView.m
//  CR1
//
//  Created by Martin Linklater on 29/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import "ButtonView_apple.h"
#import "FCLua.h"
#import "ViewCommon_apple.h"

#include "Shared/Core/FCCore.h"

@implementation ButtonView_apple

@synthesize tapRecognizer = _tapRecognizer;
@synthesize textLabel = _textLabel;
@synthesize managedViewName = _managedViewName;
@synthesize onSelectLuaFunction = _onSelectLuaFunction;
@synthesize onSelectTarget = _onSelectTarget;
@synthesize onSelectMethod = _onSelectMethod;
@synthesize customDrawTarget = _customDrawTarget;
@synthesize customDrawMethod = _customDrawMethod;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSelected:)];
		[self addGestureRecognizer:_tapRecognizer];
		self.alpha = 0;
	
    }
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:_tapRecognizer];
}

-(void)createTextView
{
	_textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	_textLabel.textAlignment = NSTextAlignmentCenter;
	_textLabel.backgroundColor = [UIColor clearColor];
//	_textLabel.font = [UIFont fontWithName:@"Fortune Cookie NF" size:self.frame.size.height / 2];
	_textLabel.shadowOffset = CGSizeMake(1, 2);
	_textLabel.shadowColor = [UIColor blackColor];
	[self addSubview:_textLabel];
}

-(void)createImageView
{
	_imageView = [[UIImageView alloc] initWithImage:nil];
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	_imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	[self addSubview:_imageView];
}

-(void)setImage:(NSString *)filename
{
	if (!_imageView) {
		[self createImageView];
	}
	[_imageView setImage:[UIImage imageNamed:filename]];
}

-(void)setText:(NSString*)text
{
	if (!_textLabel) {
		[self createTextView];
	}
	
	// do the font sizing here...
	
	_textLabel.text = text;
}

-(void)setTextColor:(UIColor*)color
{
	if (!_textLabel) {
		[self createTextView];
	}
	_textLabel.textColor = color;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
//	_textLabel.font = [UIFont fontWithName:@"Zapfino" size:frame.size.height / 3.75];
	_textLabel.font = [UIFont fontWithName:@"Fortune Cookie NF" size:frame.size.height / 2];
	_textLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	_imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	[self setNeedsDisplay];
}

-(void)buttonSelected:(id)sender;
{
	// call obj-C

	if (_onSelectTarget && _onSelectMethod) {
		[_onSelectTarget performSelector:_onSelectMethod withObject:sender];
	}
	
	// call Lua
	
	if (_onSelectLuaFunction) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig([_onSelectLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
//		[[FCLua instance].coreVM call:_onSelectLuaFunction required:YES withSig:@"s>", _managedViewName];
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	[ViewCommon_apple drawButtonStyle1:rect];	
}

@end
