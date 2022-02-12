//
//  GameAppDelegate.cpp
//  CR1
//
//  Created by Martin Linklater on 21/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#include "GameAppDelegate.h"
#include "Shared/Lua/FCLua.h"

#include "Shared/Framework/Actor/FCActorSystem.h"
#include "Actors/WorldActor.h"
#include "Actors/BallActor.h"
#include "Actors/GemActor.h"
#include "Actors/BombActor.h"
#include "Actors/RackActor.h"
#include "Shared/Framework/Ads/FCAds.h"

static GameAppDelegate* s_pInstance = 0;

static int lua_ShowAdBanner( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(0);
	s_pInstance->ShowAdBanner();
	return 0;
}

static int lua_HideAdBanner( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(0);
	s_pInstance->HideAdBanner();
	return 0;
}

GameAppDelegate::GameAppDelegate()
{
	s_pInstance = this;
	FCLua::Instance()->CoreVM()->CreateGlobalTable("GameAppDelegate");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_ShowAdBanner, "GameAppDelegate.ShowAdBanner");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_HideAdBanner, "GameAppDelegate.HideAdBanner");
}

GameAppDelegate::~GameAppDelegate()
{
	FC_HALT;
}

void GameAppDelegate::RegisterPhasesWithManager( FCPhaseManager* pPhaseManager )
{
	m_frontEndPhase = FrontEndPhaseRef( new FrontEndPhase("FrontEnd") );
	pPhaseManager->AttachPhase( m_frontEndPhase );
	
	m_gamePhase = GamePhaseRef( new GamePhase( "Game" ));
	pPhaseManager->AttachPhase( m_gamePhase );
}

void GameAppDelegate::InitializeSystems()
{
	FCActorSystem::Instance()->AddActorCreateFunction("WorldActor", WorldActor::Create );
	FCActorSystem::Instance()->AddActorCreateFunction("BallActor", BallActor::Create );
	FCActorSystem::Instance()->AddActorCreateFunction("GemActor", GemActor::Create );
	FCActorSystem::Instance()->AddActorCreateFunction("BombActor", BombActor::Create );
	FCActorSystem::Instance()->AddActorCreateFunction("RackActor", RackActor::Create );
	m_screenFXManager = ScreenFXManagerRef( new ScreenFXManager );
}

void GameAppDelegate::Update( float realTime, float gameTime )
{
	m_screenFXManager->Update( realTime );
}

void GameAppDelegate::ShowAdBanner()
{
	FCAds::ShowBanner( "41f0dcd05c7a4b11b6759c5eb69c52bb" );
}

void GameAppDelegate::HideAdBanner()
{
	FCAds::HideBanner();
}


