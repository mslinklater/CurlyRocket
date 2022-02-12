//
//  Board.h
//  CR3
//
//  Created by Martin Linklater on 12/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR3_Board_h
#define CR3_Board_h

#include <iostream>
#include <vector>

#include "GameTypes.h"
#include "json/json.h"

class MSManager;

class Board
{
public:
	Board( MSManager* pManager );
	virtual ~Board();

	typedef std::vector<eDisplayTile>	TileVec;
	typedef TileVec::iterator			TileVecIter;
	
	void Init( uint32_t numColumns, uint32_t numRows );
	
	void TileChanged( uint32_t col, uint32_t row, eDisplayTile tile );
	eDisplayTile ContentsOfTile( uint32_t col, uint32_t row );

	void		SetNumFlagsLeft( uint32_t num );
	uint32_t	GetNumFlagsLeft();
	
	// serialisation
	
	Json::Value	SerialiseToJSON();
	void DeserialiseFromJSON( Json::Value& json );
	
private:
	MSManager*	m_pManager;
	
	uint32_t	m_numTiles;
	uint32_t	m_numFlagsLeft;
	
	TileVec		m_tiles;
	uint32_t	m_cols;
	uint32_t	m_rows;
};

#endif
