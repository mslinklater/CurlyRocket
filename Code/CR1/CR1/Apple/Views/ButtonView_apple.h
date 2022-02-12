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
	UILabel*			_textLabel;
	NSString*			_managedViewName;
	NSString*			_onSelectLuaFunction;
	__weak id			_onSelectTarget;
	SEL					_onSelectMethod;
	__weak id			_customDrawTarget;
	SEL					_customDrawMethod;
	UIImageView*			_imageView;
}
@property(nonatomic, strong) UITapGestureRecognizer* tapRecognizer;
@property(nonatomic, strong) UILabel* textLabel;
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSString* onSelectLuaFunction;
@property(nonatomic, weak) id onSelectTarget;
@property(nonatomic) SEL onSelectMethod;
@property(nonatomic, weak) id customDrawTarget;
@property(nonatomic) SEL customDrawMethod;
@property(nonatomic, strong) UIImageView* imageView;

-(void)setImage:(NSString*)filename;
-(void)setText:(NSString*)text;
-(void)setTextColor:(UIColor*)color;
-(void)buttonSelected:(id)sender;

-(void)createTextView;
-(void)createImageView;
@end
