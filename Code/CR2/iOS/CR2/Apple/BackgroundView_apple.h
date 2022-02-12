//
//  BackgroundView_apple.h
//  CR2
//
//  Created by Martin Linklater on 08/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FCViewManager_apple.h"

static const uint32_t kNumSquares = 100;

@interface BackgroundView_apple : UIView <FCManagedView_apple> {
	NSString*		_managedViewName;
	
	UIImageView*	_backgroundImageView;
}
@property(nonatomic, strong) NSString* managedViewName;
@property( nonatomic, strong ) UIImageView* backgroundImageView;

@end
