//
//  ScreenFXManager.m
//  CR1
//
//  Created by Martin Linklater on 15/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#if 0

#import "ScreenFXManager_old.h"
#import "FCViewManager.h"
#import "KenBurnsView_apple.h"
#import "TopFXView_apple.h"

#include "Shared/Core/Device/FCDevice.h"
#include "Shared/Core/FCCore.h"
#include "Shared/Lua/FCLua.h"

#pragma mark - Lua Interface

static int lua_AddPictureToBackground( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(2);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	FC_LUA_ASSERT_TYPE(2, LUA_TBOOLEAN);
	
	NSString* filename = [NSString stringWithUTF8String:lua_tostring(_state, 1)];
	BOOL async = lua_toboolean(_state, 2);

	[[ScreenFXManager_old instance] addPictureToBackground:filename async:async];
	
	return 0;
}

static int lua_StartBackgroundPan( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TNUMBER);
	
	float seconds = lua_tonumber(_state, 1);
	
	[[ScreenFXManager_old instance] startBackgroundPan:seconds];
	return 0;
}

static int lua_SetNextBackgroundImage( lua_State* _state )
{
	FC_LUA_ASSERT_NUMPARAMS(1);
	FC_LUA_ASSERT_TYPE(1, LUA_TSTRING);
	
	NSString* filename = [NSString stringWithUTF8String:lua_tostring(_state, 1)];

	[[ScreenFXManager_old instance] setNextBackgroundImage:filename];

	return 0;
}

#pragma mark - ObjC Interface

@implementation ScreenFXManager_old

//@synthesize backgroundView = _backgroundView;
@synthesize backgroundImagesDict = _backgroundImagesDict;
@synthesize screenSize = _screenSize;
//@synthesize topFXView = _topFXView;

+(ScreenFXManager_old*)instance
{
	static ScreenFXManager_old* pInstance;
	
	if (!pInstance) {
		pInstance = [[ScreenFXManager_old alloc] init];
	}
	return pInstance;
}

-(id)init
{
	self = [super init];
	if (self) {
		
		// register Lua interface
		
		FCLua::Instance()->CoreVM()->CreateGlobalTable("ScreenFX");
		FCLua::Instance()->CoreVM()->RegisterCFunction(lua_AddPictureToBackground, "ScreenFX.AddPictureToBackground");
		FCLua::Instance()->CoreVM()->RegisterCFunction(lua_StartBackgroundPan, "ScreenFX.StartBackgroundPan");
		FCLua::Instance()->CoreVM()->RegisterCFunction(lua_SetNextBackgroundImage, "ScreenFX.SetNextBackgroundImage");
		
		sscanf(FCDevice::Instance()->GetCap( kFCDeviceDisplayLogicalXRes ).c_str(), "%f", &_screenSize.width);
		sscanf(FCDevice::Instance()->GetCap( kFCDeviceDisplayLogicalYRes ).c_str(), "%f", &_screenSize.height);
		
		_backgroundView = [[KenBurnsView alloc] initWithFrame:CGRectMake(0, 50, _screenSize.width, _screenSize.height - 50)];
		_backgroundImagesDict = [NSMutableDictionary dictionary];
		
		_topFXView = [[TopFXView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height)];
		
		FCViewManager* vm = FCViewManager::Instance();
		vm->CreateView("background", "KenBurnsView", "");
		vm->SendViewToBack("background");
		vm->SetViewFrame("background", vm->FullFrame(), 0);

		vm->CreateView("topfx", "TopFXView", "");
		vm->SendViewToFront("topfx");
		
		FCViewManager* vm = [FCViewManager instance];

		[vm add:_backgroundView as:@"background"];
		[vm.rootView addSubview:_backgroundView];
		[vm.rootView sendSubviewToBack:_backgroundView];
		_backgroundView.frame = vm.rootView.frame;
		
		[vm add:_topFXView as:@"topfx"];
		[vm.rootView addSubview:_topFXView];
		[vm.rootView bringSubviewToFront:_topFXView];
	}
	return self;
}

-(void)dealloc
{
	FCViewManager* vm = FCViewManager::Instance();
	vm->DestroyView("background");
	vm->DestroyView("topfx");
}

-(void)update:(float)dt
{
//	[_topFXView update:dt];
}

-(void)addPictureToBackground:(NSString*)filename async:(BOOL)async
{
	if (async) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSString* fullpath = [[NSBundle mainBundle] pathForResource:filename ofType:@""];
			UIImage* image = [[UIImage alloc] initWithContentsOfFile:fullpath];
			
			FC_ASSERT(image);
			
			[_backgroundImagesDict setValue:image forKey:filename];
		});
	}
	else {
		NSString* fullpath = [[NSBundle mainBundle] pathForResource:filename ofType:@""];
		UIImage* image = [[UIImage alloc] initWithContentsOfFile:fullpath];
		
		FC_ASSERT(image);
		
		[_backgroundImagesDict setValue:image forKey:filename];
	}
}

-(void)startBackgroundPan:(float)seconds
{
	[_backgroundView startPrimaryFrameAnimationOver:seconds];
}

-(void)setNextBackgroundImage:(NSString*)filename
{
	[_backgroundView setSecondaryImage:[_backgroundImagesDict valueForKey:filename]];
}

@end

#endif

