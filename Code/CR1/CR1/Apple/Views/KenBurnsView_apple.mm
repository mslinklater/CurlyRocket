//
//  KenBurnsView.m
//  CR1
//
//  Created by Martin Linklater on 15/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "KenBurnsView_apple.h"
#include "Shared/Core/FCCore.h"

KenBurnsViewRef plt_KenBurnsView_Create( std::string name, std::string parent );

KenBurnsViewRef plt_KenBurnsView_Create( std::string name, std::string parent )
{
	return KenBurnsViewRef( new KenBurnsViewProxy( name, parent ) );
}

@implementation KenBurnsView_apple

@synthesize managedViewName = _managedViewName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		mParentFrame = frame;
		self.backgroundColor = [UIColor clearColor];

		mImageViews[0] = [[UIImageView alloc] initWithFrame:frame];
		mImageViews[1] = [[UIImageView alloc] initWithFrame:frame];
		
		mImageViews[0].alpha = 0;
		mImageViews[1].alpha = 1;
		mImageViews[0].backgroundColor = [UIColor clearColor];
		mImageViews[1].backgroundColor = [UIColor clearColor];
		mImageViews[0].contentMode = UIViewContentModeScaleAspectFill;
		mImageViews[1].contentMode = UIViewContentModeScaleAspectFill;
		
		[self addSubview:mImageViews[0]];
		[self addSubview:mImageViews[1]];
		
		mPrimaryImage = 0;
		mSecondaryImage = 1;
		mLastGoodImage = nil;
    }
    return self;
}

-(void)dealloc
{
	mLastGoodImage = nil;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
}

-(void)startPrimaryFrameAnimationOver:(float)secs
{
	int temp = mPrimaryImage;
	mPrimaryImage = mSecondaryImage;
	mSecondaryImage = temp;
	
	float percent = (rand() % 50);
	
	FC_ASSERT( self.superview.frame.size.width );
	FC_ASSERT( self.superview.frame.size.height );
	
	CGRect frame = CGRectMake(-(rand() % ((int)self.superview.frame.size.width/2)), 
							  -(rand() % ((int)self.superview.frame.size.height/2)), 
												self.frame.size.width * (2 - 0.01f * percent), 
												self.frame.size.height * (2 - 0.01f * percent));

	mImageViews[mPrimaryImage].frame = frame;
	
	[self bringSubviewToFront:mImageViews[mPrimaryImage]];
	[UIView animateWithDuration:1 animations:^{
		mImageViews[mPrimaryImage].alpha = 1;
	}];	

	percent = (rand() % 50);

	[UIView animateWithDuration:secs animations:^{
		
		CGRect frameTo = CGRectMake(-(rand() % ((int)self.superview.frame.size.width/2)), 
													-(rand() % ((int)self.superview.frame.size.height/2)), 
													  self.frame.size.width * (2 - 0.01f * percent), 
													  self.frame.size.height * (2 - 0.01f * percent));
		
		mImageViews[mPrimaryImage].frame = frameTo;
	}];	
}

-(void)setSecondaryImage:(UIImage*)image
{
	if (image == nil) 
	{
		FC_ASSERT( mLastGoodImage );
		image = mLastGoodImage;
	}
	
	FC_ASSERT( image );
	
	mLastGoodImage = image;
	
	mImageViews[ mSecondaryImage ].image = image;	
	mImageViews[ mSecondaryImage ].alpha = 0;
}

@end
