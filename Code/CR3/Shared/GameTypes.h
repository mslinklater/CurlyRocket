//
//  GameTypes.h
//  CR3
//
//  Created by Martin Linklater on 04/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR3_GameTypes_h
#define CR3_GameTypes_h

#include <string>
#include "Shared/Core/FCCore.h"

enum eGameType
{
	kGameTypeEasy = 0,
	kGameTypeMedium,
	kGameTypeHard,
	kGameTypeExtreme
};

enum eDisplayTile {
	kDisplayTile_Hidden = 1,
	kDisplayTile_Flagged,
	kDisplayTile_Number1,
	kDisplayTile_Number2,
	kDisplayTile_Number3,
	kDisplayTile_Number4,
	kDisplayTile_Number5,
	kDisplayTile_Number6,
	kDisplayTile_Number7,
	kDisplayTile_Number8,
	kDisplayTile_Bomb,
	kDisplayTile_Empty,
	kDisplayTile_Unused,
	kDisplayTile_Treasure
};

extern std::string kNotification_BoardInit;
extern std::string kNotification_TileChanged;

class NotificationBoardInitInfo : public FCNotificationInfo
{
public:
	NotificationBoardInitInfo()
	: FCNotificationInfo()
	{
	}
	
	virtual ~NotificationBoardInitInfo()
	{
	}
	
	uint32_t	m_numCols;
	uint32_t	m_numRows;
};

class NotificationTileChangedInfo : public FCNotificationInfo
{
public:
	NotificationTileChangedInfo()
	: FCNotificationInfo()
	{}
	
	virtual ~NotificationTileChangedInfo()
	{}
	
	eDisplayTile	tile;
	uint32_t		col;
	uint32_t		row;
};

#endif
