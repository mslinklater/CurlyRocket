//
//  BombActor.h
//  CR1
//
//  Created by Martin Linklater on 09/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef BOMBACTOR_H
#define BOMBACTOR_H

#include "Shared/Framework/Actor/FCActor.h"

class BombActor : public FCActor
{
public:
	static FCActorRef Create();
	
	BombActor(){}
	virtual ~BombActor(){}
	
	std::string Class(){ return "BombActor"; }
	bool NeedsUpdate();
	bool NeedsRender();
	FCModelRefVec RenderGather();
	void Update( float realTime, float gameTime );
	
	void	SetFuse( float fuse ){ m_fuse = fuse; }
	float	Fuse(){ return m_fuse; }
	
private:
	float m_fuse;
};

typedef std::shared_ptr<BombActor> BombActorRef;

#endif // BOMBACTOR_H
