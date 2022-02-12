//
//  GameAppDelegate.h
//  CR4
//
//  Created by Martin Linklater on 10/01/2013.
//  Copyright (c) 2013 Martin Linklater. All rights reserved.
//

#ifndef CR4_GameAppDelegate_h
#define CR4_GameAppDelegate_h

#include "Shared/Framework/FCApplication.h"

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

private:
};

#endif
