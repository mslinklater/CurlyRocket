//
//  GameLabelView_apple.h
//  CR3
//
//  Created by Martin Linklater on 29/11/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface GameLabelView_apple : UIView <FCManagedView_apple> {
	NSString*		_managedViewName;
	UILabel*		mLabel;
	NSString*		mFontName;
}
@property(nonatomic, strong) NSString* managedViewName;

-(void)setFontName:(NSString*)fontName;
-(void)setFontSize:(float)size;
-(void)setTextColor:(UIColor*)color;
-(void)setText:(NSString*)text;
-(void)setTextAlignment:(int)alignment;

@end
