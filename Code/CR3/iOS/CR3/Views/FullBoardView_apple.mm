//
//  FullBoardView_Apple.m
//  CR3
//
//  Created by Martin Linklater on 11/10/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import "FullBoardView_apple.h"
#include "Shared/Core/FCCore.h"
#include "Shared/FCPlatformInterface.h"
#include "GameTypes.h"

static FullBoardView_apple* s_pInstance = 0;

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

void plt_FullBoard_SetImageForTile( std::string filename, eDisplayTile tile )
{
	[s_pInstance setImage:@(filename.c_str()) forTile:tile];
}

@implementation FullBoardView_apple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		s_pInstance = 0;
		
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		
		mBackgroundImageView = [[UIImageView alloc] initWithImage:nil];
		[self addSubview:mBackgroundImageView];

		mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapResponder:)];
		[self addGestureRecognizer:mTapRecognizer];
		
		mImageViewArray = [NSMutableArray array];
		mImageCache = [NSMutableDictionary dictionary];
		
		s_pInstance = self;
		FCNotificationManager::Instance()->AddSubscription(BoardInitNotificationHandler, kNotification_BoardInit, 0);
		FCNotificationManager::Instance()->AddSubscription(TileChangedNotificationHandler, kNotification_TileChanged, 0);
    }
		
    return self;
}

-(void)dealloc
{
	[self removeGestureRecognizer:mTapRecognizer];
	FCNotificationManager::Instance()->RemoveSubscription( BoardInitNotificationHandler, kNotification_BoardInit );
	FCNotificationManager::Instance()->RemoveSubscription( TileChangedNotificationHandler, kNotification_TileChanged );
}

-(void)layoutSubviews
{
	float cellWidth = self.frame.size.width / (_numCols + 2);
	float cellHeight = self.frame.size.height / (_numRows + 2);
	
	for (uint32_t row = 0; row < _numRows; row++) {
		for (uint32_t col = 0; col < _numCols; col++) {
			[[mImageViewArray objectAtIndex:(col + (row * _numCols))] setFrame:CGRectMake( (col+1) * cellWidth, (row+1) * cellHeight, cellWidth, cellHeight )];
		}
	}
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	mBackgroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

-(void)tapResponder:(id)sender
{
	if (_tapFunction) {
		fc_FCViewManager_CallTapFunction([_tapFunction UTF8String]);
	}
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

	uint32_t numImages = [imageArray count];
	
	uint32_t i = rand() % numImages;
	
	[[mImageViewArray objectAtIndex:( (row * _numCols) + col)] setImage:imageArray[i] ];
	
	[self setNeedsDisplay];
}

@end
