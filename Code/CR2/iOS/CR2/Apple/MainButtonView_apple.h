//
//  MainButtonView_apple.h
//  CR2
//
//  Created by Martin Linklater on 03/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface MainButtonView_apple : UIView <FCManagedView_apple> {
	UITapGestureRecognizer*	_tapRecognizer;
	UIView*				_textClipView;
	UILabel*			_textLabel;
	NSString*			_managedViewName;
	NSString*			_onSelectLuaFunction;
	
	UIImageView*		_topImageView;
	UIImageView*		_backgroundImageView;
}
@property(nonatomic, strong) UITapGestureRecognizer* tapRecognizer;
@property(nonatomic, strong) UIView* textClipView;
@property(nonatomic, strong) UILabel* textLabel;
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSString* onSelectLuaFunction;

@property(nonatomic, strong) UIImageView* topImageView;
@property(nonatomic, strong) UIImageView* backgroundImageView;

-(void)setTopImageFilename:(NSString*)filename;
-(void)setBackgroundImageFilename:(NSString*)filename;

-(void)setText:(NSString*)text;
-(void)setTextColor:(UIColor*)color;
-(void)buttonSelected:(id)sender;

@end
