//
//  BallActor.m
//  CR1
//
//  Created by Martin Linklater on 04/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "BallActor.h"

FCActorRef BallActor::Create()
{
	return FCActorRef( new BallActor );
}

bool BallActor::NeedsUpdate()
{
	return true;
}

bool BallActor::NeedsRender()
{
	return true;
}

bool BallActor::RespondsToTapGesture()
{
	return true;
}

FCModelRefVec BallActor::RenderGather()
{
	FCModelRefVec ret;
	ret.push_back(m_model);
	return ret;
}

void BallActor::Update(float realTime, float gameTime )
{
	FCActor::Update( realTime, gameTime );
}
