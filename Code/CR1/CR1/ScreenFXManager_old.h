//
//  ScreenFXManager.h
//  CR1
//
//  Created by Martin Linklater on 15/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#if 0

#import <Foundation/Foundation.h>

//@class KenBurnsView;
//@class TopFXView;

@interface ScreenFXManager_old : NSObject {
//	KenBurnsView* _backgroundView;
//	TopFXView* _topFXView;
	NSMutableDictionary* _backgroundImagesDict;
	CGSize _screenSize;
}
//@property(nonatomic, strong) KenBurnsView* backgroundView;
//@property(nonatomic, strong) TopFXView* topFXView;
@property(nonatomic, strong) NSMutableDictionary* backgroundImagesDict;
@property(nonatomic) CGSize screenSize;

+(ScreenFXManager_old*)instance;

-(void)update:(float)dt;

-(void)addPictureToBackground:(NSString*)filename async:(BOOL)async;
-(void)startBackgroundPan:(float)seconds;
-(void)setNextBackgroundImage:(NSString*)filename;

@end

#endif
