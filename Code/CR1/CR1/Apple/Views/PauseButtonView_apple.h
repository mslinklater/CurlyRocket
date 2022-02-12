//
//  PauseButtonView.h
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface PauseButtonView_apple : UIView <FCManagedView_apple> {
	NSString* _managedViewName;
	BOOL _paused;
	UITapGestureRecognizer* _tapRecogniser;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic) BOOL paused;
@property(nonatomic, strong) UITapGestureRecognizer* tapRecogniser;

-(void)pausePressed:(id)sender;

@end
