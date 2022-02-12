//
//  LabelView.h
//  CR1
//
//  Created by Martin Linklater on 28/12/2011.
//  Copyright (c) 2011 Curly Rocket Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCViewManager_apple.h"

enum eLabelViewStyle {
	kLabelViewStyleNormal,
	kLabelViewStyleTwitter
};

@interface LabelView_apple : UILabel <FCManagedView_apple> {
	NSString* _managedViewName;
	eLabelViewStyle _style;
}
@property(nonatomic, strong) NSString* managedViewName;
@property(nonatomic) eLabelViewStyle style;

@end
