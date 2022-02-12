//
//  RackView.h
//  CR1
//
//  Created by Martin Linklater on 31/05/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_RackView_h
#define CR1_RackView_h

#include "Shared/Core/FCCore.h"

class RackView
{
public:
	RackView()
	: m_currentIndex(0)
	{}
	
	virtual ~RackView(){}
	
	virtual void Clear(){}
	virtual void FillWithColors( const FCStringVector& colors )
	{
		m_currentColors = colors;
		m_currentIndex = 0;
	}
	std::string GetCurrentColor( )
	{ 
		if( !m_currentColors.size() )
			return kFCKeyNull;
		
		return m_currentColors[m_currentIndex]; 
	}
	virtual bool RemoveCurrent()
	{ 
		m_currentIndex++;
		if (m_currentIndex == m_currentColors.size()) {
			return true;
		}
		return false; 
	}
	
protected:
	uint8_t	m_currentIndex;
	FCStringVector m_currentColors;
};

typedef std::shared_ptr<RackView> RackViewRef;

extern RackViewRef plt_RackView_Create( std::string name, std::string parent );

#endif
