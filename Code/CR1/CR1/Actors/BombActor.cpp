//
//  BombActor.m
//  CR1
//
//  Created by Martin Linklater on 09/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "BombActor.h"

FCActorRef BombActor::Create()
{
	return FCActorRef( new BombActor );
}

bool BombActor::NeedsUpdate()
{
	return true;
}

bool BombActor::NeedsRender()
{
	return true;
}

FCModelRefVec BombActor::RenderGather()
{
	FCModelRefVec ret;
	ret.push_back( m_model );
	return ret;
}

void BombActor::Update(float realTime, float gameTime)
{
	FCActor::Update(realTime, gameTime);
}
