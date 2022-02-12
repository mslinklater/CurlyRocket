//
//  Texture.h
//  TexLifter
//
//  Created by Martin Linklater on 25/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface Texture : NSObject
@property(nonatomic, strong) NSImage* image;
@property(nonatomic, strong) NSString* filename;
@property(nonatomic, strong) NSString* strippedName;
@property(nonatomic, strong) NSString* hash;
@property(nonatomic) float area;

-(id)initWithUrl:(NSURL*)url;

@end
