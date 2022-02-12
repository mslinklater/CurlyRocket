//
//  TestView.m
//  CR3
//
//  Created by Martin Linklater on 06/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "TestView_apple.h"

#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"

@implementation TestView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.clipsToBounds = YES;
        // Initialization code
#if defined( FC_DEBUG )
		self.backgroundColor = [UIColor grayColor];
#endif
		
		mTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		mTextLabel.backgroundColor = [UIColor clearColor];
		mTextLabel.textAlignment = NSTextAlignmentCenter;
		mTextLabel.textColor = [UIColor whiteColor];
		mTextLabel.shadowColor = [UIColor blackColor];
		mTextLabel.shadowOffset = CGSizeMake(1, 1);
		[self addSubview:mTextLabel];
    }
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:mTapRecognizer];
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	mTextLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

-(void)setText:(NSString *)text
{
	mTextLabel.text = text;
}

-(void)setTapFunction:(NSString *)tapFunction
{
	if(_tapFunction == nil)
	{
		mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponder:)];
		[self addGestureRecognizer:mTapRecognizer];
	}
	
	_tapFunction = tapFunction;
}

-(void)tapResponder:(id)sender
{
	if ([_tapFunction length]) {
		// call Lua function with tapFunction name

		FCLua::Instance()->CoreVM()->CallFuncWithSig([_tapFunction UTF8String], true, "");
	}
}

@end
