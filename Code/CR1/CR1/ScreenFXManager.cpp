//
//  ScreenFXManager.cpp
//  CR1
//
//  Created by Martin Linklater on 28/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#include "ScreenFXManager.h"
#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"
#include "Shared/Core/Device/FCDevice.h"
#include "Shared/Core/FCFile.h"
#include "Shared/Framework/UI/FCViewManager.h"

static ScreenFXManager* s_pInstance = 0;

// Lua interface

static int lua_AddPictureToBackground( lua_State* _state )
{
	FC_ASSERT(s_pInstance);
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	FC_LUA_ASSERT_TYPE(2, LUA_TBOOLEAN);
	
	std::string filename = lua_tostring(_state, 1);

	s_pInstance->AddPicture( filename );
	
	return 0;
}

static int lua_StartBackgroundPan( lua_State* _state )
{
	FC_ASSERT(s_pInstance);
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	
	float seconds = (float)lua_tonumber(_state, 1);

	s_pInstance->StartBackgroundPan( seconds );
	return 0;
}

static int lua_SetNextBackgroundImage( lua_State* _state )
{
	FC_ASSERT(s_pInstance);
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	
	std::string filename = lua_tostring(_state, 1);

	s_pInstance->SetNextBackgroundImage( filename );
	
	return 0;
}

// C++ interface

ScreenFXManager::ScreenFXManager()
{
	s_pInstance = this;
	FCLua::Instance()->CoreVM()->CreateGlobalTable("ScreenFX");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_AddPictureToBackground, "ScreenFX.AddPictureToBackground");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_StartBackgroundPan, "ScreenFX.StartBackgroundPan");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetNextBackgroundImage, "ScreenFX.SetNextBackgroundImage");
	
	sscanf(FCDevice::Instance()->GetCap( kFCDeviceDisplayLogicalXRes ).c_str(), "%f", &m_screenSize.x);
	sscanf(FCDevice::Instance()->GetCap( kFCDeviceDisplayLogicalYRes ).c_str(), "%f", &m_screenSize.y);

	m_pBackgroundView = plt_KenBurnsView_Create("background", "");
	m_pTopFXView = plt_TopFXView_Create("TopFXView", "");

	FCViewManager* vm = FCViewManager::Instance();
	
	vm->SendViewToBack("background");
//	vm->SetViewFrame("background", vm->FullFrame(), 0.0f);
	vm->SetViewFrame("background", FCRect(0.0f, 0.0f, 1.0f, 1.0f), 0.0f);
	vm->SendViewToFront("TopFXView");
}

ScreenFXManager::~ScreenFXManager()
{
	m_pBackgroundView = 0;
	m_pTopFXView = 0;
}

ScreenFXManager* ScreenFXManager::Instance()
{
	if (!s_pInstance) {
		s_pInstance = new ScreenFXManager;
	}
	return s_pInstance;
}

void ScreenFXManager::Update( float dt )
{
//	m_pTopFXView->
}

void ScreenFXManager::AddPicture( std::string filename )
{
	FCFileRef pictureFile = FCFileRef( new FCFile );
	pictureFile->Open( filename, kFCFileOpenModeReadOnly, kFCFileLocationApplicationBundle );
	
	FCData data;
	data.ptr = pictureFile->Data();
	data.size = pictureFile->Size();

	m_backgroundImages[ filename ] = data;
}

void ScreenFXManager::StartBackgroundPan( float seconds )
{
	m_pBackgroundView->StartPrimaryFrameAnimation( seconds );
}

void ScreenFXManager::SetNextBackgroundImage( std::string filename )
{
	m_pBackgroundView->SetSecondaryImage( filename );
}
