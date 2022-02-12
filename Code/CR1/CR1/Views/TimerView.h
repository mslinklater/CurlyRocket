//
//  TimerView.h
//  CR1
//
//  Created by Martin Linklater on 01/06/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#ifndef CR1_TimerView_h
#define CR1_TimerView_h

class TimerView
{
public:
	TimerView(){}
	virtual ~TimerView(){}
	
	virtual void SetTotal( float time )
	{
		m_total = time;
	}
	virtual void SetRemaining( float time )
	{
		m_remaining = time;
	}
protected:
	float	m_total;
	float	m_remaining;
};

typedef std::shared_ptr<TimerView> TimerViewRef;

extern TimerViewRef plt_TimerView_Create( std::string name, std::string parent );

#endif
