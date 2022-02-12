//
//  RoundsView.h
//  CR1
//
//  Created by Martin Linklater on 01/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_RoundsView_h
#define CR1_RoundsView_h

class RoundsView
{
public:
	RoundsView()
	{}
	
	virtual ~RoundsView()
	{}

	virtual void SetNumRounds( uint16_t num )
	{
		m_numRounds = num;
	}
	
	virtual void SetCurrentRound( uint16_t num )
	{
		m_currentRound = num;
	}
	
protected:
	uint16_t	m_numRounds;
	uint16_t	m_currentRound;
};

typedef std::shared_ptr<RoundsView> RoundsViewRef;

extern RoundsViewRef plt_RoundsView_Create( std::string name, std::string parent );

#endif
