//
//  FrontEndPhase.h
//  CR1
//
//  Created by Martin Linklater on 15/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#ifndef FRONTENDPHASE_H
#define FRONTENDPHASE_H

#include "Shared/Framework/Phase/FCPhase.h"

class FrontEndPhase : public FCPhase
{
public:
	FrontEndPhase( std::string name );
	virtual ~FrontEndPhase(){}
	
	virtual FCPhaseUpdate Update( float dt );
	virtual void WasAddedToQueue();
	virtual void WasRemovedFromQueue();
	virtual void WillActivate();
	virtual void WillActivatePostLua();
	virtual void IsNowActive();
	virtual void WillDeactivate();
	virtual void IsNowDeactive();
	virtual void IsNowDeactivePostLua();
};

typedef std::shared_ptr<FrontEndPhase> FrontEndPhaseRef;

#endif // FRONTENDPHASE_H
