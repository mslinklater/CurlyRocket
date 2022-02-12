//
//  PlayView_apple.h
//  CR2
//
//  Created by Martin Linklater on 26/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface PlayView_apple : UIView <FCManagedView_apple> {
	NSString*			_managedViewName;
	NSString*			_onTouchBeganLuaFunction;
	NSString*			_onTouchEndedLuaFunction;
	NSNumber*			_color;
	UIColor*			_realColor;
	
	// new stuff
	NSString*			_imageFilename;
	NSString*			_imagePressedFilename;
	UIImage*			_normalImage;
	UIImage*			_pressedImage;
	UIImageView*		_imageView;
	
	NSNumber*			_pressed;
	NSNumber*			_interactive;
	
	int					numCurrentTouches;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSString* onTouchBeganLuaFunction;
@property(nonatomic, strong) NSString* onTouchEndedLuaFunction;

@property(nonatomic, strong) NSString* imageFilename;
@property(nonatomic, strong) NSString* imagePressedFilename;
@property(nonatomic, strong) UIImage* normalImage;
@property(nonatomic, strong) UIImage* pressedImage;
@property(nonatomic, strong) UIImageView* imageView;

@property(nonatomic, strong) NSNumber* pressed;
@property(nonatomic, strong) NSNumber* interactive;

@property(nonatomic, strong) NSNumber* color;

@end
