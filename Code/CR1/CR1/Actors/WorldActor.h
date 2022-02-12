//
//  WorldActor.h
//  CR1
//
//  Created by Martin Linklater on 26/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_WorldActor_h
#define CR1_WorldActor_h

#include "Shared/Framework/Actor/FCActor.h"

class WorldActor : public FCActor
{
public:
	static FCActorRef Create();
	
	std::string Class(){ return "WorldActor"; }
	bool NeedsUpdate();
	bool NeedsRender();
	FCModelRefVec RenderGather();
	void Update( float realTime, float gameTime );
};

typedef std::shared_ptr<WorldActor> WorldActorRef;

#endif
