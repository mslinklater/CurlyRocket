//
//  Atlas.h
//  TexLifter
//
//  Created by Martin Linklater on 26/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface Atlas : NSObject
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSMutableArray* textures;
@property(nonatomic) NSInteger border;

-(id)initWithName:(NSString*)name;
-(void)exportToFolder:(NSString*)folder withManifest:(NSXMLElement*)manifest;

@end
