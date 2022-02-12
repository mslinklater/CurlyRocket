//
//  MSManager.h
//  MinesweeperCore
//
//  Created by Martin Linklater on 28/09/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef __MinesweeperCore__MSManager__
#define __MinesweeperCore__MSManager__

#include <iostream>
#include <string>
#include <deque>
#include <list>
#include <set>

#include "MSTypes.h"
#include "MSTile.h"

#include "json/json.h"

typedef std::vector<MSTile> TileColumn;
typedef TileColumn::iterator TileColumnIter;
typedef TileColumn::const_iterator TileColumnConstIter;

typedef std::vector<TileColumn> TileMap;
typedef TileMap::iterator TileMapIter;
typedef TileMap::const_iterator TileMapConstIter;

class MSManager {
public:
	MSManager();
	virtual ~MSManager();
	
	void RegisterLuaFunctions();
	void DeregisterLuaFunctions();
	
	void CreateGame( uint32_t sizeX,
					uint32_t sizeY,
					uint32_t numBombs,
					uint32_t seed1,
					uint32_t numTreasure,
					uint32_t reconX,
					uint32_t reconY
					);
	void ImportMap( std::string name );	/// Name of TILED data file
	void Print();
	
	bool Solve();

	void LocationSelected( uint32_t col, uint32_t row );
	void ToggleFlag( uint32_t col, uint32_t row );
	void HideLocation( uint32_t col, uint32_t row );
	
	void BombLocations( std::string luaCallback );
	
	Json::Value	SerialiseToJSON();
	void DeserialiseFromJSON( Json::Value json );
	
	uint32_t	StartX(){ return m_startX; }
	uint32_t	StartY(){ return m_startY; }
	uint32_t	SizeX(){ return m_numColumns; }
	uint32_t	SizeY(){ return m_numRows; }
	
private:
	
	void UnHide( uint32_t col, uint32_t row );
	bool Solved();
	
	TileMap	m_map;
	
	struct Location {
		Location(){}
		Location( uint32_t _col, uint32_t _row )
		: col(_col)
		, row(_row)
		{}
		
		uint32_t col;
		uint32_t row;
	};

	uint32_t Random();
	
	typedef std::vector<Location> LocationVec;
	typedef LocationVec::iterator LocationVecIter;

	typedef std::deque<Location> LocationQueue;
	
	typedef std::list<Location> LocationList;
	typedef LocationList::iterator LocationListIter;
	
	LocationList	m_locationsWithNeighbors;
	LocationQueue	m_revealQueue;

	bool RevealLocation( Location loc );	// true means progress was made
	bool CheckNeighborCandidates();
	
	uint32_t NumNeighborsWithFlag( Location loc, uint32_t flag );
	uint32_t NumNeighbors( uint32_t tile );
	LocationVec NeighborsWithFlag( Location loc, uint32_t flag );
	
	uint32_t m_numColumns;
	uint32_t m_numRows;
	uint32_t m_numBombs;
	
	uint32_t m_startX;
	uint32_t m_startY;
	
	uint32_t m_randZ;
	uint32_t m_randW;
};

#endif /* defined(__MinesweeperCore__MSManager__) */
