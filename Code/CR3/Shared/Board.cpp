//
//  Board.cpp
//  CR3
//
//  Created by Martin Linklater on 12/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include "Board.h"
#include "Shared/Lua/FCLua.h"
#include "MS/MSManager.h"
#include "GameTypes.h"

static Board* s_pInstance = 0;

static int lua_Init( lua_State* _state )
{
	FC_LUA_FUNCDEF("Board.Init()");
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	s_pInstance->Init(lua_tointeger(_state, 1), lua_tointeger(_state, 2));
	
	return 0;
}

static int lua_TileChanged( lua_State* _state )
{
	FC_LUA_FUNCDEF("Board.TileChanged()");
	FC_LUA_ASSERT_NUMPARAMS(3);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(3, LUA_TNUMBER);
	
	s_pInstance->TileChanged(lua_tointeger(_state, 1), lua_tointeger(_state, 2), (eDisplayTile)lua_tointeger(_state, 3));
	
	return 0;
}

static int lua_ContentsOfTile( lua_State* _state )
{
	FC_LUA_FUNCDEF("Board.ContentsOfTile()");
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);

	lua_pushinteger(_state, s_pInstance->ContentsOfTile(lua_tointeger(_state, 1), lua_tointeger(_state, 2)));

	return 1;
}

static int lua_Serialise( lua_State* _state )
{
	FC_LUA_FUNCDEF("Board.Serialise()");
	FC_LUA_ASSERT_NUMPARAMS(0);
	
	Json::Value json = s_pInstance->SerialiseToJSON();
	std::string str = Json::FastWriter().write(json);
	
	lua_pushstring( _state, str.c_str() );
	
	return 1;
}

static int lua_Deserialise( lua_State* _state )
{
	FC_LUA_FUNCDEF("Board.Deserialise()");
	FC_LUA_ASSERT_NUMPARAMS( 1 );
	FC_LUA_ASSERT_TYPE( 1, LUA_TSTRING );
	
	Json::Value json;
	Json::Reader reader;
	
	const char* str = lua_tostring(_state, 1);
	
	reader.parse(str, json);
	
	s_pInstance->DeserialiseFromJSON( json );
	
	return 0;
}

static int lua_GetNumFlagsLeft( lua_State* _state )
{
	FC_LUA_FUNCDEF("Board.GetNumFlagsLeft()");
	FC_LUA_ASSERT_NUMPARAMS(0);
	
	lua_pushinteger(_state, s_pInstance->GetNumFlagsLeft());
	return 1;
}

static int lua_SetNumFlagsLeft( lua_State* _state )
{
	FC_LUA_FUNCDEF("Board.SetNumFlagsLeft()");
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	
	s_pInstance->SetNumFlagsLeft( lua_tointeger(_state, 1));
	return 0;
}

Board::Board( MSManager* pManager )
{
	s_pInstance = this;
	m_pManager = pManager;

	FCLua::Instance()->CoreVM()->CreateGlobalTable("Board");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_Init, "Board.Init");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_TileChanged, "Board.TileChanged");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_ContentsOfTile, "Board.ContentsOfTile");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_Serialise, "Board.Serialise");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_Deserialise, "Board.Deserialise");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_GetNumFlagsLeft, "Board.GetNumFlagsLeft");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetNumFlagsLeft, "Board.SetNumFlagsLeft");
}

Board::~Board()
{
	FCLua::Instance()->CoreVM()->RemoveCFunction("Board.TileChanged");
	FCLua::Instance()->CoreVM()->RemoveCFunction("Board.Init");
	FCLua::Instance()->CoreVM()->DestroyGlobalTable("Board");
}

void Board::Init(uint32_t numColumns, uint32_t numRows)
{
	// clear all old data
	
	m_tiles.clear();
	m_numTiles = numColumns * numRows;
	m_cols = numColumns;
	m_rows = numRows;
	
	// alloc new data and set it all to hidden
	
	for (int i = 0; i < m_numTiles; i++) {
		m_tiles.push_back( kDisplayTile_Hidden );
	}
	
	FCNotification clearedNote;
	clearedNote.notification = kNotification_BoardInit;
	NotificationBoardInitInfo* info = new NotificationBoardInitInfo;
	
	info->m_numCols = numColumns;
	info->m_numRows = numRows;
	clearedNote.info = FCSharedPtr<FCNotificationInfo>( info );
	
	FCNotificationManager::Instance()->SendNotification( clearedNote );
}

void Board::TileChanged(uint32_t col, uint32_t row, eDisplayTile tile)
{
	m_tiles[ row * m_cols + col ] = tile;
	
	FCNotification tileChangedNote;
	tileChangedNote.notification = kNotification_TileChanged;
	NotificationTileChangedInfo* info = new NotificationTileChangedInfo;
	
	info->col = col;
	info->row = row;
	info->tile = tile;
	tileChangedNote.info = FCSharedPtr<FCNotificationInfo>( info );
	FCNotificationManager::Instance()->SendNotification( tileChangedNote );
}

eDisplayTile Board::ContentsOfTile(uint32_t col, uint32_t row)
{
	return m_tiles[ row * m_cols + col ];
}

uint32_t Board::GetNumFlagsLeft()
{
	return m_numFlagsLeft;
}

void Board::SetNumFlagsLeft(uint32_t num)
{
	m_numFlagsLeft = num;
}

Json::Value Board::SerialiseToJSON()
{
	Json::Value ret;
	
	ret["numTiles"] = m_numTiles;
	ret["cols"] = m_cols;
	ret["rows"] = m_rows;
	ret["numFlagsLeft"] = m_numFlagsLeft;
	
	Json::Value array(Json::arrayValue);
	
	for (TileVecIter i = m_tiles.begin(); i != m_tiles.end(); i++) {
		uint32_t val = *i;
		array.append(Json::Value(val));
	}

	ret["tiles"] = array;
	
	return ret;
}

void Board::DeserialiseFromJSON( Json::Value& json )
{
	m_numTiles = json["numTiles"].asInt();
	m_cols = json["cols"].asInt();
	m_rows = json["rows"].asInt();
	m_numFlagsLeft = json["numFlagsLeft"].asInt();
	
	m_tiles.clear();
	
	Json::Value array = json["tiles"];

	for (uint32_t i = 0; i < array.size(); i++) {
		eDisplayTile tile = (eDisplayTile)array[i].asInt();
		m_tiles.push_back( tile );
	}
}
