//
//  CurlyRocketPhase.h
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR3_CurlyRocketPhase_h
#define CR3_CurlyRocketPhase_h

#include "Shared/Framework/Phase/FCPhase.h"

class CurlyRocketPhase : public FCPhase
{
public:
	CurlyRocketPhase( std::string name );
	virtual ~CurlyRocketPhase();
	
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

typedef FCSharedPtr<CurlyRocketPhase> CurlyRocketPhaseRef;

#endif
