//
//  CurlyRocketPhase.cpp
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include "CurlyRocketPhase.h"

CurlyRocketPhase::CurlyRocketPhase( std::string name )
: FCPhase( name )
{
	
}

CurlyRocketPhase::~CurlyRocketPhase()
{
	
}

FCPhaseUpdate CurlyRocketPhase::Update( float dt )
{
	FCPhase::Update(dt);
	return kFCPhaseUpdateOK;
}

void CurlyRocketPhase::WasAddedToQueue()
{
	FCPhase::WasAddedToQueue();
}

void CurlyRocketPhase::WasRemovedFromQueue()
{
	FCPhase::WasRemovedFromQueue();
}

void CurlyRocketPhase::WillActivate()
{
	FCPhase::WillActivate();
}

void CurlyRocketPhase::WillActivatePostLua()
{
	FCPhase::WillActivatePostLua();
}

void CurlyRocketPhase::IsNowActive()
{
	FCPhase::IsNowActive();
}

void CurlyRocketPhase::WillDeactivate()
{
	FCPhase::WillDeactivate();
}

void CurlyRocketPhase::IsNowDeactive()
{
	FCPhase::IsNowDeactive();
}

void CurlyRocketPhase::IsNowDeactivePostLua()
{
	FCPhase::IsNowDeactivePostLua();
}
