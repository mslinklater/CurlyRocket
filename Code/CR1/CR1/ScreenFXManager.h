//
//  ScreenFXManager.h
//  CR1
//
//  Created by Martin Linklater on 28/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_ScreenFXManager_h
#define CR1_ScreenFXManager_h

#include "Shared/Core/FCCore.h"
#include "Views/KenBurnsView.h"
#include "Views/TopFXView.h"

class ScreenFXManager
{
public:
	
	ScreenFXManager();
	virtual ~ScreenFXManager();
	
	static ScreenFXManager* Instance();
	
	void	Update( float dt );
	void	AddPicture( std::string filename );
	void	StartBackgroundPan( float seconds );
	void	SetNextBackgroundImage( std::string filename );
	
private:
	KenBurnsViewRef			m_pBackgroundView;
	TopFXViewRef			m_pTopFXView;
	FCDataMapByString		m_backgroundImages;
	FCVector2f				m_screenSize;
};

typedef std::shared_ptr<ScreenFXManager> ScreenFXManagerRef;

#endif
