//
//  BallActor.h
//  CR1
//
//  Created by Martin Linklater on 04/02/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef BALLACTOR_H
#define BALLACTOR_H

#include "Shared/Framework/Actor/FCActor.h"

enum eBallColor {
	kBallColorRed = 1,
	kBallColorBlue,
	kBallColorGreen,
	kBallColorYellow
};


class BallActor : public FCActor
{
public:
	static FCActorRef Create();
	
	BallActor(){}
	virtual ~BallActor(){}
	
	std::string Class(){ return "BallActor"; }
	bool NeedsUpdate();
	bool NeedsRender();
	bool RespondsToTapGesture();
	FCModelRefVec RenderGather();
	void Update( float realTime, float gameTime );
	
	void SetColor( eBallColor color ){ m_color = color; }
	eBallColor	Color(){ return m_color; }
private:
	eBallColor m_color;
};

typedef std::shared_ptr<BallActor> BallActorRef;

#endif // BALLACTOR_H

