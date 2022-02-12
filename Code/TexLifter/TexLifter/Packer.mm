//
//  Packer.m
//  TexLifter
//
//  Created by Martin Linklater on 25/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import "Packer.h"
#import "Texture.h"
#import "FCCore.h"
#import "Atlas.h"
#import "FCResource.h"
#import "FCXMLData.h"
#import "Texture.h"

@implementation Packer
@synthesize configString = _configString;
@synthesize verbose = _verbose;
//@synthesize textures = _textures;
@synthesize resources = _resources;
@synthesize atlases = _atlases;
@synthesize resourceDir = _resourceDir;
@synthesize textureDir = _textureDir;
@synthesize outputDir = _outputDir;
@synthesize manifestName = _manifestName;
@synthesize leftovers = _leftovers;
@synthesize border = _border;
@synthesize currentAtlas = _currentAtlas;
@synthesize manifest = _manifest;

-(id)initWithConfig:(NSString *)configString
{
	self = [super init];
	if (self) {
		self.configString = configString;
//		self.textures = [NSMutableArray array];
		self.resources = [NSMutableArray array];
		self.atlases = [NSMutableArray array];
		self.currentAtlas = nil;
	}
	return self;	
}

-(void)go:(BOOL)verbose
{
	self.verbose = verbose;
	
	if (verbose) {
		FC_LOG1(@"Go with config", self.configString);
	}

	NSURL* url = [NSURL fileURLWithPath:self.configString];
	
	if (self.verbose) {
		FC_LOG1(@"config url:", url );
	}
	
	NSData* fileData = [[NSData alloc] initWithContentsOfURL:url];
	
	if (fileData == nil) {
		FC_FATAL1(@"Error loading config file", self.configString);
	}
	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:fileData];
	parser.delegate = self;	
	[parser parse];	
	
	// Data now parsed - lets export the atlases

	self.manifest = [NSXMLElement elementWithName:@"texliftermanifest"];

	for(Atlas* atlas in self.atlases)
	{
		atlas.border = self.border;
		[atlas exportToFolder:self.outputDir withManifest:self.manifest];
	}
	
	NSString* manifestString = [self.manifest XMLStringWithOptions:NSXMLDocumentTidyXML | NSXMLNodePrettyPrint];
	
	NSError* error;
	[manifestString writeToFile:self.manifestName atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
}

#pragma mark - NSXMLParserDelegate

//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
//- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if (self.verbose) {
		FC_LOG1(@"parser didStartElement", elementName);
	}
	
	// Packer
	
	if ([elementName isEqualToString:@"packer"]) {
		self.resourceDir = [attributeDict valueForKey:@"resourcedir"];
		self.textureDir = [attributeDict valueForKey:@"texturedir"];
		self.outputDir = [attributeDict valueForKey:@"outputdir"];
		self.manifestName = [attributeDict valueForKey:@"manifest"];
		self.leftovers = [attributeDict valueForKey:@"leftovers"];
		self.border = [[attributeDict valueForKey:@"border"] intValue];
		
//		if (self.textureDir) 
//		{
//			NSString* texturePath = self.textureDir;
//			
//			if (self.verbose) {
//				FC_LOG1(@"texture dir:", texturePath );
//			}
//			
//			[self cacheTexturesAtPath:texturePath];
//		}

		if (self.resourceDir) {
			NSString* resourcePath = self.resourceDir;
			
			if (self.verbose) {
				FC_LOG1(@"resource dir:", resourcePath );
			}
			
			[self cacheResourcesAtPath:resourcePath];
		}
	}
	
	// Atlas
	
	if ([elementName isEqualToString:@"atlas"]) {
		Atlas* atlas = [[Atlas alloc] initWithName:[attributeDict valueForKey:@"name"]];
		[self.atlases addObject:atlas];
		self.currentAtlas = atlas;
	}
	
	// Resources
	
	if ([elementName isEqualToString:@"resource"]) {
		// add resource textures to current atlas
		
		NSString* resourceName = [attributeDict valueForKey:@"name"];
		
		BOOL foundResource = NO;
		
		for(FCResource* res in self.resources)
		{
			if ([res.name rangeOfString:resourceName].location != NSNotFound) 
			{
				if (foundResource == YES) {
					FC_FATAL1(@"found multiple resources for", resourceName);
				}
				
				foundResource = YES;
				
				for(NSString* tex in res.userData)
				{
					// make Texture object from this filename fragment

					NSURL* url;
					
					NSString* pathString = [NSString stringWithFormat:@"%@/Textures/%@.png", _resourceDir, tex];

					if( [[NSFileManager defaultManager] fileExistsAtPath:pathString] )
						url = [NSURL fileURLWithPath:pathString];
					else {
						NSString* pathString = [NSString stringWithFormat:@"%@/Textures/%@.jpg", _resourceDir, tex];
						if( [[NSFileManager defaultManager] fileExistsAtPath:pathString] )
							url = [NSURL fileURLWithPath:pathString];
						else {
							FC_ASSERT(0);
						}
					}
					
					Texture* texture = [[Texture alloc] initWithUrl:url];
					texture.strippedName = tex;
					if( ![self.currentAtlas.textures containsObject:texture] )
					{
						[self.currentAtlas.textures addObject:texture];
					}
				}
			}
		}
	}

	// Textures
	
