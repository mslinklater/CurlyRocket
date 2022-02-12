//
//  HowToPlayPhase.cpp
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include "HowToPlayPhase.h"

HowToPlayPhase::HowToPlayPhase( std::string name )
: FCPhase( name )
{
	
}

HowToPlayPhase::~HowToPlayPhase()
{
	
}

FCPhaseUpdate HowToPlayPhase::Update( float dt )
{
	FCPhase::Update(dt);
	return kFCPhaseUpdateOK;
}

void HowToPlayPhase::WasAddedToQueue()
{
	FCPhase::WasAddedToQueue();
}

void HowToPlayPhase::WasRemovedFromQueue()
{
	FCPhase::WasRemovedFromQueue();
}

void HowToPlayPhase::WillActivate()
{
	FCPhase::WillActivate();
}

void HowToPlayPhase::WillActivatePostLua()
{
	FCPhase::WillActivatePostLua();
}

void HowToPlayPhase::IsNowActive()
{
	FCPhase::IsNowActive();
}

void HowToPlayPhase::WillDeactivate()
{
	FCPhase::WillDeactivate();
}

void HowToPlayPhase::IsNowDeactive()
{
	FCPhase::IsNowDeactive();
}

void HowToPlayPhase::IsNowDeactivePostLua()
{
	FCPhase::IsNowDeactivePostLua();
}
