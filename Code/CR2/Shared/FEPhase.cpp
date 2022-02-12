//
//  FEPhase.cpp
//  CR2
//
//  Created by Martin Linklater on 20/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include "FEPhase.h"

FEPhase::FEPhase( std::string name )
: FCPhase( name )
{
	
}

FEPhase::~FEPhase()
{
	
}

FCPhaseUpdate FEPhase::Update( float dt )
{
	FCPhase::Update(dt);
	return kFCPhaseUpdateOK;
}

void FEPhase::WasAddedToQueue()
{
	FCPhase::WasAddedToQueue();
}

void FEPhase::WasRemovedFromQueue()
{
	FCPhase::WasRemovedFromQueue();
}

void FEPhase::WillActivate()
{
	FCPhase::WillActivate();
}

void FEPhase::WillActivatePostLua()
{
	FCPhase::WillActivatePostLua();
}

void FEPhase::IsNowActive()
{
	FCPhase::IsNowActive();
}

void FEPhase::WillDeactivate()
{
	FCPhase::WillDeactivate();
}

void FEPhase::IsNowDeactive()
{
	FCPhase::IsNowDeactive();
}

void FEPhase::IsNowDeactivePostLua()
{
	FCPhase::IsNowDeactivePostLua();
}
