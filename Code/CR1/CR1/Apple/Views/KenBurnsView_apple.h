//
//  KenBurnsView.h
//  CR1
//
//  Created by Martin Linklater on 15/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

#include "Views/KenBurnsView.h"
#include "Shared/Framework/FCApplication.h"

@interface KenBurnsView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;
	
	UIImageView*	mImageViews[2];
	int				mPrimaryImage;
	int				mSecondaryImage;
	CGRect			mParentFrame;
	UIImage*		mLastGoodImage;
}
@property(nonatomic, strong) NSString* managedViewName;

-(void)startPrimaryFrameAnimationOver:(float)secs;
-(void)setSecondaryImage:(UIImage*)image;

@end

// Proxy

class KenBurnsViewProxy : public KenBurnsView
{
public:
	KenBurnsViewProxy( std::string name, std::string parent )
	{
		m_appleName = [NSString stringWithUTF8String:name.c_str()];
		NSString* appleParent = nil;
		
		if (parent.size()) {
			appleParent = [NSString stringWithUTF8String:parent.c_str()];
		}
		
		[[FCViewManager_apple instance] createView:m_appleName asClass:@"KenBurnsView_apple" withParent:appleParent];
		
		CGRect frameRect;
//		FCVector2f size = FCApplication::Instance()->MainViewSize();
		frameRect.origin.x = frameRect.origin.y = 0.0f;
//		frameRect.size.width = size.x;
//		frameRect.size.height = size.y;		
		frameRect.size.width = frameRect.size.height = 1.0f;
		[[FCViewManager_apple instance] setView:m_appleName frame:frameRect over:0.0f];

		m_view = (KenBurnsView_apple*)[[FCViewManager_apple instance] viewNamed:m_appleName];
	}
	
	virtual ~KenBurnsViewProxy()
	{
		[[FCViewManager_apple instance] destroyView:m_appleName];
		m_view = nil;
	}
	
	void StartPrimaryFrameAnimation( float seconds )
	{
		[m_view startPrimaryFrameAnimationOver:seconds];
	}
	
	virtual void SetSecondaryImage( std::string filename )
	{
		UIImage* image = [UIImage imageNamed:[NSString stringWithUTF8String:filename.c_str()]];
		
		[m_view setSecondaryImage:image];
		
		// pass on to Cocoa
	}

private:
	KenBurnsView_apple*	m_view;
	NSString* m_appleName;
};





