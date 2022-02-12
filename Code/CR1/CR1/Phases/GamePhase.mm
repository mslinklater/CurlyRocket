//
//  GamePhase.m
//  CR1
//
//  Created by Martin Linklater on 15/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

//#import "FCApplication_old.h"

#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"
#include "Shared/Framework/Actor/FCActorSystem.h"
#include "Shared/Framework/FCApplication.h"

#include "Phases/GamePhase.h"

#include "Shared/Graphics/FCRenderer.h"
#include "Shared/Graphics/FCShaderManager.h"
#include "Shared/Graphics/FCTextureManager.h"

#include "Shared/Framework/Gameplay/FCObjectManager.h"
#include "Shared/Core/Resources/FCResourceManager.h"
#include "Shared/Framework/UI/FCViewManager.h"
#include "Shared/Framework/Input/FCInput.h"

static GamePhaseRef s_pGamePhase;

#pragma mark - Lua functions

static int lua_LoadLevel( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);

	FC_ASSERT(s_pGamePhase);
	
	s_pGamePhase->LoadLevel(lua_tostring(_state, 1));
	
	return 0;
}

static int lua_DestroyLevel( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(0);
	FC_ASSERT(s_pGamePhase);
	
	s_pGamePhase->DestroyLevel();
	
	return 0;
}

static int lua_SetRounds( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	int currentRound = lua_tointeger(_state, 1);
	int numRounds = lua_tointeger(_state, 2);
	
	s_pGamePhase->SetCurrentRound(currentRound, numRounds);
	return 0;
}

static int lua_CreateBall( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(3);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(3, LUA_TNUMBER);

	FCVector2f pos;
	pos.x = (float)lua_tonumber(_state, 2);
	pos.y = (float)lua_tonumber(_state, 3);
	
	FCHandle hBall = s_pGamePhase->CreateBall( (eBallColor)lua_tointeger(_state, 1), pos);

	lua_pushinteger(_state, hBall);
	return 1;
}

static int lua_DestroyBall( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	
	FCHandle hBall = (FCHandle)lua_tointeger(_state, 1);

	s_pGamePhase->DestroyBall( hBall );
	
	return 0;
}

static int lua_CreateGem( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	FCVector2f pos = FCVector2f( (float)lua_tonumber(_state, 1), (float)lua_tonumber(_state, 2) );
	
	FCHandle hGem = s_pGamePhase->CreateGem( pos );
	
	lua_pushinteger(_state, hGem);
	return 1;
}

static int lua_DestroyGem( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	
	FCHandle hGem = (FCHandle)lua_tointeger(_state, 1);
	
	s_pGamePhase->DestroyGem( hGem );
	
	return 0;
}

static int lua_GetGemAge( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);

	FCHandle h = (FCHandle)lua_tointeger(_state, 1);
	lua_pushnumber(_state, s_pGamePhase->GemAge(h));
	return 1;
}

static int lua_SetGemAge( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	FCHandle h = (FCHandle)lua_tointeger(_state, 1);
	s_pGamePhase->SetGemAge(h, lua_tointeger(_state, 2));
	return 0;
}

