//
//  Packer.h
//  TexLifter
//
//  Created by Martin Linklater on 25/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Atlas;

@interface Packer : NSObject <NSXMLParserDelegate> {
	
	NSString* _configString;
	BOOL _verbose;
//	NSMutableArray* _textures;
	NSMutableArray* _resources;
	NSMutableArray* _atlases;
	NSString* _resourceDir;
	NSString* _outputDir;
	NSString* _manifestName;
	NSString* _leftovers;
	int _border;
	Atlas* _currentAtlas;
	NSXMLElement* _manifest;
}
@property(nonatomic, strong) NSString* configString;
@property(nonatomic) BOOL verbose;
//@property(nonatomic, retain) NSMutableArray* textures;
@property(nonatomic, strong) NSMutableArray* resources;
@property(nonatomic, strong) NSMutableArray* atlases;
@property(nonatomic, strong) NSString* resourceDir;
@property(nonatomic, strong) NSString* textureDir;
@property(nonatomic, strong) NSString* outputDir;
@property(nonatomic, strong) NSString* manifestName;
@property(nonatomic, strong) NSString* leftovers;
@property(nonatomic) int border;
@property(nonatomic, strong) Atlas* currentAtlas;
@property(nonatomic, strong) NSXMLElement* manifest;

-(id)initWithConfig:(NSString*)configString;
-(void)go:(BOOL)verbose;

//-(void)cacheTexturesAtPath:(NSString*)path;
-(void)cacheResourcesAtPath:(NSString*)path;
-(NSArray*)allFilesAtPath:(NSString*)path withExtension:(NSString*)extension;
@end
