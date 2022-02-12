//
//  WebView.m
//  CR1
//
//  Created by Martin Linklater on 09/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameWebView_apple.h"

#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"

@implementation GameWebView_apple
@synthesize webView = _webView;
@synthesize returnButton = _returnButton;
@synthesize onSelectLuaFunction = _onSelectLuaFunction;
@synthesize bottomBorder = _bottomBorder;
@synthesize topBorder = _topBorder;
@synthesize managedViewName = _managedViewName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.backgroundColor = [UIColor blackColor];

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
		{
			_bottomBorder = 30;
			_topBorder = 80;
		} 
		else
		{
			_bottomBorder = 20;
			_topBorder = 50;			
		}
		
		CGRect frameSize = CGRectMake(0, _topBorder, frame.size.width, frame.size.height - _topBorder - _bottomBorder);
		
		frameSize.size.width = FCMax<float>(frameSize.size.width, 0.0);
		frameSize.size.height = FCMax<float>(frameSize.size.height, 0.0);
		
		_webView = [[UIWebView alloc] initWithFrame:frameSize];
		[self addSubview:_webView];
		
		_returnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_returnButton.frame = CGRectMake(0, 0, 100, _topBorder);
		[_returnButton setTitle:@"Return" forState:UIControlStateNormal];
		[_returnButton addTarget:self action:@selector(returnPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_returnButton];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_webView.frame = CGRectMake(0, _topBorder, frame.size.width, frame.size.height - _topBorder - _bottomBorder);
	_returnButton.frame = CGRectMake(0, 0, 100, _topBorder);
}

-(void)setURL:(NSString*)url
{
	NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[_webView loadRequest:urlRequest];
}

-(void)returnPressed:(id)sender
{
	if (_onSelectLuaFunction) {
//		[[FCLua instance].coreVM call:_onSelectLuaFunction required:YES withSig:@"s>", _managedViewName];
		FCLua::Instance()->CoreVM()->CallFuncWithSig([_onSelectLuaFunction UTF8String], true, "s>", [_managedViewName UTF8String]);
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