static int lua_SetGemRGBA( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(5);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(3, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(4, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(5, LUA_TNUMBER);
	
	FCHandle handle = lua_tointeger(_state, 1);

	FCColor4f color = FCColor4f( (float)lua_tonumber(_state, 2), (float)lua_tonumber(_state, 3), (float)lua_tonumber(_state, 4), (float)lua_tonumber(_state, 5) );
	
	s_pGamePhase->SetGemColor(handle, color);
	
	return 0;
}

static int lua_CreateBomb( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(3);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(3, LUA_TNUMBER);

	FCVector2f pos = FCVector2f( (float)lua_tonumber(_state, 2), (float)lua_tonumber(_state, 3) );
	
	FCHandle hBomb = s_pGamePhase->CreateBomb(pos, (uint32_t)lua_tonumber(_state, 1));
	
	lua_pushinteger(_state, hBomb);
	return 1;
}

static int lua_DestroyBomb( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	
	FCHandle hBomb = (FCHandle)lua_tointeger(_state, 1);
	
	s_pGamePhase->DestroyBomb( hBomb );
	
	return 0;
}

static int lua_RackClear( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(0);
	s_pGamePhase->m_rackView->Clear();
	return 0;
}

static int lua_RackFillWithColors( lua_State* _state )
{
	// red = 1
	// blue = 2
	// green = 3
	// yellow = 4
	
	FC_ASSERT(lua_gettop(_state) >= 3);
	FC_ASSERT(lua_gettop(_state) <= 5);
	
	uint32_t numColors = lua_gettop(_state);
	
	FCStringVector colors;
	
	for (uint32_t i = 0; i < numColors ; i++) {
		int color = lua_tointeger(_state, i + 1 ) + 1;
		switch (color) {
			case 1:
				colors.push_back(kFCKeyRed);
				break;
			case 2:
				colors.push_back(kFCKeyBlue);
				break;
			case 3:
				colors.push_back(kFCKeyGreen);
				break;
			case 4:
				colors.push_back(kFCKeyYellow);
				break;				
			default:
				FC_ASSERT_MSG(0, "Unknown rack color from Lua");
				break;
		}
	}
	
	s_pGamePhase->m_rackView->FillWithColors( colors );
	
	return 0;
}

static int lua_RackGetCurrentColor( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(0);
	
	std::string color = s_pGamePhase->m_rackView->GetCurrentColor();
	
	if (color == kFCKeyRed) {
		lua_pushinteger(_state, 1);
	} else if (color == kFCKeyBlue) {
		lua_pushinteger(_state, 2);
	} else if (color == kFCKeyGreen) {
		lua_pushinteger(_state, 3);
	} else if (color == kFCKeyYellow) {
		lua_pushinteger(_state, 4);
	} else if (color == kFCKeyNull) {
		lua_pushinteger(_state, 0);
	}
	
	return 1;
}

static int lua_RackRemoveCurrent( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(0);
	
	lua_pushboolean(_state, s_pGamePhase->m_rackView->RemoveCurrent());

	return 1;
}

static int lua_ForceGameOver( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(0);
	s_pGamePhase->m_forceGameOver = YES;
	return 0;
}

static int lua_CreateRackView( lua_State* _state )
{
	s_pGamePhase->m_rackView = plt_RackView_Create( "rackView", "" );
	return 0;
}

static int lua_DestroyRackView( lua_State* _state )
{
	s_pGamePhase->m_rackView = 0;
	return 0;
}

static int lua_CreateRoundsView( lua_State* _state )
{
	s_pGamePhase->m_roundsView = plt_RoundsView_Create( "roundsView", "" );
	return 0;
}

static int lua_DestroyRoundsView( lua_State* _state )
{
	s_pGamePhase->m_roundsView = 0;
	return 0;
}

static int lua_CreateTimerView( lua_State* _state )
{
	s_pGamePhase->m_timerView = plt_TimerView_Create( "timerView", "" );
	return 0;
}

static int lua_DestroyTimerView( lua_State* _state )
{
	s_pGamePhase->m_timerView = 0;
	return 0;
}

static int lua_SetTimes( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	float totalTime = (float)lua_tonumber(_state, 1);
	float timeRemaining = (float)lua_tonumber(_state, 2);
	
	s_pGamePhase->m_timerTotal = totalTime;
	s_pGamePhase->m_timerRemaining = timeRemaining;
	
	s_pGamePhase->m_timerView->SetTotal( totalTime );
	s_pGamePhase->m_timerView->SetRemaining( timeRemaining );
	
	return 0;
}

static int lua_GameViewTapped( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	float x = (float)lua_tonumber(_state, 1);
	float y = (float)lua_tonumber(_state, 2);
	
	FCVector2f point;
	FCVector2f viewSize = s_pGamePhase->m_gameView->ViewSize();
	point.x = x * viewSize.x;
	point.y = y * viewSize.y;
	FCVector3f posInWorld = s_pGamePhase->m_gameView->PosOnPlane(point);
	
	const FCActorRefVec tappableActors = FCActorSystem::Instance()->TapGestureActorsVec();
	
	float closestMag = 10.0f;
	FCActorRef closestActor = 0;
	
	for( FCActorRefVecConstIter i = tappableActors.begin() ; i != tappableActors.end() ; i++ )
	{
		FCActorRef actor = *i;
		
		FCVector3f actorPos = actor->Position();
		
		FCVector3f diff = actorPos - posInWorld;
		
		float mag = FCMagnitude(diff);
		
		if( mag < 2 )
		{
			if (mag < closestMag) {
				closestMag = mag;
				closestActor = actor;
			}
		}
	}
	if (closestActor) 
	{		
		BallActorRef actorPtr = std::dynamic_pointer_cast<BallActor>(closestActor);
		
		if (actorPtr) 
		{
			FCLua::Instance()->CoreVM()->CallFuncWithSig("GamePhase.BallTapped", true, "i>", closestActor->Handle());
		}
	}

	return 0;
}

static void RenderGameView()
{
	s_pGamePhase->m_gameView->SetFrameBuffer();
	s_pGamePhase->m_gameView->Clear();
	s_pGamePhase->m_gameView->SetProjectionMatrix();
	s_pGamePhase->m_gameRenderer->Render();
	s_pGamePhase->m_gameView->PresentFramebuffer();
}

GamePhase::GamePhase( std::string name )
: FCPhase( name )
{
	s_pGamePhase = GamePhaseRef( this );
	
	// register Lua functions
	
	FCLua::Instance()->CoreVM()->CreateGlobalTable("Game");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_LoadLevel, "Game.LoadLevel");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_DestroyLevel, "Game.DestroyLevel");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetRounds, "Game.SetRounds");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_ForceGameOver, "Game.ForceGameOver");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_CreateBall, "Game.CreateBall");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_DestroyBall, "Game.DestroyBall");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_CreateGem, "Game.CreateGem");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_DestroyGem, "Game.DestroyGem");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_GetGemAge, "Game.GetGemAge");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetGemAge, "Game.SetGemAge");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetGemRGBA, "Game.SetGemRGBA");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_CreateBomb, "Game.CreateBomb");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_DestroyBomb, "Game.DestroyBomb");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_CreateRackView, "Game.CreateRackView");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_DestroyRackView, "Game.DestroyRackView");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_CreateRoundsView, "Game.CreateRoundsView");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_DestroyRoundsView, "Game.DestroyRoundsView");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_CreateTimerView, "Game.CreateTimerView");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_DestroyTimerView, "Game.DestroyTimerView");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_RackClear, "Game.RackClear");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_RackFillWithColors, "Game.RackFillWithColors");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_RackGetCurrentColor, "Game.RackGetCurrentColor");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_RackRemoveCurrent, "Game.RackRemoveCurrent");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetTimes, "Game.SetTimes");
	
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_GameViewTapped, "Game.GameViewTapped");
	
	FCVector2f screenSize = FCApplication::Instance()->MainViewSize();

	m_gameView = plt_FCGLView_Create("gameView", "", FCVector2i((int)screenSize.x, (int)screenSize.y));
	m_gameView->SetDepthBuffer( true );
	m_gameView->SetRenderTarget( RenderGameView );
	
	// Setup shaders used in the game
	
	m_gameRenderer = plt_FCRenderer_Create("gameRenderer");
	
	m_textureManager = plt_FCTextureManager_Instance();
	
