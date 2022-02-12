//
//  GameAppDelegate.cpp
//  CR3
//
//  Created by Martin Linklater on 04/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"
#include "GameAppDelegate.h"
#include "Shared/Framework/Phase/FCPhaseManager.h"
#include "Shared/Framework/Store/FCStore.h"
#include "PlatformGameInterface.h"

static GameAppDelegate* s_pInstance = 0;

static int lua_SetImageForTile( lua_State* _state )
{
	FC_LUA_FUNCDEF("GameAppDelegate.SetImageForTile()");
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);

	plt_FullBoard_SetImageForTile(lua_tostring(_state, 1), (eDisplayTile)lua_tointeger(_state, 2));
	plt_ScrollingBoard_SetImageForTile(lua_tostring(_state, 1), (eDisplayTile)lua_tointeger(_state, 2));
	return 0;
}

static int lua_GetStoreItemDetails( lua_State* _state )
{
	FC_LUA_FUNCDEF("GameAppDelegate.GetStoreItemDetails()");
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	FC_LUA_ASSERT_TYPE(2, LUA_TSTRING);
	
	std::string callback = lua_tostring(_state, 1);
	std::string error = lua_tostring(_state, 2);
	
	s_pInstance->GetStoreItemDetails( callback, error );
	
	return 0;
}

GameAppDelegate::GameAppDelegate()
{
	FC_TRACE;
	
	s_pInstance = this;
	m_pBoard = new Board( &m_brain );
}

GameAppDelegate::~GameAppDelegate()
{
	FC_TRACE;
	
	delete m_pBoard;
}

void GameAppDelegate::RegisterPhasesWithManager( FCPhaseManager* pPhaseManager )
{
	FC_TRACE;
	m_frontEndPhase = FCPhaseRef( new FEPhase("FrontEnd") );
	pPhaseManager->AttachPhase( m_frontEndPhase );
	
	m_gamePhase = FCPhaseRef( new GamePhase( "Game" ));
	pPhaseManager->AttachPhase( m_gamePhase );

	m_howToPlayPhase = FCPhaseRef( new HowToPlayPhase( "HowToPlay" ));
	pPhaseManager->AttachPhase( m_howToPlayPhase );
}

void GameAppDelegate::DeregisterPhasesWithManager( FCPhaseManager* pPhaseManager )
{
	FC_TRACE;
	
	pPhaseManager->DetatchPhase( m_frontEndPhase );
	m_frontEndPhase = 0;

	pPhaseManager->DetatchPhase( m_gamePhase );
	m_gamePhase = 0;

	pPhaseManager->DetatchPhase( m_howToPlayPhase );
	m_howToPlayPhase = 0;
}

void GameAppDelegate::InitializeSystems()
{
	FC_TRACE;
	FCLua::Instance()->CoreVM()->CreateGlobalTable("GameAppDelegate");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetImageForTile, "GameAppDelegate.SetImageForTile");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_GetStoreItemDetails, "GameAppDelegate.GetStoreItemDetails");
	
	m_brain.RegisterLuaFunctions();
}

void GameAppDelegate::ShutdownSystems()
{
	FC_TRACE;
	m_brain.DeregisterLuaFunctions();
	FCLua::Instance()->CoreVM()->RemoveCFunction("GameAppDelegate.SetImageForTile");
	FCLua::Instance()->CoreVM()->RemoveCFunction("GameAppDelegate.GetStoreItemDetails");
	FCLua::Instance()->CoreVM()->DestroyGlobalTable("GameAppDelegate");
}

void GameAppDelegate::GetStoreItemDetails(std::string luaCallback, std::string luaError)
{
	FCStringVector productIDs;
	productIDs.push_back("com.curlyrocket.curlyminesweeper.smallcoins2");
	productIDs.push_back("com.curlyrocket.curlyminesweeper.mediumcoins");
	productIDs.push_back("com.curlyrocket.curlyminesweeper.largecoins");
	
	FCStore::Instance()->GetStoreItemDetailsWithLuaCallbacks( productIDs, luaCallback, luaError );
}

void GameAppDelegate::Update( float realTime, float gameTime )
{
	FC_TRACE;
}
