//
//  FrontEndPhase.m
//  CR1
//
//  Created by Martin Linklater on 15/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#include "FrontEndPhase.h"
#include "Shared/Framework/UI/FCViewManager.h"

static FrontEndPhaseRef s_pInstance;

FrontEndPhase::FrontEndPhase( std::string name )
: FCPhase( name )
{
	s_pInstance = FrontEndPhaseRef( this );
}

FCPhaseUpdate FrontEndPhase::Update(float dt)
{
	FCPhase::Update(dt);
	
	return kFCPhaseUpdateOK;
}

void FrontEndPhase::WasAddedToQueue()
{
	FCPhase::WasAddedToQueue();
}

void FrontEndPhase::WasRemovedFromQueue()
{
	FCPhase::WasRemovedFromQueue();
}

void FrontEndPhase::WillActivate()
{
	FCPhase::WillActivate();
	m_activateTimer = 0.0f;
	return;
}

void FrontEndPhase::WillActivatePostLua()
{
	FCPhase::WillActivatePostLua();
	
	FCViewManager* vm = FCViewManager::Instance();
	
	vm->SendViewToFront("webView");	
	
	if (vm->ViewExists("topfx")) {
		vm->SendViewToFront("topfx");			
	}
	
	if (vm->ViewExists("adbanner")) {
		vm->SendViewToFront("adbanner");	
	}
}

void FrontEndPhase::IsNowActive()
{
	FCPhase::IsNowActive();
}

void FrontEndPhase::WillDeactivate()
{
	FCPhase::WillDeactivate();
	m_deactivateTimer = 1.0f;
	return;
}

void FrontEndPhase::IsNowDeactive()
{
	FCPhase::IsNowDeactive();
}

void FrontEndPhase::IsNowDeactivePostLua()
{
	FCPhase::IsNowDeactivePostLua();
}
