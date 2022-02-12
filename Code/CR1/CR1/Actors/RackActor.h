//
//  RackActor.h
//  CR1
//
//  Created by Martin Linklater on 31/05/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_RackActor_h
#define CR1_RackActor_h

#include "FCActor.h"
#include "Views/RackView.h"

class RackActor : public FCActor
{
public:
	static FCActorRef Create();
	std::string Class(){ return "RackActor"; }
	bool NeedsUpdate();
	void Update( float realTime, float gameTime );
	
	void Clear();
	void FillWithColors( FCStringVector colors );
	std::string	GetCurrentColor();
	bool RemoveCurrent();
	
private:
	FCStringVector	m_colors;
	uint32_t		m_currentIndex;
};

typedef std::shared_ptr<RackActor> RackActorRef;

#endif
