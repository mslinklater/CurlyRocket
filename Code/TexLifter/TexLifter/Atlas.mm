//
//  Atlas.m
//  TexLifter
//
//  Created by Martin Linklater on 26/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import "Atlas.h"
#import "PartitionNode.h"
#import "Texture.h"

@interface Atlas()
@property(nonatomic, retain) NSString* exportFolder;
@property(nonatomic, retain) NSImage* outputImage;
-(BOOL)exportWithDimension:(int)dimension toFolder:(NSString*)folderString withManifest:(NSXMLElement*)manifest;
@end

@implementation Atlas
@synthesize name = _name;
@synthesize textures = _textures;
@synthesize exportFolder = _exportFolder;
@synthesize outputImage = _outputImage;
@synthesize border = _border;

-(id)initWithName:(NSString*)name
{
	self = [super init];
	if (self) {
		self.name = name;
		self.textures = [NSMutableArray array];
	}
	return self;
}

-(void)dealloc
{
	self.name = nil;
	self.textures = nil;
	self.outputImage = nil;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"%@ %d", self.name, [self.textures count]];
}

-(void)exportToFolder:(NSString *)folder withManifest:(NSXMLElement *)manifest
{
	int dimension = 8;
	
	while ([self exportWithDimension:dimension toFolder:folder withManifest:manifest] == NO) {
		dimension = dimension * 2;
	}
}

-(BOOL)exportWithDimension:(int)dimension toFolder:(NSString*)folderString withManifest:(NSXMLElement*)manifest;
{
	PartitionNode* root = [[PartitionNode alloc] initWithRect:CGRectMake(0, 0, dimension, dimension) type:kPartitionTypeHorizontal outputSize:NSMakeSize(dimension, dimension)];
	
	// go through all textures adding them
	
	for(Texture* tex in self.textures)
	{
		[root clearResult];
		[root fitTexture:tex.image withBorder:self.border];
		PartitionNode* theone = [root getBestFit];

		if (theone) {
			theone.image = tex.image;
			theone.name = tex.strippedName;
		}
		else
		{
			return NO;
		}
	}
	
	// successful
	
	NSLog(@"Writing out %dx%d image", dimension, dimension);
	
	// now write out as a png file
	
	NSSize outputImageSize;
	outputImageSize.width = dimension;
	outputImageSize.height = dimension;
	self.outputImage = [[NSImage alloc] initWithSize:outputImageSize];
	self.outputImage.backgroundColor = [NSColor blackColor];

	[root compositeImageToImage:self.outputImage];
	
	[self.outputImage lockFocus];
	NSBitmapImageRep* bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, dimension, dimension)];
	[self.outputImage unlockFocus];
	NSData* imageData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
	NSString* filename = [NSString stringWithFormat:@"%@/%@.png", folderString, self.name];
	[imageData writeToFile:filename atomically:NO];

	// now build the manifest XML

	NSXMLElement* thisAtlas = [NSXMLElement elementWithName:@"atlas"];
	[thisAtlas addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
	[manifest addChild:thisAtlas];
	
	[root addSelfToManifest:thisAtlas];
	
	return YES;
}

@end
