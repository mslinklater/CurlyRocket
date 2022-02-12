//
//  WebView.h
//  CR1
//
//  Created by Martin Linklater on 09/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface GameWebView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;
	UIWebView* _webView;
	UIButton* _returnButton;
	NSString*			_onSelectLuaFunction;

	float _bottomBorder;
	float _topBorder;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) UIWebView* webView;
@property(nonatomic, strong) UIButton* returnButton;
@property(nonatomic, strong) NSString* onSelectLuaFunction;
@property(nonatomic) float bottomBorder;
@property(nonatomic) float topBorder;

-(void)returnPressed:(id)sender;
-(void)setURL:(NSString*)url;

@end
