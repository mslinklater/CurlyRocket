//
//  MSTile.h
//  MinesweeperCore
//
//  Created by Martin Linklater on 28/09/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#ifndef __MinesweeperCore__MSTile__
#define __MinesweeperCore__MSTile__

#include <iostream>
#include <vector>

// status flags

static const uint32_t kMSTile_Inactive		= 1 << 0;
static const uint32_t kMSTile_Mine			= 1 << 1;
static const uint32_t kMSTile_Flag			= 1 << 2;
static const uint32_t kMSTile_Hidden		= 1 << 3;

static const uint32_t kMSTile_Neighbor_1	= 1 << 4;
static const uint32_t kMSTile_Neighbor_2	= 1 << 5;
static const uint32_t kMSTile_Neighbor_3	= 1 << 6;
static const uint32_t kMSTile_Neighbor_4	= 1 << 7;
static const uint32_t kMSTile_Neighbor_5	= 1 << 8;
static const uint32_t kMSTile_Neighbor_6	= 1 << 9;
static const uint32_t kMSTile_Neighbor_7	= 1 << 10;
static const uint32_t kMSTile_Neighbor_8	= 1 << 11;

static const uint32_t kMSTile_Treasure		= 1 << 12;

static const uint32_t kMSTile_Neighbor_Any		=	kMSTile_Neighbor_1 |
													kMSTile_Neighbor_2 |
													kMSTile_Neighbor_3 |
													kMSTile_Neighbor_4 |
													kMSTile_Neighbor_5 |
													kMSTile_Neighbor_6 |
													kMSTile_Neighbor_7 |
													kMSTile_Neighbor_8;

typedef uint32_t MSTile;

#define MSTile_HIDE(n) n |= kMSTile_Hidden
#define MSTile_UNHIDE(n) n &= (0xffffffff ^ kMSTile_Hidden)
#define MSTile_PLANTFLAG(n) n |= kMSTile_Flag
#define MSTile_REMOVEFLAG(n) n &= (0xffffffff ^ kMSTile_Flag)
#define MSTile_HASFLAG(n) n & kMSTile_Flag
#define MSTile_HIDDEN(n) n & kMSTile_Hidden

#endif /* defined(__MinesweeperCore__MSTile__) */
