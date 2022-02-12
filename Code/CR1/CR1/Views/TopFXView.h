//
//  TopFXView.h
//  CR1
//
//  Created by Martin Linklater on 28/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_TopFXView_h
#define CR1_TopFXView_h

#include "Shared/Core/FCCore.h"

class TopFXView
{
public:
	TopFXView()
	{}
	
	virtual ~TopFXView(){}
	
};

typedef std::shared_ptr<TopFXView> TopFXViewRef;

extern TopFXViewRef plt_TopFXView_Create( std::string name, std::string parent );

#endif
