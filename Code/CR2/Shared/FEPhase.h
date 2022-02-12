//
//  FEPhase.h
//  CR2
//
//  Created by Martin Linklater on 20/07/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR2_FEPhase_h
#define CR2_FEPhase_h

#include "Shared/Framework/Phase/FCPhase.h"

class FEPhase : public FCPhase
{
public:
	FEPhase( std::string name );
	virtual ~FEPhase();

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

typedef FCSharedPtr<FEPhase> FEPhaseRef;

#endif
