//
//  MSManager.cpp
//  MinesweeperCore
//
//  Created by Martin Linklater on 28/09/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#include <sstream>

#include "MSManager.h"
#include "Shared/Lua/FCLua.h"
#include "GameTypes.h"

static MSManager* s_pInstance = 0;

// Lua

static int lua_CreateGame( lua_State* _state )
{
	FC_LUA_FUNCDEF("MSManager.CreateGame()");
	FC_LUA_ASSERT_NUMPARAMS(7);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(3, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(4, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(5, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(6, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(7, LUA_TNUMBER);

	s_pInstance->CreateGame((uint32_t)lua_tointeger(_state, 1),
							(uint32_t)lua_tointeger(_state, 2),
							lua_tointeger(_state, 3),
							lua_tointeger(_state, 4),
							lua_tointeger(_state, 5),
							lua_tointeger(_state, 6),
							lua_tointeger(_state, 7)
							);
	return 0;
}

static int lua_TileSelected( lua_State* _state )
{
	FC_LUA_FUNCDEF("MSManager.TileSelected()");
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	s_pInstance->LocationSelected( lua_tointeger(_state, 1), lua_tointeger(_state, 2));
	
	return 0;
}

static int lua_ToggleFlag( lua_State* _state )
{
	FC_LUA_FUNCDEF("MSManager.ToggleFlag()");
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	s_pInstance->ToggleFlag( lua_tointeger(_state, 1), lua_tointeger(_state, 2));
	
	return 0;
}

static int lua_HideLocation( lua_State* _state )
{
	FC_LUA_FUNCDEF("MSManager.HideLocation()");
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	FC_LUA_ASSERT_TYPE(2, LUA_TNUMBER);
	
	s_pInstance->HideLocation( lua_tointeger(_state, 1), lua_tointeger(_state, 2) );
	
	return 0;
}

static int lua_BombLocations( lua_State* _state)
{
	FC_LUA_FUNCDEF("MSManager.BombLocation()");
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	
	std::string luaCallback = lua_tostring(_state, 1);
	
	s_pInstance->BombLocations( luaCallback );

	return 0;
}

static int lua_Serialise( lua_State* _state )
{
	FC_LUA_FUNCDEF("MSManager.Serialise()");
	FC_LUA_ASSERT_NUMPARAMS(0);
	
	Json::Value json = s_pInstance->SerialiseToJSON();

	std::string str = Json::FastWriter().write(json);
	
	lua_pushstring( _state, str.c_str() );
	
	return 1;
}

static int lua_Deserialise( lua_State* _state )
{
	FC_LUA_FUNCDEF("MSManager.Deserialise()");
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	
	std::string str = lua_tostring(_state, 1);
	
	Json::Value json;
	Json::Reader reader;
	
	reader.parse(str, json);
	s_pInstance->DeserialiseFromJSON( json );
	
	return 0;
}

// Class Impl

MSManager::MSManager()
{
	s_pInstance = this;
}

MSManager::~MSManager()
{
	
}

void MSManager::RegisterLuaFunctions()
{
	FCLua::Instance()->CoreVM()->CreateGlobalTable("MSManager");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_CreateGame, "MSManager.CreateGame");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_TileSelected, "MSManager.TileSelected");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_ToggleFlag, "MSManager.ToggleFlag");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_HideLocation, "MSManager.HideLocation");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_BombLocations, "MSManager.BombLocations");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_Serialise, "MSManager.Serialise");
	FCLua::Instance()->CoreVM()->RegisterCFunction(lua_Deserialise, "MSManager.Deserialise");
	return;
}

void MSManager::DeregisterLuaFunctions()
{
	FCLua::Instance()->CoreVM()->RemoveCFunction("MSManager.CreateGame");
	FCLua::Instance()->CoreVM()->RemoveCFunction("MSManager.TileSelected");
	FCLua::Instance()->CoreVM()->RemoveCFunction("MSManager.ToggleFlag");
	FCLua::Instance()->CoreVM()->RemoveCFunction("MSManager.HideLocation");
	FCLua::Instance()->CoreVM()->RemoveCFunction("MSManager.BombLocations");
	FCLua::Instance()->CoreVM()->RemoveCFunction("MSManager.Serialise");
	FCLua::Instance()->CoreVM()->RemoveCFunction("MSManager.Deserialise");
	FCLua::Instance()->CoreVM()->DestroyGlobalTable("MSManager");
}

