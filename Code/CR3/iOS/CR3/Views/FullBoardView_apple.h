//
//  FullBoardView_Apple.h
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"
#include "GameTypes.h"

@interface FullBoardView_apple : UIView <FCManagedView_apple> {
	
	// properties
	
	NSString* _managedViewname;
	NSString*	_tapFunction;
	uint32_t	_numCols;
	uint32_t	_numRows;
	float		_cellWidth;
	float		_cellHeight;
	NSString*	_backgroundImage;

	// members
	
	UITapGestureRecognizer* mTapRecognizer;
	NSMutableArray*			mImageViewArray;
	NSMutableDictionary*	mImageCache;
	UIImageView*			mBackgroundImageView;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSString* tapFunction;
@property(nonatomic) uint32_t numCols;
@property(nonatomic) uint32_t numRows;
@property(nonatomic, strong) NSString* backgroundImage;

-(void)tapResponder:(id)sender;

-(void)setNumColumns:(uint32_t)numCol andRows:(uint32_t)numRow;
-(void)setImage:(NSString*)image forTile:(eDisplayTile)tile;
-(void)setTileAtCol:(uint32_t)col row:(uint32_t)row to:(eDisplayTile)tile;
@end


