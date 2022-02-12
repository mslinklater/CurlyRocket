//
//  GameAppDelegate.h
//  CR2
//
//  Created by Martin Linklater on 20/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR2_GameAppDelegate_h
#define CR2_GameAppDelegate_h

#include "Shared/Framework/FCApplication.h"

#include "FEPhase.h"
#include "GamePhase.h"
#include "GameTypes.h"

class GameAppDelegate : public FCApplicationDelegate
{
public:
	GameAppDelegate();
	virtual ~GameAppDelegate();

	void RegisterPhasesWithManager( FCPhaseManager* pPhaseManager );
	void InitializeSystems();
	void Update( float realTime, float gameTime );
	
	void ShowAdBanner();

	eGameType	GameType(){ return m_gameType; }
	void		SetGameType( eGameType gameType ){ m_gameType = gameType; }
	
private:
	FCPhaseRef		m_frontEndPhase;
	FCPhaseRef		m_gamePhase;
	
	eGameType		m_gameType;
};

#endif