void MSManager::CreateGame( uint32_t sizeX, uint32_t sizeY, uint32_t numBombs, uint32_t seed1, uint32_t numTreasure, uint32_t reconX, uint32_t reconY )
{
	m_randZ = seed1;
	m_randW = seed1 >> 2;
	
	m_startX = reconX;
	m_startY = reconY;
	
	m_map.clear();

	MSTile tile = kMSTile_Hidden;

	// build empty row
	
	m_numBombs = numBombs;

	m_numColumns = sizeX;
	m_numRows = sizeY;
	
	TileColumn tileCol;
	
	for (uint32_t i = 0 ; i < m_numColumns ; i++) {
		tileCol.push_back( tile );
	}
	
	for (uint32_t i = 0 ; i < m_numRows ; i++) {
		m_map.push_back( tileCol );
	}
	
	// now put some bombs on there

	for (uint32_t i = 0; i < m_numBombs; ) {
		uint32_t column = Random() % m_numColumns;
		uint32_t row = Random() % m_numRows;
		uint32_t tile = m_map[column][row];
		if (!(tile & kMSTile_Mine))
		{
			m_map[column][row] |= kMSTile_Mine;
			i++;
		}
	}
	
	// now do the neighbor count pass
	
	for (uint32_t col = 0; col < m_numColumns; col++) {
		for (uint32_t row = 0; row < m_numRows; row++) {
			uint32_t numBombNeighbors = 0;
			
			// left
			if (col > 0) {
				if (m_map[col-1][row] & kMSTile_Mine) numBombNeighbors++;
			}
			// topleft
			if ( (col > 0) && (row > 0) ){
				if (m_map[col-1][row-1] & kMSTile_Mine) numBombNeighbors++;
			}
			// top
			if (row > 0) {
				if (m_map[col][row-1] & kMSTile_Mine) numBombNeighbors++;
			}
			// topright
			if ( (col < m_numColumns-1) && (row > 0) ){
				if (m_map[col+1][row-1] & kMSTile_Mine) numBombNeighbors++;
			}
			// right
			if ( (col < m_numColumns-1) ){
				if (m_map[col+1][row] & kMSTile_Mine) numBombNeighbors++;
			}
			// bottomright
			if ( (col < m_numColumns-1) && (row < m_numRows-1) ){
				if (m_map[col+1][row+1] & kMSTile_Mine) numBombNeighbors++;
			}
			// top
			if (row < m_numRows-1) {
				if (m_map[col][row+1] & kMSTile_Mine) numBombNeighbors++;
			}
			// bottomleft
			if ( (col > 0) && (row < m_numRows-1) ){
				if (m_map[col-1][row+1] & kMSTile_Mine) numBombNeighbors++;
			}
			
			switch (numBombNeighbors) {
				case 1: m_map[col][row] |= kMSTile_Neighbor_1; break;
				case 2: m_map[col][row] |= kMSTile_Neighbor_2; break;
				case 3: m_map[col][row] |= kMSTile_Neighbor_3; break;
				case 4: m_map[col][row] |= kMSTile_Neighbor_4; break;
				case 5: m_map[col][row] |= kMSTile_Neighbor_5; break;
				case 6: m_map[col][row] |= kMSTile_Neighbor_6; break;
				case 7: m_map[col][row] |= kMSTile_Neighbor_7; break;
				case 8: m_map[col][row] |= kMSTile_Neighbor_8; break;
			}
		}
	}
	
	// add treasure to empty squares
	
	LocationVec emptySquares;
	
	for (int col = 0; col < m_numColumns; col++) {
		for (int row = 0; row < m_numRows; row++) {
			uint32_t tileContents = m_map[col][row];
			if (
				!(tileContents & kMSTile_Neighbor_Any) &&
				!(tileContents & kMSTile_Mine) &&
				!((col == m_startX) && (row == m_startY))
				)
			{
				Location loc;
				loc.col = col;
				loc.row = row;
				emptySquares.push_back(loc);
			}
		}
	}
	
	uint32_t numEmpties = emptySquares.size();
	
	for (int i = 0; i < numTreasure; i++) {
		uint32_t rnd = rand() % numEmpties;
		uint32_t col = emptySquares[rnd].col;
		uint32_t row = emptySquares[rnd].row;
		m_map[col][row] |= kMSTile_Treasure;
	}
	
//	Print();
}

