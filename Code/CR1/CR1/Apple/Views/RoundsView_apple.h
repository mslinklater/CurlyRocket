//
//  RoundsView.h
//  CR1
//
//  Created by Martin Linklater on 16/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

#include "Shared/Core/FCCore.h"
#include "Views/RoundsView.h"

@interface RoundsView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;
	int	_numRounds;
	int _currentRound;
	UILabel* _labelView;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic) int numRounds;
@property(nonatomic) int currentRound;
@property(nonatomic, strong) UILabel* labelView;

-(void)refreshView;
-(void)update:(float)dt;

@end

//---------------------------------------

class RoundsViewProxy : public RoundsView
{
public:
	RoundsViewProxy( std::string name, std::string parent )
	{
		m_appleName = [NSString stringWithUTF8String:name.c_str()];
		NSString* appleParent = nil;
		
		if (parent.size()) {
			appleParent = [NSString stringWithUTF8String:parent.c_str()];
		}
		
		[[FCViewManager_apple instance] createView:m_appleName asClass:@"RoundsView_apple" withParent:appleParent];
		
		m_roundsView = (RoundsView_apple*)[[FCViewManager_apple instance] viewNamed:m_appleName];

	}
	virtual ~RoundsViewProxy()
	{
		[[FCViewManager_apple instance] destroyView:m_appleName];
		m_roundsView = nil;
	}
	
	virtual void SetNumRounds( uint16_t num )
	{
		RoundsView::SetNumRounds( num );
		m_roundsView.numRounds = num;
	}
	
	virtual void SetCurrentRound( uint16_t num )
	{
		RoundsView::SetCurrentRound( num );
		m_roundsView.currentRound = num;
	}
	
	NSString*			m_appleName;
	RoundsView_apple*	m_roundsView;
};
