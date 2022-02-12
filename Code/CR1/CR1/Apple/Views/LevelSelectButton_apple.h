//
//  LevelSelectButton.h
//  CR1
//
//  Created by Martin Linklater on 05/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "FCViewManager_apple.h"

@interface LevelSelectButton_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;
	UITapGestureRecognizer*	_tapRecognizer;
	UISwipeGestureRecognizer* _swipeLeftRecognizer;
	UISwipeGestureRecognizer* _swipeRightRecognizer;
	UILabel*			_textLabel;
	
	NSString*			_onSelectLuaFunction;
	__weak id			_onSelectTarget;
	SEL					_onSelectMethod;
	
	NSString*			_onLeftSwipeLuaFunction;
	NSString*			_onRightSwipeLuaFunction;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) UITapGestureRecognizer* tapRecognizer;
@property(nonatomic, strong) UISwipeGestureRecognizer* swipeLeftRecognizer;
@property(nonatomic, strong) UISwipeGestureRecognizer* swipeRightRecognizer;
@property(nonatomic, strong) UILabel* textLabel;
@property(nonatomic, strong) NSString* onSelectLuaFunction;
@property(nonatomic, weak) id onSelectTarget;
@property(nonatomic) SEL onSelectMethod;

@property(nonatomic, strong) NSString* onLeftSwipeLuaFunction;
@property(nonatomic, strong) NSString* onRightSwipeLuaFunction;

-(void)buttonSelected:(UITapGestureRecognizer*)sender;
-(void)buttonSwiped:(UISwipeGestureRecognizer*)sender;

-(void)setText:(NSString*)text;
-(void)setTextColor:(UIColor*)color;

@end
