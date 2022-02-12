//
//  LevelSelectButton.m
//  CR1
//
//  Created by Martin Linklater on 05/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "LevelSelectButton_apple.h"
#import "ViewCommon_apple.h"

#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"

@implementation LevelSelectButton_apple

@synthesize managedViewName = _managedViewName;
@synthesize tapRecognizer = _tapRecognizer;
@synthesize swipeLeftRecognizer = _swipeLeftRecognizer;
@synthesize swipeRightRecognizer = _swipeRightRecognizer;
@synthesize textLabel = _textLabel;
@synthesize onSelectLuaFunction = _onSelectLuaFunction;
@synthesize onSelectTarget = _onSelectTarget;
@synthesize onSelectMethod = _onSelectMethod;

@synthesize onLeftSwipeLuaFunction = _onLeftSwipeLuaFunction;
@synthesize onRightSwipeLuaFunction = _onRightSwipeLuaFunction;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSelected:)];
		[self addGestureRecognizer:_tapRecognizer];
		
		_swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSwiped:)];
		_swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		[self addGestureRecognizer:_swipeLeftRecognizer];
		
		_swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonSwiped:)];
		_swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
		[self addGestureRecognizer:_swipeRightRecognizer];
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_textLabel];
		
		self.backgroundColor = [UIColor clearColor];
	}
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:_tapRecognizer];
	[self removeGestureRecognizer:_swipeLeftRecognizer];
	[self removeGestureRecognizer:_swipeRightRecognizer];
}

-(void)setText:(NSString*)text
{
	_textLabel.text = text;
}

-(void)setTextColor:(UIColor*)color
{
	_textLabel.textColor = color;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_textLabel.font = [UIFont fontWithName:@"Fortune Cookie NF" size:frame.size.height / 2];
	_textLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	[self setNeedsDisplay];
}

-(void)buttonSwiped:(UISwipeGestureRecognizer*)sender
{
	switch (sender.direction) {
		case UISwipeGestureRecognizerDirectionLeft:
			if (_onLeftSwipeLuaFunction) {
				FCLua::Instance()->CoreVM()->CallFuncWithSig([_onLeftSwipeLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
			}
			break;
		case UISwipeGestureRecognizerDirectionRight:
			if (_onRightSwipeLuaFunction) {
				FCLua::Instance()->CoreVM()->CallFuncWithSig([_onRightSwipeLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
			}
			break;			
		default:
			break;
	}
}

-(void)buttonSelected:(UITapGestureRecognizer*)sender
{
	// call obj-C
	
	if (_onSelectTarget && _onSelectMethod) {
		[_onSelectTarget performSelector:_onSelectMethod withObject:sender];
	}
	
	// call Lua
	
	if (_onSelectLuaFunction) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig([_onSelectLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
	}
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	[ViewCommon_apple drawButtonStyle1:rect];
}

@end
