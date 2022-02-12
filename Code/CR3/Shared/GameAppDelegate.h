//
//  GameAppDelegate.h
//  CR3
//
//  Created by Martin Linklater on 04/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR3_GameAppDelegate_h
#define CR3_GameAppDelegate_h

#include "Shared/Framework/FCApplication.h"
#include "FEPhase.h"
#include "GamePhase.h"
#include "HowToPlayPhase.h"
#include "CurlyRocketPhase.h"
#include "GameTypes.h"
#include "MS/MSManager.h"
#include "Board.h"

class GameAppDelegate : public FCApplicationDelegate
{
public:
	GameAppDelegate();
	virtual ~GameAppDelegate();
	
	void RegisterPhasesWithManager( FCPhaseManager* pPhaseManager );
	void DeregisterPhasesWithManager( FCPhaseManager* pPhaseManager );
	void InitializeSystems();
	void ShutdownSystems();
	void Update( float realTime, float gameTime );

	void GetStoreItemDetails( std::string luaCallback, std::string luaError );
	
private:
	FCPhaseRef	m_frontEndPhase;
	FCPhaseRef	m_gamePhase;
	FCPhaseRef	m_howToPlayPhase;
	
	MSManager	m_brain;
	Board*		m_pBoard;
};

#endif
