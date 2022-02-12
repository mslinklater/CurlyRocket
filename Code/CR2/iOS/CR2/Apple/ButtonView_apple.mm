//
//  ButtonView.m
//  CR1
//
//  Created by Martin Linklater on 29/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import "ButtonView_apple.h"
#import "FCLua.h"

#include "Shared/Core/FCCore.h"

@implementation ButtonView_apple

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

		_topImageView = [[UIImageView alloc] initWithImage:nil];
		_topImageView.contentMode = UIViewContentModeScaleAspectFit;
		_topImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		[self addSubview:_topImageView];
	}
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:_tapRecognizer];
}

-(void)setBackgroundImage:(NSString *)filename
{
	UIImage* image = [UIImage imageNamed:filename];
	
	FC_ASSERT( image );
	
	[_backgroundImageView setImage:image];
}

-(void)setTopImage:(NSString *)filename
{
	UIImage* image = [UIImage imageNamed:filename];
	
	FC_ASSERT( image );
	
	[_topImageView setImage:image];
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_backgroundImageView.frame = CGRectMake( 0, 0, frame.size.width, frame.size.height );
	
	float xSize = frame.size.width;
	float ySize = frame.size.height;
	
	_topImageView.frame = CGRectMake( xSize * 0.15, ySize * 0.15, xSize * 0.7, ySize * 0.7 );
	[self setNeedsDisplay];
}

-(void)buttonSelected:(id)sender;
{
	// call Lua

	if (_onSelectLuaFunction && [_onSelectLuaFunction length]) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig([_onSelectLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
	}
}

@end
