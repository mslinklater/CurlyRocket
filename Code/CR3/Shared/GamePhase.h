//
//  GamePhase.h
//  CR3
//
//  Created by Martin Linklater on 04/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR3_GamePhase_h
#define CR3_GamePhase_h

#include "Shared/Framework/Phase/FCPhase.h"

class GamePhase : public FCPhase
{
public:
	GamePhase( std::string name );
	virtual ~GamePhase();
	
	virtual FCPhaseUpdate Update( float dt );
	virtual void WasAddedToQueue();
	virtual void WasRemovedFromQueue();
	virtual void WillActivate();
	virtual void WillActivatePostLua();
	virtual void IsNowActive();
	virtual void WillDeactivate();
	virtual void IsNowDeactive();
	virtual void IsNowDeactivePostLua();
private:
};

typedef FCSharedPtr<GamePhase> GamePhaseRef;


#endif