//	m_gameRenderer->SetTextureManager( m_textureManager );
	
	IFCShaderManager* pShaderManager = plt_FCShaderManager_Instance();
	
	pShaderManager->ActivateShader( kFCKeyShaderDebug );
	pShaderManager->ActivateShader( kFCKeyShaderWireframe );
	pShaderManager->ActivateShader( kFCKeyShaderFlatUnlit );
	pShaderManager->ActivateShader( kFCKeyShaderNoTexVLit );
	pShaderManager->ActivateShader( kFCKeyShaderNoTexPLit );
	pShaderManager->ActivateShader( kFCKeyShader1TexVLit );
	pShaderManager->ActivateShader( kFCKeyShader1TexPLit );
	pShaderManager->ActivateShader( kFCKeyShaderTest );
	
	FCColor4f red = FCColor4f( 1.0f, 0.0f, 0.0f, 1.0f );
	FCColor4f green = FCColor4f( 0.0f, 1.0f, 0.0f, 1.0f );
	FCColor4f blue = FCColor4f( 0.0f, 0.0f, 1.0f, 1.0f );
	FCColor4f yellow = FCColor4f( 1.0f, 1.0f, 0.0f, 1.0f );
	
	m_redBallResource = FCResourceManager::Instance()->ResourceWithPath("Resources/redball");		
	m_redBallResource->SetUserData(&red);
	
	m_blueBallResource = FCResourceManager::Instance()->ResourceWithPath("Resources/blueball");
	m_blueBallResource->SetUserData(&blue);
	
	m_greenBallResource = FCResourceManager::Instance()->ResourceWithPath("Resources/greenball");
	m_greenBallResource->SetUserData(&green);
	
	m_yellowBallResource = FCResourceManager::Instance()->ResourceWithPath("Resources/yellowball");
	m_yellowBallResource->SetUserData(&yellow);
	
	m_gemResource = FCResourceManager::Instance()->ResourceWithPath("Resources/gem");
	m_bombResource = FCResourceManager::Instance()->ResourceWithPath("Resources/bomb");
	
	m_forceGameOver = false;
}

