//
//  TimerView.h
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

#include "Views/TimerView.h"

@interface TimerView_apple : UIView <FCManagedView_apple> 
{
	NSString* _managedViewName;
	float _totalTime;
	float _timeRemaining;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic) float totalTime;
@property(nonatomic) float timeRemaining;

-(void)update:(float)dt;

@end

//--------------------------

class TimerViewProxy : public TimerView
{
public:
	TimerViewProxy( std::string name, std::string parent )
	{
		m_appleName = [NSString stringWithUTF8String:name.c_str()];
		NSString* appleParent = nil;
		
		if (parent.size()) {
			appleParent = [NSString stringWithUTF8String:parent.c_str()];
		}
		
		[[FCViewManager_apple instance] createView:m_appleName asClass:@"TimerView_apple" withParent:appleParent];
		
		m_timerView = (TimerView_apple*)[[FCViewManager_apple instance] viewNamed:m_appleName];
	}
	
	virtual ~TimerViewProxy()
	{
		[[FCViewManager_apple instance] destroyView:m_appleName];
		m_timerView = nil;
	}
	
	virtual void SetTotal( float time )
	{
		TimerView::SetTotal( time );
		m_timerView.totalTime = time;
	}
	
	virtual void SetRemaining( float time )
	{
		TimerView::SetRemaining( time );
		m_timerView.timeRemaining = time;
	}
	
	TimerView_apple*	m_timerView;
	NSString*			m_appleName;
};
