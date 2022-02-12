//
//  ScrollingBoardView_apple.m
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "ScrollingBoardView_apple.h"
#include "Shared/Core/FCCore.h"
#include "GameTypes.h"
#include "Shared/Lua/FCLua.h"

static ScrollingBoardView_apple* s_pInstance = 0;

#pragma mark - Notification Handlers

static void BoardInitNotificationHandler( FCNotification note, void* pContext )
{
	NotificationBoardInitInfo* info = (NotificationBoardInitInfo*)note.info.get();
	[s_pInstance setNumColumns:info->m_numCols andRows:info->m_numRows];
}

static void TileChangedNotificationHandler( FCNotification note, void* pContext )
{
	NotificationTileChangedInfo* info = (NotificationTileChangedInfo*)note.info.get();
	[s_pInstance setTileAtCol:info->col row:info->row to:info->tile];
}

void plt_ScrollingBoard_SetImageForTile( std::string filename, eDisplayTile tile )
{
	[s_pInstance setImage:@(filename.c_str()) forTile:tile];
}

#pragma mark - Impl

@implementation ScrollingBoardView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		s_pInstance = 0;
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.bounces = NO;
		
		mBackgroundImageView = [[UIImageView alloc] initWithImage:nil];
		[self addSubview:mBackgroundImageView];
		
		mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponder:)];
		[self addGestureRecognizer:mTapRecognizer];
		
		mPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressResponder:)];
		[self addGestureRecognizer:mPressRecognizer];
		
		mImageViewArray = [NSMutableArray array];
		mImageCache = [NSMutableDictionary dictionary];
		
		s_pInstance = self;
		FCNotificationManager::Instance()->AddSubscription( BoardInitNotificationHandler, kNotification_BoardInit, 0 );
		FCNotificationManager::Instance()->AddSubscription(TileChangedNotificationHandler, kNotification_TileChanged, 0);
    }
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:mTapRecognizer];
	[self removeGestureRecognizer:mPressRecognizer];
	
	FCNotificationManager::Instance()->RemoveSubscription( BoardInitNotificationHandler, kNotification_BoardInit );
	FCNotificationManager::Instance()->RemoveSubscription( TileChangedNotificationHandler, kNotification_TileChanged );
}

-(void)layoutSubviews
{
	mCellWidth = self.contentSize.width / (_numCols + 2);
	mCellHeight = self.contentSize.height / (_numRows + 2);
	
	for (uint32_t row = 0; row < _numRows; row++) {
		for (uint32_t col = 0; col < _numCols; col++) {
			[[mImageViewArray objectAtIndex:(col + (row * _numCols))] setFrame:CGRectMake( (col+1) * mCellWidth, (row+1) * mCellHeight, mCellWidth, mCellHeight )];
		}
	}
}

-(void)tapResponder:(UITapGestureRecognizer*)sender
{
	if (_tapFunction) {
		CGPoint point = [sender locationInView:self];
		uint32_t col = point.x / mCellWidth;
		uint32_t row = point.y / mCellHeight;
		
		if ((col > 0) && (row > 0) && (col <= _numCols ) && (row <= _numRows)) {
			FCLua::Instance()->CoreVM()->CallFuncWithSig([_tapFunction UTF8String], true, "ii>", col-1, row-1);
		}
	}
}

-(void)pressResponder:(UILongPressGestureRecognizer*)sender
{
	if (_pressFunction) {
		if (sender.state == UIGestureRecognizerStateBegan) {
			CGPoint point = [sender locationInView:self];
			uint32_t col = point.x / mCellWidth;
			uint32_t row = point.y / mCellHeight;
			
			if ((col > 0) && (row > 0) && (col <= _numCols ) && (row <= _numRows))
			{
				FCLua::Instance()->CoreVM()->CallFuncWithSig([_pressFunction UTF8String], true, "ii>", col-1, row-1);
			}
		}
	}
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	float largestDimension = FCMax(self.frame.size.width, self.frame.size.height);
	
	CGSize contentSize = CGSizeMake(largestDimension / 10.0f * (_numCols + 2), largestDimension / 10.0f * (_numRows + 2));
	self.contentSize = contentSize;
	
	mBackgroundImageView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
}

-(void)setBackgroundImage:(NSString *)backgroundImage
{
	UIImage* image = [UIImage imageNamed:backgroundImage];
	mBackgroundImageView.image = image;
}

-(void)setNumColumns:(uint32_t)numCol andRows:(uint32_t)numRow
{
	_numCols = numCol;
	_numRows = numRow;

	if (mImageViewArray) {
		for ( UIImageView* imageView in mImageViewArray ) {
			[imageView removeFromSuperview];
		}
	}
	
	mImageViewArray = [NSMutableArray array];
	
	for (int col = 0; col < _numCols; col++)
	{
		for (int row = 0; row < _numRows; row++)
		{
			NSArray* imageArray = [mImageCache objectForKey:[NSNumber numberWithInt:kDisplayTile_Hidden]];
			UIImage* image = [imageArray objectAtIndex:rand() % [imageArray count]];
			UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
			[self addSubview:imageView];
			[mImageViewArray addObject:imageView];

			imageView.backgroundColor = [UIColor clearColor];
		}
	}
	
	
	[self layoutSubviews];
}

-(void)setImage:(NSString*)image forTile:(eDisplayTile)tile
{
	NSNumber* num = [NSNumber numberWithInt:tile];
	
	if ([mImageCache objectForKey:num] == nil) {
		NSMutableArray* imageArray = [NSMutableArray array];
		[mImageCache setObject:imageArray forKey:num];
	}
	
	UIImage* tileImage = [UIImage imageNamed:image];
	
	FC_ASSERT(tileImage);
	
	[[mImageCache objectForKey:num] addObject:tileImage];
}

-(void)setTileAtCol:(uint32_t)col row:(uint32_t)row to:(eDisplayTile)tile
{
	NSNumber* num = [NSNumber numberWithInt:tile];
	NSArray* imageArray = [mImageCache objectForKey:num];

	FC_ASSERT( imageArray );

	UIImageView* thisView = [mImageViewArray objectAtIndex:( (row * _numCols) + col)];

	uint32_t numImages = [imageArray count];
	
	uint32_t i = rand() % numImages;

	[thisView setImage:imageArray[i]];

	if (tile == kDisplayTile_Flagged)
	{
		[thisView setFrame:CGRectMake(((int)col - 1) * mCellWidth, ((int)row - 1) * mCellHeight, mCellWidth * 5, mCellHeight * 5 )];
	}
	else if (tile == kDisplayTile_Hidden)
	{
		[thisView setFrame:CGRectMake((col+1) * mCellWidth, (row+1) * mCellHeight, mCellWidth, mCellHeight )];
	}
	else
	{
		[thisView setFrame:CGRectMake(((int)col - 0) * mCellWidth, ((int)row - 0) * mCellHeight, mCellWidth * 3, mCellHeight * 3 )];
	}

	[UIView animateWithDuration:0.5 animations:^{
		[thisView setFrame:CGRectMake( (col+1) * mCellWidth, (row+1) * mCellHeight, mCellWidth, mCellHeight )];
	}];
	
	[self setNeedsDisplay];
}

@end
