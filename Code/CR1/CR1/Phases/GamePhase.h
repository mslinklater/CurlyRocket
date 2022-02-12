//
//  GamePhase.h
//  CR1
//
//  Created by Martin Linklater on 15/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#ifndef GAMEPHASE_H
#define GAMEPHASE_H

#include "Shared/Core/FCCore.h"
#include "Shared/Framework/Phase/FCPhaseManager.h"

#include "Actors/BallActor.h"
#include "Actors/GemActor.h"
#include "Actors/BombActor.h"
#include "Shared/Core/Resources/FCResource.h"

#include "Views/RackView.h"
#include "Views/RoundsView.h"
#include "Views/TimerView.h"

#include "GLES/FCGLView.h"

class IFCRenderer;
class IFCTextureManager;
class IFCShaderManager;

class GamePhase : public FCPhase
{
public:
	
	GamePhase( std::string name );
	virtual ~GamePhase();

	void	LoadLevel( std::string name );
	void	DestroyLevel();
	void	SetCurrentRound( int32_t currentRound, int32_t numRounds );
	FCHandle	CreateBall( eBallColor color, const FCVector2f& pos );
	void	DestroyBall( FCHandle ball );
	FCHandle	CreateGem( const FCVector2f& pos );
	void	DestroyGem( FCHandle gem );
	void	SetGemColor( FCHandle gem, const FCColor4f& color );
	void	SetGemAge( FCHandle gem, int32_t age );
	int32_t	GemAge( FCHandle gem );
	FCHandle	CreateBomb( const FCVector2f& pos, uint32_t fuse );
	void	DestroyBomb( FCHandle bomb );
	
	virtual FCPhaseUpdate Update( float dt );
	virtual void WasAddedToQueue();
	virtual void WasRemovedFromQueue();
	virtual void WillActivate();
	virtual void IsNowActive();
	virtual void WillDeactivate();
	virtual void IsNowDeactive();
	
	IFCRenderer*		m_gameRenderer;
	IFCShaderManager*	m_shaderManager;
	IFCTextureManager*	m_textureManager;
	
	FCResourceRef		m_worldResource;
	FCResourceRef		m_redBallResource;
	FCResourceRef		m_blueBallResource;
	FCResourceRef		m_yellowBallResource;
	FCResourceRef		m_greenBallResource;
	FCResourceRef		m_gemResource;
	FCResourceRef		m_bombResource;
	
	FCActorRefVec			m_levelActors;
	FCActorRefMapByHandle	m_actors;

	FCGLViewRef			m_gameView;
	RackViewRef			m_rackView;
	RoundsViewRef		m_roundsView;
	TimerViewRef		m_timerView;
	
	bool				m_forceGameOver;
	float				m_timerTotal;
	float				m_timerRemaining;
private:
	FCHandle	m_gameViewTapHandle;
};

typedef std::shared_ptr<GamePhase> GamePhaseRef;

#endif // GAMEPHASE_H
