//
//  PlatformGameInterface.h
//  CR3
//
//  Created by Martin Linklater on 15/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef CR3_PlatformGameInterface_h
#define CR3_PlatformGameInterface_h

#include "GameTypes.h"

extern void plt_FullBoard_SetImageForTile( std::string filename, eDisplayTile tile );
extern void plt_ScrollingBoard_SetImageForTile( std::string filename, eDisplayTile tile );

#endif
