//
//  TopFXView.h
//  CR1
//
//  Created by Martin Linklater on 19/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

#include "Views/TopFXView.h"

@interface TopFXView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;
	UIImage* _vignetteImage;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) UIImage* vignetteImage;

-(void)update:(float)dt;
@end



class TopFXViewProxy : public TopFXView
{
public:
	TopFXViewProxy( std::string name, std::string parent )
	{
		m_appleName = [NSString stringWithUTF8String:name.c_str()];
		NSString* appleParent = nil;
		
		if (parent.size()) {
			appleParent = [NSString stringWithUTF8String:parent.c_str()];
		}
		
		[[FCViewManager_apple instance] createView:m_appleName asClass:@"TopFXView_apple" withParent:appleParent];
		
		m_view = (TopFXView_apple*)[[FCViewManager_apple instance] viewNamed:m_appleName];
	}
	virtual ~TopFXViewProxy()
	{
		[[FCViewManager_apple instance] destroyView:m_appleName];
		m_view = nil;
	}
	
private:
	TopFXView_apple*	m_view;
	NSString*			m_appleName;
};
