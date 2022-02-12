//
//  GamePhase.cpp
//  CR2
//
//  Created by Martin Linklater on 20/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include "GamePhase.h"

GamePhase::GamePhase( std::string name )
: FCPhase( name )
{
	
}

GamePhase::~GamePhase()
{
	
}

FCPhaseUpdate GamePhase::Update( float dt )
{
	FCPhase::Update(dt);
	return kFCPhaseUpdateOK;
}

void GamePhase::WasAddedToQueue()
{
	FCPhase::WasAddedToQueue();
}

void GamePhase::WasRemovedFromQueue()
{
	FCPhase::WasRemovedFromQueue();
}

void GamePhase::WillActivate()
{
	FCPhase::WillActivate();
}

void GamePhase::WillActivatePostLua()
{
	FCPhase::WillActivatePostLua();
}

void GamePhase::IsNowActive()
{
	FCPhase::IsNowActive();
}

void GamePhase::WillDeactivate()
{
	FCPhase::WillDeactivate();
}

void GamePhase::IsNowDeactive()
{
	FCPhase::IsNowDeactive();
}

void GamePhase::IsNowDeactivePostLua()
{
	FCPhase::IsNowDeactivePostLua();
}
