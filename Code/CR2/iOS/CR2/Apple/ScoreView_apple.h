//
//  ScoreView_apple.h
//  CR2
//
//  Created by Martin Linklater on 05/08/2012.
//  Copyright (c) 2012 Martin Linklater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

enum eLabelViewStyle {
	kLabelViewStyleNormal,
	kLabelViewStyleTwitter
};

@interface ScoreView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;

	UIImageView*	_backgroundImage;
	
	UILabel* _bankLabel;
	
	NSNumber*	_showBar;	// DEPRECATE
	
	uint32_t _bank;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic, strong) NSNumber* showBar;
@property(nonatomic) uint32_t bank;

@end
