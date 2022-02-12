//
//  ClockView_apple.h
//  CR2
//
//  Created by Martin Linklater on 05/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface ClockView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;

	UIImageView*	_backgroundImage;
	
	uint32_t _roundScore;
	uint32_t _roundScoreMax;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) UIImageView* backgroundImage;
@property(nonatomic) uint32_t roundScore;
@property(nonatomic) uint32_t roundScoreMax;

@end
