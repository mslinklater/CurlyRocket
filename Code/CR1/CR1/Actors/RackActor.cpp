//
//  RackActor.cpp
//  CR1
//
//  Created by Martin Linklater on 31/05/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#include "RackActor.h"

FCActorRef RackActor::Create()
{
	return FCActorRef( new RackActor );
}

bool RackActor::NeedsUpdate()
{
	return true;
}

void RackActor::Update(float realTime, float gameTime)
{
	FCActor::Update( realTime, gameTime );
}

void RackActor::Clear()
{
	
}

void RackActor::FillWithColors(FCStringVector colors)
{
	m_colors = colors;
	m_currentIndex = 0;
	
	// redisplay
}

std::string	RackActor::GetCurrentColor()
{
	if (m_colors.size()) {
		return m_colors[ m_currentIndex ];
	}
	
	return "";
}

bool RackActor::RemoveCurrent()
{
	FC_ASSERT(m_currentIndex < m_colors.size());
	
	m_currentIndex++;
	
//	[self setNeedsDisplay];	FIX
	
	if (m_currentIndex == m_colors.size()) 
	{
		return true;
	}
	
	return false;
}

