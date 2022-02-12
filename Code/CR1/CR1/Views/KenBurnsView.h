//
//  KenBurnsView.h
//  CR1
//
//  Created by Martin Linklater on 28/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_KenBurnsView_h
#define CR1_KenBurnsView_h

#include "Shared/Core/FCCore.h"

class KenBurnsView
{
public:
	KenBurnsView()
	{}
	
	virtual ~KenBurnsView(){}
	
	virtual void StartPrimaryFrameAnimation( float seconds ){}
	virtual void SetSecondaryImage( std::string filename ){}
};

typedef std::shared_ptr<KenBurnsView> KenBurnsViewRef;

extern KenBurnsViewRef plt_KenBurnsView_Create( std::string name, std::string parent );

#endif