GamePhase::~GamePhase()
{
	FCViewManager::Instance()->DestroyView("gameView");	
}

void GamePhase::LoadLevel( std::string levelName )
{
	m_worldResource = FCResourceManager::Instance()->ResourceWithPath(std::string("Resources/") + levelName );
	
	// Gameplay objects
	
	FCObjectManager::Instance()->Reset();
	FCObjectManager::Instance()->AddObjectsFromResource(m_worldResource);
	
	// Actors
	
	m_levelActors = FCActorSystem::Instance()->CreateActors( "WorldActor", m_worldResource, "level" );
	
	for (FCActorRefVecIter i = m_levelActors.begin(); i != m_levelActors.end(); i++) {
		m_gameRenderer->AddToGatherList(*i);
	}	
}

void GamePhase::DestroyLevel()
{
	for (FCActorRefVecIter i = m_levelActors.begin(); i != m_levelActors.end(); i++)
	{
		m_gameRenderer->RemoveFromGatherList(*i);
		FCActorSystem::Instance()->RemoveActor(*i);
	}
	m_levelActors.clear();
}

void GamePhase::SetCurrentRound(int32_t currentRound, int32_t numRounds)
{
	m_roundsView->SetCurrentRound( (uint16_t)currentRound );
	m_roundsView->SetNumRounds( (uint16_t)numRounds );	
}

#pragma mark - Ball methods

FCHandle GamePhase::CreateBall( eBallColor color, const FCVector2f& pos)
{
	FCResourceRef ballResource;

	switch (color) {
		case kBallColorRed:
			ballResource = m_redBallResource;
			break;
		case kBallColorBlue:
			ballResource = m_blueBallResource;
			break;
		case kBallColorGreen:
			ballResource = m_greenBallResource;
			break;
		case kBallColorYellow:
			ballResource = m_yellowBallResource;
			break;
	}
	
	FCActorRef ball = FCActorSystem::Instance()->CreateActors("BallActor", ballResource, "")[0];
	
	m_actors[ball->Handle()] = ball;
	
	m_gameRenderer->AddToGatherList( ball );
	
	ball->SetPosition(FCVector3f( pos.x, pos.y, 0.0f ));
	
	return ball->Handle();
}

void GamePhase::DestroyBall( FCHandle hBall )
{
	FCActorRef ball = m_actors[ hBall ];
	
	m_gameRenderer->RemoveFromGatherList( ball );
	FCActorSystem::Instance()->RemoveActor( ball );
	m_actors.erase( hBall );	
}

#pragma mark - Gem methods

FCHandle GamePhase::CreateGem( const FCVector2f &pos )
{
	FCActorRef gem = FCActorSystem::Instance()->CreateActors("GemActor", m_gemResource, "")[0];
	m_actors[gem->Handle()] = gem;
	m_gameRenderer->AddToGatherList( gem );
	gem->SetPosition(FCVector3f(pos.x, pos.y, 0.0f));
	
	return gem->Handle();
}

