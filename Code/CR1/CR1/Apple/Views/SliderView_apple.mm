//
//  SliderView.m
//  CR1
//
//  Created by Martin Linklater on 30/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import "SliderView_apple.h"
//#import "FCPersistentData_old.h"

#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"
#include "Shared/Framework/FCPersistentData.h"

@implementation SliderView_apple

@synthesize managedViewName = _managedViewName;
@synthesize minLimit = _minLimit;
@synthesize maxLimit = _maxLimit;
@synthesize currentValue = _currentValue;
@synthesize persistentDataName = _persistentDataName;
@synthesize leftTapRecognizer = _leftTapRecognizer;
@synthesize rightTapRecognizer = _rightTapRecognizer;
@synthesize decLuaCallback = _decLuaCallback;
@synthesize incLuaCallback = _incLuaCallback;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		// setup non-property stuff
		
		mLeftButton = [[UIView alloc] initWithFrame:frame];
		mRightButton = [[UIView alloc] initWithFrame:frame];
		mSliderView = [[UIView alloc] initWithFrame:frame];
		mBackground = [[UIView alloc] initWithFrame:frame];
		
		[self addSubview:mBackground];
		mBackground.backgroundColor = [UIColor yellowColor];
		[self addSubview:mLeftButton];
		mLeftButton.backgroundColor = [UIColor redColor];
		[self addSubview:mRightButton];
		mRightButton.backgroundColor = [UIColor blueColor];
		[self addSubview:mSliderView];
		mSliderView.backgroundColor = [UIColor greenColor];
		
		_leftTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(decPressed:)];
		[mLeftButton addGestureRecognizer:_leftTapRecognizer];

		_rightTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(incPressed:)];
		[mRightButton addGestureRecognizer:_rightTapRecognizer];
	}
    return self;
}

-(void)dealloc
{
}

-(void)setPersistentDataName:(NSString *)persistentDataName
{
	// read from persistent store and set current value
	
	_persistentDataName = persistentDataName;
//	_currentValue = [[FCPersistentData_old instance] objectForKey:_persistentDataName];	

	int32_t val = FCPersistentData::Instance()->IntForKey([_persistentDataName UTF8String]);
	
//	if (!_currentValue) {
		self.currentValue = [NSNumber numberWithInt:val];
//	}
}

-(void)setCurrentValue:(NSNumber*)currentValue
{
	_currentValue = currentValue;
	
	if (_persistentDataName) {
//		[[FCPersistentData_old instance] addObject:_currentValue forKey:_persistentDataName];
		FCPersistentData::Instance()->AddIntForKey([_currentValue intValue], [_persistentDataName UTF8String]);
	}
}

-(void)incPressed:(id)sender
{
	if ([_currentValue compare:_maxLimit] == NSOrderedAscending) 
	{
		self.currentValue = [NSNumber numberWithInt:[_currentValue intValue] + 1];
		[self setNeedsLayout];
		if (_incLuaCallback) {
//			[[FCLua instance].coreVM call:_incLuaCallback required:NO withSig:@">"];
			FCLua::Instance()->CoreVM()->CallFuncWithSig([_incLuaCallback UTF8String], false, ">");
		}
	}
}

-(void)decPressed:(id)sender
{
	if ([_currentValue compare:_minLimit] == NSOrderedDescending) 
	{
		self.currentValue = [NSNumber numberWithInt:[_currentValue intValue] - 1];
		[self setNeedsLayout];
		if (_decLuaCallback) {
//			[[FCLua instance].coreVM call:_decLuaCallback required:NO withSig:@">"];
			FCLua::Instance()->CoreVM()->CallFuncWithSig([_decLuaCallback UTF8String], false, ">");
		}
	}
}

-(void)layoutSubviews
{
	CGRect frame = self.frame;
	mLeftButton.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
	mRightButton.frame = CGRectMake(frame.size.width - frame.size.height, 0, frame.size.height, frame.size.height);
	mBackground.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	
	int numIncrements = [_maxLimit intValue] - [_minLimit intValue];
	
	float sliderWidth = (frame.size.width - ( frame.size.height * 2 )) / (numIncrements + 1);
	mSliderView.frame = CGRectMake(frame.size.height + ([_currentValue intValue] * sliderWidth), 0, 
								   sliderWidth, frame.size.height);
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
}

@end
