//
//  GemActor.h
//  CR1
//
//  Created by Martin Linklater on 09/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef GEMACTOR_H
#define GEMACTOR_H

#include "Shared/Framework/Actor/FCActor.h"

class GemActor : public FCActor
{
public:
	static FCActorRef Create();
	
	GemActor()
	: m_age( 0 )
	{}
	virtual ~GemActor(){}
	
	std::string Class(){ return "GemActor"; }
	bool NeedsUpdate();
	bool NeedsRender();
	FCModelRefVec RenderGather();
	void Update( float realTime, float gameTime );
	
	void		SetAge( uint16_t age ){ m_age = age; }
	uint16_t	Age(){ return m_age; }
	
private:
	uint16_t	m_age;
};

typedef std::shared_ptr<GemActor> GemActorRef;

#endif
