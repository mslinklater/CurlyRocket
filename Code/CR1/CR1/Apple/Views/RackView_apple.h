//
//  RackView.h
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

#include "Views/RackView.h"

@interface RackView_apple : UIView <FCManagedView_apple> {
	NSString*		_managedViewName;
	NSArray*		_currentRack;
	uint8_t			_currentIndex;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSArray* currentRack;
@property(nonatomic) uint8_t currentIndex;

-(void)update:(float)dt;

-(void)clear;
-(void)fillWithColors:(NSArray*)colors;

@end

//---------------------------------------

class RackViewProxy : public RackView
{
public:
	RackViewProxy( std::string name, std::string parent )
	{
		m_appleName = [NSString stringWithUTF8String:name.c_str()];
		NSString* appleParent = nil;
		
		if (parent.size()) {
			appleParent = [NSString stringWithUTF8String:parent.c_str()];
		}

		[[FCViewManager_apple instance] createView:m_appleName asClass:@"RackView_apple" withParent:appleParent];
		
		m_rackView = (RackView_apple*)[[FCViewManager_apple instance] viewNamed:m_appleName];
	}
	
	virtual ~RackViewProxy()
	{
		[[FCViewManager_apple instance] destroyView:m_appleName];
		m_rackView = nil;
	}
	
	virtual void FillWithColors( const FCStringVector& colors )
	{
		RackView::FillWithColors( colors );
		
		NSMutableArray* array = [NSMutableArray array];
		for (uint64_t i = 0; i < m_currentColors.size(); i++) {
			[array addObject:[NSString stringWithUTF8String:m_currentColors[i].c_str()]];
		}
		[m_rackView fillWithColors:array];
	}

	virtual bool RemoveCurrent()
	{
		bool ret = RackView::RemoveCurrent();
		m_rackView.currentIndex = m_currentIndex;
		return ret;
	}
	
	void Clear()
	{
		RackView::Clear();
		[m_rackView clear];
	}
	
	RackView_apple*	m_rackView;
	NSString*		m_appleName;
};

