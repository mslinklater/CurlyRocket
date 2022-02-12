//
//  SliderView.h
//  CR1
//
//  Created by Martin Linklater on 30/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface SliderView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;
	
	NSNumber* _minLimit;
	NSNumber* _maxLimit;
	NSNumber* _currentValue;
	NSString* _persistentDataName;
	UITapGestureRecognizer* _leftTapRecognizer;
	UITapGestureRecognizer* _rightTapRecognizer;
	NSString* _decLuaCallback;
	NSString* _incLuaCallback;
	
	UIView*	mLeftButton;
	UIView* mRightButton;
	UIView* mSliderView;
	UIView* mBackground;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSNumber* minLimit;
@property(nonatomic, strong) NSNumber* maxLimit;
@property(nonatomic, strong) NSNumber* currentValue;
@property(nonatomic, strong) NSString* persistentDataName;
@property(nonatomic, strong) UITapGestureRecognizer* leftTapRecognizer;
@property(nonatomic, strong) UITapGestureRecognizer* rightTapRecognizer;
@property(nonatomic, strong) NSString* incLuaCallback;
@property(nonatomic, strong) NSString* decLuaCallback;

-(void)incPressed:(id)sender;
-(void)decPressed:(id)sender;

@end
