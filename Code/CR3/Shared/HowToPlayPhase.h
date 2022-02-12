//
//  HowToPlayPhase.h
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR3_HowToPlayPhase_h
#define CR3_HowToPlayPhase_h

#include "Shared/Framework/Phase/FCPhase.h"

class HowToPlayPhase : public FCPhase
{
public:
	HowToPlayPhase( std::string name );
	virtual ~HowToPlayPhase();
	
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

typedef FCSharedPtr<HowToPlayPhase> HowToPlayPhaseRef;

#endif