void MSManager::ImportMap( std::string name )
{
	
}

Json::Value MSManager::SerialiseToJSON()
{
	Json::Value ret;
	
	ret["numColumns"] = m_numColumns;
	ret["numRows"] = m_numRows;
	ret["numBombs"] = m_numBombs;
	
	Json::Value array(Json::arrayValue);

	for (int row = 0; row < m_numRows; row++) {
		for (int col = 0; col < m_numColumns; col++) {
			array.append( Json::Value( m_map[col][row] ) );
		}
	}
	
	ret["map"] = array;

	return ret;
}

void MSManager::DeserialiseFromJSON(Json::Value json)
{
	m_numColumns = json["numColumns"].asInt();
	m_numRows = json["numRows"].asInt();
	m_numBombs = json["numBombs"].asInt();
	
	Json::Value array = json["map"];
	uint32_t i = 0;

	m_map.clear();
	
	TileColumn tileCol;
	
	for (uint32_t i = 0 ; i < m_numColumns ; i++) {
		tileCol.push_back( kMSTile_Hidden );
	}
	
	for (uint32_t i = 0 ; i < m_numRows ; i++) {
		m_map.push_back( tileCol );
	}

	for (int row = 0; row < m_numRows; row++) {
		for (int col = 0; col < m_numColumns; col++) {
			m_map[col][row] = array[i++].asInt();
		}
	}
}

void MSManager::Print()
{
	for (int row = 0; row < m_numRows; row++) {
		for (int col = 0; col < m_numColumns; col++) {
			uint32_t tile = m_map[col][row];

			if (tile & kMSTile_Hidden) {
				std::cout << "X";
			} else {
				
				if (tile & kMSTile_Flag)
					std::cout << ">";
				else if (tile & kMSTile_Neighbor_1) std::cout << "1";
				else if (tile & kMSTile_Neighbor_2) std::cout << "2";
				else if (tile & kMSTile_Neighbor_3) std::cout << "3";
				else if (tile & kMSTile_Neighbor_4) std::cout << "4";
				else if (tile & kMSTile_Neighbor_5) std::cout << "5";
				else if (tile & kMSTile_Neighbor_6) std::cout << "6";
				else if (tile & kMSTile_Neighbor_7) std::cout << "7";
				else if (tile & kMSTile_Neighbor_8) std::cout << "8";
				else
					std::cout << ".";
			}
		}
		
		std::cout << "   ";
		
		for (int col = 0; col < m_numColumns; col++) {
			uint32_t tile = m_map[col][row];
			
			if (tile & kMSTile_Inactive) {
				std::cout << " ";
			} else {
				if (tile & kMSTile_Mine) {
					std::cout << "*";
				} else if(tile & kMSTile_Treasure) {
					std::cout << "T";
				} else {
					std::cout << ".";
				}
			}
		}
		std::cout << std::endl;
	}
	
	std::cout << std::endl;
}

uint32_t MSManager::NumNeighborsWithFlag( Location loc, uint32_t flag )
{
	uint32_t ret = 0;
	
	if ( (loc.col > 0) && (loc.row > 0) ) if (m_map[loc.col-1][loc.row-1] & flag) ret++;
	if ( (loc.col > 0) ) if (m_map[loc.col-1][loc.row] & flag) ret++;
	if ( (loc.col > 0) && (loc.row < m_numRows-1) ) if (m_map[loc.col-1][loc.row+1] & flag) ret++;
	
	if ( (loc.row > 0) ) if (m_map[loc.col][loc.row-1] & flag) ret++;
	if ( (loc.row < m_numRows-1) ) if (m_map[loc.col][loc.row+1] & flag) ret++;
	
	if ( (loc.col < m_numColumns-1) && (loc.row > 0) ) if (m_map[loc.col+1][loc.row-1] & flag) ret++;
	if ( (loc.col < m_numColumns-1) ) if (m_map[loc.col+1][loc.row] & flag) ret++;
	if ( (loc.col < m_numColumns-1) && (loc.row < m_numRows-1) ) if (m_map[loc.col+1][loc.row+1] & flag) ret++;
	
	return ret;
}

