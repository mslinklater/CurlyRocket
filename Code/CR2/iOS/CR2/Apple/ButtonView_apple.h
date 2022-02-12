//
//  ButtonView.h
//  CR1
//
//  Created by Martin Linklater on 29/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface ButtonView_apple : UIView <FCManagedView_apple> {
	UITapGestureRecognizer*	_tapRecognizer;
	NSString*			_managedViewName;
	NSString*			_onSelectLuaFunction;
	
	UIImageView*		_backgroundImageView;
	UIImageView*		_topImageView;
}
@property(nonatomic, strong) UITapGestureRecognizer* tapRecognizer;
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSString* onSelectLuaFunction;

@property(nonatomic, strong) UIImageView* backgroundImageView;
@property(nonatomic, strong) UIImageView* topImageView;

-(void)setBackgroundImage:(NSString*)filename;
-(void)setTopImage:(NSString*)filename;

-(void)buttonSelected:(id)sender;
@end
