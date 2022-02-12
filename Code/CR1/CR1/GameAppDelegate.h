//
//  GameAppDelegate.h
//  CR1
//
//  Created by Martin Linklater on 21/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_GameAppDelegate_h
#define CR1_GameAppDelegate_h

#include "Shared/Framework/FCApplication.h"

#include "Phases/FrontEndPhase.h"
#include "Phases/GamePhase.h"
#include "ScreenFXManager.h"

class GameAppDelegate : public FCApplicationDelegate
{
public:
	
	GameAppDelegate();
	virtual ~GameAppDelegate();
	
	void RegisterPhasesWithManager( FCPhaseManager* pPhaseManager );
	void InitializeSystems();
	void Update( float realTime, float gameTime );
	
	void ShowAdBanner();
	void HideAdBanner();
	
	FrontEndPhaseRef	m_frontEndPhase;
	GamePhaseRef		m_gamePhase;
	ScreenFXManagerRef	m_screenFXManager;
};

#endif