uint32_t MSManager::NumNeighbors(uint32_t tile)
{
	if (tile & kMSTile_Neighbor_1) return 1;
	if (tile & kMSTile_Neighbor_2) return 2;
	if (tile & kMSTile_Neighbor_3) return 3;
	if (tile & kMSTile_Neighbor_4) return 4;
	if (tile & kMSTile_Neighbor_5) return 5;
	if (tile & kMSTile_Neighbor_6) return 6;
	if (tile & kMSTile_Neighbor_7) return 7;
	if (tile & kMSTile_Neighbor_8) return 8;
	return 0;
}

MSManager::LocationVec MSManager::NeighborsWithFlag(MSManager::Location loc, uint32_t flag)
{
	LocationVec ret;
	
	if ( (loc.col > 0) && (loc.row > 0) )			if (m_map[loc.col-1][loc.row-1] & flag)	ret.push_back(Location(loc.col-1, loc.row-1));
	if ( (loc.col > 0) )							if (m_map[loc.col-1][loc.row] & flag)	ret.push_back(Location(loc.col-1, loc.row));
	if ( (loc.col > 0) && (loc.row < m_numRows-1) ) if (m_map[loc.col-1][loc.row+1] & flag) ret.push_back(Location(loc.col-1, loc.row+1));
	
	if ( (loc.row > 0) )			if (m_map[loc.col][loc.row-1] & flag)	ret.push_back( Location(loc.col, loc.row-1));
	if ( (loc.row < m_numRows-1) )	if (m_map[loc.col][loc.row+1] & flag)	ret.push_back( Location(loc.col, loc.row+1));
	
	if ( (loc.col < m_numColumns-1) && (loc.row > 0) )				if (m_map[loc.col+1][loc.row-1] & flag)	ret.push_back( Location(loc.col+1, loc.row-1));
	if ( (loc.col < m_numColumns-1) )								if (m_map[loc.col+1][loc.row] & flag)	ret.push_back( Location(loc.col+1, loc.row));
	if ( (loc.col < m_numColumns-1) && (loc.row < m_numRows-1) )	if (m_map[loc.col+1][loc.row+1] & flag)	ret.push_back( Location(loc.col+1, loc.row+1));

	return ret;
}

void MSManager::UnHide( uint32_t col, uint32_t row )
{
	uint32_t tile = m_map[col][row];
	
	eDisplayTile displayTile = kDisplayTile_Empty;
	if( tile & kMSTile_Neighbor_1) displayTile = kDisplayTile_Number1;
	if( tile & kMSTile_Neighbor_2) displayTile = kDisplayTile_Number2;
	if( tile & kMSTile_Neighbor_3) displayTile = kDisplayTile_Number3;
	if( tile & kMSTile_Neighbor_4) displayTile = kDisplayTile_Number4;
	if( tile & kMSTile_Neighbor_5) displayTile = kDisplayTile_Number5;
	if( tile & kMSTile_Neighbor_6) displayTile = kDisplayTile_Number6;
	if( tile & kMSTile_Neighbor_7) displayTile = kDisplayTile_Number7;
	if( tile & kMSTile_Neighbor_8) displayTile = kDisplayTile_Number8;
	if( tile & kMSTile_Mine) displayTile = kDisplayTile_Bomb;
	
	FCLua::Instance()->CoreVM()->CallFuncWithSig( "TileChanged", true, "iii>", col, row, displayTile );
}

void MSManager::HideLocation(uint32_t col, uint32_t row)
{
	MSTile_HIDE( m_map[col][row]);
	FCLua::Instance()->CoreVM()->CallFuncWithSig( "TileChanged", true, "iii>", col, row, kDisplayTile_Hidden );
	
	if (MSTile_HASFLAG( m_map[col][row])) {
		MSTile_REMOVEFLAG( m_map[col][row]);
	}
}

