//
//  WorldActor.m
//  CR1
//
//  Created by Martin Linklater on 26/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#include "WorldActor.h"

FCActorRef WorldActor::Create()
{
	return FCActorRef( new WorldActor );
}

bool WorldActor::NeedsUpdate()
{
	return true;
}

bool WorldActor::NeedsRender()
{
	return true;
}

FCModelRefVec WorldActor::RenderGather()
{
	FCModelRefVec ret;
	ret.push_back(m_model);
	return ret;
}

void WorldActor::Update(float realTime, float gameTime)
{
	FCActor::Update( realTime, gameTime );
}