void GamePhase::DestroyGem( FCHandle hGem )
{
	FCActorRef gem = m_actors[hGem];
	
	m_gameRenderer->RemoveFromGatherList( gem );
	FCActorSystem::Instance()->RemoveActor(gem);
	m_actors.erase(hGem);	
}

int32_t GamePhase::GemAge(FCHandle hGem)
{
	GemActorRef gem = std::static_pointer_cast<GemActor>(m_actors[ hGem ]);
	return gem->Age();
}

void GamePhase::SetGemAge(FCHandle hGem, int32_t age)
{
	GemActorRef gem = std::static_pointer_cast<GemActor>( m_actors[hGem] );
	gem->SetAge( (unsigned short)age );
}

void GamePhase::SetGemColor(FCHandle hGem, const FCColor4f &color)
{
	GemActorRef gem = std::static_pointer_cast<GemActor>(m_actors[hGem]);
	gem->SetDebugModelColor(color);	
}


#pragma mark - Bomb methods

FCHandle GamePhase::CreateBomb(const FCVector2f &pos, uint32_t fuse)
{
	FCActorRef actor = FCActorSystem::Instance()->CreateActors("BombActor", m_bombResource, "")[0];
	m_gameRenderer->AddToGatherList( actor );
	BombActorRef bomb = std::static_pointer_cast<BombActor>(actor);	
	bomb->SetPosition(FCVector3f(pos.x, pos.y, 0.0f));
	bomb->SetFuse( fuse );
	
	return bomb->Handle();
}

void GamePhase::DestroyBomb( FCHandle hBomb )
{
	FCActorRef bomb = m_actors[ hBomb ];
	
	if (!bomb)
	{
		FC_WARNING("Trying to destroy a bomb that doesn't exist");
		return;
	}
	
	m_gameRenderer->RemoveFromGatherList( bomb );
	FCActorSystem::Instance()->RemoveActor(bomb);
	m_actors.erase(hBomb);	
}

#pragma mark - FCPhaseDelegate

FCPhaseUpdate GamePhase::Update(float dt)
{
	FCPhase::Update(dt);
	
//	[m_gameView update:dt];
	m_gameView->Update(dt);
	
	FCLua::Instance()->CoreVM()->CallFuncWithSig("GamePhase.Update", true, ">");
	
	if (m_forceGameOver) 
	{
		m_forceGameOver = false;
		FCLua::Instance()->CoreVM()->CallFuncWithSig("GamePhase.EndGameUI", true, ">");
	}
	
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
	{
//		FCViewManager_apple* vm = [FCViewManager_apple instance];	// FIX	
//		[vm.rootView addSubview:m_gameView];
	}

	if( FCViewManager::Instance()->ViewExists("topfx") )
		FCViewManager::Instance()->SendViewToFront("topfx");
	
	m_activateTimer = 0.0f;
	
	return;
}

void GamePhase::IsNowActive()
{
	FCPhase::IsNowActive();
	m_gameViewTapHandle = FCInput::Instance()->AddTapSubscriber("gameView", "Game.GameViewTapped");
//	FCViewManager::Instance()->SendViewToFront("gameView");
}

void GamePhase::WillDeactivate()
{
	FCPhase::WillDeactivate();
	FCInput::Instance()->RemoveTapSubscriber("gameView", m_gameViewTapHandle);
	
	m_deactivateTimer = 0.0f;
	
	return;
}

void GamePhase::IsNowDeactive()
{
	FCPhase::IsNowDeactive();
	
	for (FCActorRefVecIter i = m_levelActors.begin(); i != m_levelActors.end(); i++) {
		m_gameRenderer->RemoveFromGatherList(*i);
	}

	for (FCActorRefMapByHandleIter i = m_actors.begin() ; i != m_actors.end() ; i++) {
		m_gameRenderer->RemoveFromGatherList(i->second);
	}
	
	FC_LOG("GamePhase:isNowDeactive");	
	
//	[m_gameView removeFromSuperview];
	m_levelActors.clear();
}

