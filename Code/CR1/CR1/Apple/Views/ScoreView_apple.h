//
//  ScoreView.h
//  CR1
//
//  Created by Martin Linklater on 12/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

@interface ScoreView_apple : UIView <FCManagedView_apple> {
	NSString*	_managedViewName;
	//int			_score;
	NSNumber*	_score;
	UILabel*	_labelView;
}
@property(nonatomic, strong) NSString* managedViewName;
//@property(nonatomic) int score;
@property(nonatomic) NSNumber* score;
@property(nonatomic, strong) UILabel* labelView;

-(void)update:(float)dt;

@end