//	if ([elementName isEqualToString:@"texture"]) {
//		// add texture to current atlas
//		NSString* textureName = [attributeDict valueForKey:@"name"];
//		NSString* textureFolder = [attributeDict valueForKey:@"folder"];
//
//		if (textureName) {
//			BOOL present = NO;
//			
//			for(Texture* tex in self.textures)
//			{
//				if ([tex.filename rangeOfString:textureName].location != NSNotFound) 
//				{
//					if (present == YES) {
//						FC_FATAL1(@"Texture found more than once", textureName);
//					}
//					present = YES;
//					[self.currentAtlas.textures addObject:tex];
//				}
//			}
//			if (present == NO) {
//				FC_FATAL1(@"Cannot find texture", textureName);
//			}
//		}
//		else if(textureFolder)
//		{
//			// descend into folder and grab all the .png files.
//			
//			NSString* fullTextureFolder = [NSString stringWithFormat:@"%@/%@", self.textureDir, textureFolder];
//			
//			NSArray* texturesArray = [self allFilesAtPath:fullTextureFolder withExtension:@"png"];
//			
//			NSLog(@"%@", texturesArray);
//			
//			for(NSURL* texName in texturesArray)
//			{
//				NSString* texStringName = [texName absoluteString];
//				
//				BOOL present = NO;
//				
//				for(Texture* tex in self.textures)
//				{
//					if ([tex.filename rangeOfString:texStringName].location != NSNotFound) 
//					{
//						if (present == YES) {
//							FC_FATAL1(@"Texture found more than once", textureName);
//						}
//						present = YES;
//						[self.currentAtlas.textures addObject:tex];
//					}
//				}
//				if (present == NO) {
//					FC_FATAL1(@"Cannot find texture", textureName);
//				}
//				
//			}
//		}
//	}
}

//- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
//- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
//- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
//- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment
//- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
//- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)entityName publicID:(NSString *)publicID systemID:(NSString *)systemID
//- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
//- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
//- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
//- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data
//- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName
//- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
//- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID
//- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	if (self.verbose) {
		FC_LOG(@"parserDidEndDocument");
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	if (self.verbose) {
		FC_LOG(@"parserDidStartDocument");
	}	
}