bool MSManager::RevealLocation( MSManager::Location loc )
{
	bool ret = false;
	uint32_t tile = m_map[loc.col][loc.row];
	
	if (!(tile & kMSTile_Hidden) ) {
		return false;
	}
	
	MSTile_UNHIDE(m_map[loc.col][loc.row]);

	UnHide(loc.col, loc.row);
	
	// if empty, unhide the 8 around this one
	
	if ( !(tile & kMSTile_Neighbor_Any) )
	{
		ret = true;
		
		if ( (loc.col > 0) && (loc.row > 0) )  {
			if (MSTile_HIDDEN(m_map[loc.col-1][loc.row-1])) {
				m_revealQueue.push_back( Location( loc.col-1, loc.row-1 ) );
			}
		}
		
		if ( (loc.col > 0) ) {
			if (MSTile_HIDDEN(m_map[loc.col-1][loc.row])) {
				m_revealQueue.push_back( Location( loc.col-1, loc.row ) );
			}
		}
		
		if ( (loc.col > 0) && (loc.row < m_numRows-1) ) {
			if (MSTile_HIDDEN(m_map[loc.col-1][loc.row+1])) {
				m_revealQueue.push_back( Location( loc.col-1, loc.row+1 ) );
			}
		}
		
		if ( (loc.row > 0) ) {
			if (MSTile_HIDDEN(m_map[loc.col][loc.row-1])) {
				m_revealQueue.push_back( Location( loc.col, loc.row-1 ) );
			}
		}

		if ( (loc.row < m_numRows-1) ) {
			if (MSTile_HIDDEN(m_map[loc.col][loc.row+1])) {
				m_revealQueue.push_back( Location( loc.col, loc.row+1 ) );
			}			
		}

		if ( (loc.col < m_numColumns-1) && (loc.row > 0) ) {
			if (MSTile_HIDDEN(m_map[loc.col+1][loc.row-1])) {
				m_revealQueue.push_back( Location( loc.col+1, loc.row-1 ) );
			}
		}

		if ( (loc.col < m_numColumns-1) ) {
			if (MSTile_HIDDEN(m_map[loc.col+1][loc.row])) {
				m_revealQueue.push_back( Location( loc.col+1, loc.row ) );
			}
		}

		if ( (loc.col < m_numColumns-1) && (loc.row < m_numRows-1) ) {
			if (MSTile_HIDDEN(m_map[loc.col+1][loc.row+1])) {
				m_revealQueue.push_back( Location( loc.col+1, loc.row+1 ) );
			}
		}
	}
	else{
		// this tile has neighbors
		m_locationsWithNeighbors.push_back( loc );
	}
	
//	Print();

//	int queueSize = m_revealQueue.size();
	
	
	return ret;
}

bool MSManager::CheckNeighborCandidates()
{
	bool ret = false;
	
	for (LocationListIter i = m_locationsWithNeighbors.begin(); i != m_locationsWithNeighbors.end(); i++)
	{
		uint32_t numNeighbors = NumNeighbors( m_map[i->col][i->row]);
		uint32_t numHiddenNeighbors = NumNeighborsWithFlag( *i, kMSTile_Hidden );
		uint32_t numFlaggedNeighbors = NumNeighborsWithFlag( *i, kMSTile_Flag );

		if (numHiddenNeighbors) {
			if (numNeighbors == (numHiddenNeighbors + numFlaggedNeighbors)) {
				// flag the hidden neighbors
				
				LocationVec toBeFlagged = NeighborsWithFlag( *i, kMSTile_Hidden );
				
				for (LocationVecIter j = toBeFlagged.begin(); j != toBeFlagged.end(); j++) {
					MSTile_UNHIDE( m_map[j->col][j->row]);
					MSTile_PLANTFLAG( m_map[j->col][j->row]);
					ret = true;
//					Print();
				}
			}
			
			if (numFlaggedNeighbors == numNeighbors) {
				// reveal all the hidden squares
				
				LocationVec toBeRevealed = NeighborsWithFlag( *i, kMSTile_Hidden);

				for (LocationVecIter j = toBeRevealed.begin(); j != toBeRevealed.end(); j++) {
					m_revealQueue.push_back( *j );
					ret = true;
				}
			}
		}
		
	}
	return ret;
}

