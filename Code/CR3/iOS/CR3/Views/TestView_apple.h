//
//  TestView.h
//  CR3
//
//  Created by Martin Linklater on 06/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface TestView_apple : UIView <FCManagedView_apple> {
	// properties
	NSString*	_managedViewname;
	
	NSString*	_text;
	NSString*	_tapFunction;
	
	// non-properties
	
	UILabel*				mTextLabel;
	UITapGestureRecognizer*	mTapRecognizer;
}
@property(nonatomic, strong) NSString* managedViewName;

@property(nonatomic, strong) NSString* text;
@property(nonatomic, strong) NSString* tapFunction;

-(void)tapResponder:(id)sender;
@end
