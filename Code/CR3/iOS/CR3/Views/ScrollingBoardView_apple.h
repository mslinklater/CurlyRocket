//
//  ScrollingBoardView_apple.h
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"
#include "GameTypes.h"

@interface ScrollingBoardView_apple : UIScrollView <FCManagedView_apple> {
	
	// Properties
	
	NSString*	_managedViewName;
	NSString*	_tapFunction;
	NSString*	_pressFunction;
	uint32_t	_numCols;
	uint32_t	_numRows;
	NSString*	_backgroundImage;
	
	// Members
	
	UITapGestureRecognizer* mTapRecognizer;
	UILongPressGestureRecognizer* mPressRecognizer;
	NSMutableArray*			mImageViewArray;
	NSMutableDictionary*	mImageCache;
	UIImageView*			mBackgroundImageView;
	float					mCellWidth;
	float					mCellHeight;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSString* tapFunction;
@property(nonatomic, strong) NSString* pressFunction;
@property(nonatomic) uint32_t numCols;
@property(nonatomic) uint32_t numRows;
@property(nonatomic, strong) NSString* backgroundImage;

-(void)tapResponder:(id)sender;
-(void)pressResponder:(id)sender;

-(void)setNumColumns:(uint32_t)numCol andRows:(uint32_t)numRow;
-(void)setImage:(NSString*)image forTile:(eDisplayTile)tile;
-(void)setTileAtCol:(uint32_t)col row:(uint32_t)row to:(eDisplayTile)tile;
@end