void MSManager::LocationSelected( uint32_t col, uint32_t row )
{
	if (MSTile_HASFLAG(m_map[col][row])) {
		return;
	}
	
	if (m_map[col][row] & kMSTile_Treasure) {
//	if (1) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig( "FoundTreasure", true, ">" );
		m_map[col][row] &= 0xffffffff ^ kMSTile_Treasure;	// remove treasure from board
	}
	
	Location loc;
	loc.col = col;
	loc.row = row;
	
	m_revealQueue.push_back( loc );
	
	do {
		Location loc( m_revealQueue.front() );
		m_revealQueue.pop_front();
		
		RevealLocation(loc);
	} while (m_revealQueue.size());
	
	if (Solved()) {
//	if (1) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig( "Solved", true, ">" );
	}
}

bool MSManager::Solved()
{
	uint32_t numCounted = 0;
	uint32_t numHidden = 0;
	
	for (uint32_t row = 0; row < m_numRows; row++) {
		for (uint32_t col = 0; col < m_numColumns; col++) {
			if ( MSTile_HASFLAG(m_map[col][row]) ) {
				numCounted++;
			}
			if (( MSTile_HIDDEN(m_map[col][row]) ) && !(MSTile_HASFLAG(m_map[col][row]))) {
				numHidden++;
			}
		}
	}

	uint32_t numFlagsLeft = m_numBombs - numCounted;

	if (numHidden == numFlagsLeft) {
		return true;
	}
	
	return false;
}

void MSManager::ToggleFlag( uint32_t col, uint32_t row )
{
	if (MSTile_HASFLAG( m_map[col][row]))
	{
		MSTile_REMOVEFLAG( m_map[col][row]);
		
		if (MSTile_HIDDEN( m_map[col][row])) {
			FCLua::Instance()->CoreVM()->CallFuncWithSig( "TileChanged", true, "iii>", col, row, kDisplayTile_Hidden );
		} else {
			UnHide(col, row);
		}
	}
	else
	{
		FCLua::Instance()->CoreVM()->CallFuncWithSig( "TileChanged", true, "iii>", col, row, kDisplayTile_Flagged );
		MSTile_PLANTFLAG( m_map[col][row] );
	}
	
	if (Solved()) {
		FCLua::Instance()->CoreVM()->CallFuncWithSig( "Solved", true, ">" );
	}

}

bool MSManager::Solve()
{
	m_locationsWithNeighbors.clear();
	
	// Find a valid recon spot

	Location reconLocation;
	uint32_t tile;
	
	do {
		reconLocation.col = rand() % m_numColumns;
		reconLocation.row = rand() % m_numRows;
		
		tile = m_map[reconLocation.col][reconLocation.row];
	} while ( ( tile & kMSTile_Mine ) || ( tile & kMSTile_Neighbor_Any ) );
	
	m_startX = reconLocation.col;
	m_startY = reconLocation.row;
	
	m_revealQueue.push_back( reconLocation );
	
	// iterate over process list until no progress can be made or list is empty
	
	bool progress;
	
	do {
		progress = false;
		// reveal loop
		
		if (m_revealQueue.size())
		{
			do {
				Location loc( m_revealQueue.front() );
				m_revealQueue.pop_front();
				
				RevealLocation(loc);
			} while (m_revealQueue.size());
		}
		
		progress |= CheckNeighborCandidates();
		
	} while (progress);
	
	// If list is empty, the map is solvable
	
	for (int x = 0; x < m_numColumns; x++) {
		for (int y = 0; y < m_numRows; y++) {
			if (MSTile_HIDDEN(m_map[x][y])) {
				return false;
			}
		}
	}
	
	return true;
}

uint32_t MSManager::Random()
{
	m_randZ = 36969 * (m_randZ & 65535) + (m_randZ >> 16);
	m_randW = 18000 * (m_randW & 65535) + (m_randW >> 16);
	return (m_randZ << 16) + m_randW;
}

void MSManager::BombLocations( std::string luaCallback )
{
	for (int row = 0; row < m_numRows; row++) {
		for (int col = 0; col < m_numColumns; col++) {
			if (m_map[col][row] & kMSTile_Mine) {
				FCLua::Instance()->CoreVM()->CallFuncWithSig( luaCallback, true, "ii>", col, row );
			}
		}
	}
}