-(NSArray*)allFilesAtPath:(NSString*)path withExtension:(NSString*)extension
{
	NSURL* directoryURL = [NSURL fileURLWithPath:path];
	
	if (self.verbose) {
		FC_LOG1(@"directoryURL", directoryURL);
	}
	
	NSDirectoryEnumerator* dirEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL 
																includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey, NSURLIsDirectoryKey, nil] 
																				   options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^BOOL(NSURL *url, NSError *error) {
																					   FC_ERROR2(@"", url, error);
																					   return NO;
																				   }];
	
	NSMutableArray* theArray = [NSMutableArray array];
	
	for(NSURL* url in dirEnumerator)
	{
		NSString* filename;
		[url getResourceValue:&filename forKey:NSURLNameKey error:NULL];
		
		NSNumber* isDirectory;
		[url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
		
		if ([[filename pathExtension] isEqualToString:@"png"] && ([isDirectory boolValue] == NO)) {
			[theArray addObject:url];
		}
	}
	return theArray;
}

//-(void)cacheTexturesAtPath:(NSString *)path
//{
//	if (self.verbose) {
//		FC_LOG1(@"finding textures in", path);
//	}
//	
//	// recurse down the texture tree and load every
//	
//	NSArray* theArray = [self allFilesAtPath:path withExtension:@"png"];
//	
//	// now go through the array and fill in the self.textures array
//	
//	for(NSURL* url in theArray)
//	{
//		Texture* tex = [[Texture alloc] initWithUrl:url stripPath:path];		
//		[self.textures addObject:tex];
//	}
//	
//	[self.textures sortUsingComparator:^NSComparisonResult(Texture* obj1, Texture* obj2) {
//		if (obj1.area == obj2.area) {
//			return NSOrderedSame;
//		} else if (obj1.area < obj2.area) {
//			return NSOrderedDescending;
//		} else {
//			return NSOrderedAscending;
//		}
//	} ];
//}

-(void)cacheResourcesAtPath:(NSString *)path
{
	if (self.verbose) {
		FC_LOG1(@"finding resources in %@", path);
	}
	
	// recurse down the texture tree and load every
	
	NSURL* directoryURL = [NSURL fileURLWithPath:path];
	
	NSDirectoryEnumerator* dirEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL 
																includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey, NSURLIsDirectoryKey, nil] 
																				   options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^BOOL(NSURL *url, NSError *error) {
																					   FC_ERROR2(@"", url, error);
																					   return NO;
																				   }];
	
	NSMutableArray* theArray = [NSMutableArray array];
	
	for(NSURL* url in dirEnumerator)
	{
		NSString* filename;
		[url getResourceValue:&filename forKey:NSURLNameKey error:NULL];
		
		NSNumber* isDirectory;
		[url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
		
		if ([[filename pathExtension] isEqualToString:@"fcr"] && ([isDirectory boolValue] == NO)) {
			[theArray addObject:url];
		}
	}

	// now go through the array make sure they reference valid textures
	
	for(NSURL* url in theArray)
	{
		FCResource* resource = [[FCResource alloc] initWithContentsOfURL:url];
		resource.name = [url absoluteString];
		resource.userData = [NSMutableArray array];
		
		NSMutableArray* thisResourcesTextures = [NSMutableArray array];
		
		// check to see if all textures referenced by the resource are present in the textures array

		NSArray* modelsArray = [resource.xmlData arrayForKeyPath:@"fcr.models.model"];

		if (modelsArray) {
			for (NSDictionary* modelDict in modelsArray) {
				id meshObject = [modelDict valueForKey:@"mesh"];
				if (meshObject) {
					NSMutableArray* meshArray = [NSMutableArray array];
					if ([meshObject isKindOfClass:[NSArray class]]) {
						[meshArray addObjectsFromArray:meshObject];
					} else {
						[meshArray addObject:meshObject];
					}
					
					for (NSDictionary* mesh in meshArray) {
						NSString* tex1 = [mesh valueForKey:@"tex1"];
						if (tex1) {
//							[self.resources addObject:url];
//							[self.textures addObject:tex1];
							[thisResourcesTextures addObject:tex1];
						}
					}
				}
			}
		}
		if ([thisResourcesTextures count]) {
			resource.userData = thisResourcesTextures;
			[self.resources addObject:resource];
		}
		
	}	
}

@end
