//
//  GemActor.m
//  CR1
//
//  Created by Martin Linklater on 09/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "GemActor.h"

FCActorRef GemActor::Create()
{
	return FCActorRef( new GemActor );
}

bool GemActor::NeedsUpdate()
{
	return true;
}

bool GemActor::NeedsRender()
{
	return true;
}

FCModelRefVec GemActor::RenderGather()
{
	FCModelRefVec ret;
	ret.push_back(m_model);
	return ret;
}

void GemActor::Update(float realTime, float gameTime)
{
	FCActor::Update( realTime, gameTime );
}
