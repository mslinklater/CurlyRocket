//
//  GameAppDelegate.cpp
//  CR2
//
//  Created by Martin Linklater on 20/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include "Shared/Core/FCCore.h"

#include "GameAppDelegate.h"
#include "Shared/Framework/Ads/FCAds.h"
#include "Shared/Framework/Phase/FCPhaseManager.h"

static GameAppDelegate* s_pInstance = 0;

//--------------------------------------------------------------------------------------------------

static int lua_ShowAdBanner( lua_State* _state )
{
	FC_TRACE;
	FC_LUA_ASSERT_NUMPARAMS(0);
	s_pInstance->ShowAdBanner();
	return 0;
}

static int lua_GameType( lua_State* _state )
{
	FC_TRACE;
	FC_LUA_ASSERT_NUMPARAMS(0);
	lua_pushinteger( _state, s_pInstance->GameType() );
	return 1;
}

static int lua_SetGameType( lua_State* _state )
{
	FC_TRACE;
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	
	s_pInstance->SetGameType( (eGameType)lua_tointeger(_state, 1) );
	return 0;
}

//--------------------------------------------------------------------------------------------------

GameAppDelegate::GameAppDelegate()
{
	FC_TRACE;
	
	s_pInstance = this;
}

GameAppDelegate::~GameAppDelegate()
{
	FC_TRACE;
	
}

void GameAppDelegate::RegisterPhasesWithManager( FCPhaseManager* pPhaseManager )
{
	FC_TRACE;
	m_frontEndPhase = FCPhaseRef( new FEPhase("FrontEnd") );
	pPhaseManager->AttachPhase( m_frontEndPhase );
	
	m_gamePhase = FCPhaseRef( new GamePhase( "Game" ));
	pPhaseManager->AttachPhase( m_gamePhase );
}

void GameAppDelegate::InitializeSystems()
{
	FC_TRACE;
	FCLua::Instance()->CoreVM()->CreateGlobalTable("GameAppDelegate");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_ShowAdBanner, "GameAppDelegate.ShowAdBanner");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_GameType, "GameAppDelegate.GameType");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetGameType, "GameAppDelegate.SetGameType");
}

void GameAppDelegate::Update( float realTime, float gameTime )
{
	FC_TRACE;
}

void GameAppDelegate::ShowAdBanner()
{
	FC_TRACE;
	FCAds::ShowBanner("192e6f539c6b4e5fa9e9a277e66bda59");
}

