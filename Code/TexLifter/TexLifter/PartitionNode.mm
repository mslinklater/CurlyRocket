//
//  PartitionNode.m
//  TexLifter
//
//  Created by Martin Linklater on 26/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import "PartitionNode.h"
#import "FCCore.h"

static PartitionNode*	s_bestFit;
static float			s_biggestFit;

@interface PartitionNode()
@property(nonatomic) NSSize outputSize;
@end

@implementation PartitionNode
@synthesize rect = _rect;
@synthesize partitionType = _partitionType;
@synthesize lChild = _lChild;
@synthesize rChild = _rChild;
@synthesize image = _image;
@synthesize border = _border;
@synthesize outputSize = _outputSize;
@synthesize name = _name;

-(id)initWithRect:(CGRect)rect type:(PartitionType)partitionType outputSize:(NSSize)outputSize
{
	self = [super init];
	if (self) {
		self.rect = rect;
		self.partitionType = partitionType;
		self.outputSize = outputSize;
	}
	return self;
}

-(void)dealloc
{
	self.lChild = nil;
	self.rChild = nil;
	self.name = nil;
}

-(void)clearResult
{
	s_bestFit = nil;
	s_biggestFit = 0.0f;
}

-(PartitionNode*)getBestFit
{
	return s_bestFit;
}

-(void)fitTexture:(NSImage*)candidateTexture withBorder:(NSInteger)border
{
	self.border = border;
	
	if (self.image == nil) {
		
		if (self.rect.size.width < candidateTexture.size.width + border*2) {
			return;
		}
		if (self.rect.size.height < candidateTexture.size.height + border*2) {
			return;
		}
		
		// return percentage fit for self
		float selfarea = self.rect.size.width * self.rect.size.height;
		float candidatearea = (candidateTexture.size.width + border * 2) * (candidateTexture.size.height + border * 2);
		
		float thisFit = candidatearea / selfarea;
		
		if (thisFit > s_biggestFit) {
			s_bestFit = self;
			s_biggestFit = thisFit;
		}
		
		return;
	}
	else
	{
		[self.lChild fitTexture:candidateTexture withBorder:border];
		[self.rChild fitTexture:candidateTexture withBorder:border];
	}
}

-(void)setImage:(NSImage *)image
{
	_image = image;
	
	if (self.partitionType == kPartitionTypeHorizontal) 
	{
		CGRect lRect = CGRectMake(self.rect.origin.x, 
								  self.rect.origin.y + image.size.height + self.border*2, 
								  self.rect.size.width, 
								  self.rect.size.height - image.size.height - self.border*2);
		
		CGRect rRect = CGRectMake(self.rect.origin.x + image.size.width + self.border*2, 
								  self.rect.origin.y, 
								  self.rect.size.width - image.size.width - self.border*2, 
								  image.size.height + self.border*2);
		
		_lChild = [[PartitionNode alloc] initWithRect:lRect type:kPartitionTypeVertical outputSize:self.outputSize];
		_rChild = [[PartitionNode alloc] initWithRect:rRect type:kPartitionTypeVertical outputSize:self.outputSize];
	}
	else
	{
		CGRect lRect = CGRectMake(self.rect.origin.x, 
								  self.rect.origin.y + image.size.height + self.border*2, 
								  image.size.width + self.border*2, 
								  self.rect.size.height - image.size.height - self.border*2);
		
		CGRect rRect = CGRectMake(self.rect.origin.x + image.size.width + self.border*2, 
								  self.rect.origin.y, 
								  self.rect.size.width - image.size.width - self.border*2, 
								  self.rect.size.height);
		
		_lChild = [[PartitionNode alloc] initWithRect:lRect type:kPartitionTypeHorizontal outputSize:self.outputSize];
		_rChild = [[PartitionNode alloc] initWithRect:rRect type:kPartitionTypeHorizontal outputSize:self.outputSize];		
	}
}

-(void)compositeImageToImage:(NSImage *)output
{
	if (!self.image) {
		return;
	}
	
	// do composite here
	
	[output lockFocus];
	NSRect rect;
	rect.origin.x = self.border;
	rect.origin.y = self.border;
	rect.size = self.image.size;
	
	NSImage* image = self.image;
	
	[image drawAtPoint:self.rect.origin fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	[output unlockFocus];
	
//	{
//		NSData* imageData = [output TIFFRepresentation];
//		NSBitmapImageRep* rep = [NSBitmapImageRep imageRepWithData:imageData];
//		NSDictionary* imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
//		imageData = [rep representationUsingType:NSPNGFileType properties:imageProps];
//		[imageData writeToFile:[NSString stringWithFormat:@"../../output%d.png", i] atomically:NO];
//	}

//	i++;
	
	if (self.lChild) {
		[self.lChild compositeImageToImage:output];
	}
	if (self.rChild) {
		[self.rChild compositeImageToImage:output];
	}
}

-(void)addSelfToManifest:(NSXMLElement *)manifest
{
	if (self.image) {
		NSXMLElement* element = [[NSXMLElement alloc] initWithName:@"texture"];
		[manifest addChild:element];
		[element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:self.name]];
		
		float absX = (self.rect.origin.x + self.border) / self.outputSize.width;
		float absY = (self.outputSize.height - (self.rect.origin.y + self.image.size.height) + self.border) / self.outputSize.height;
		float absW = self.image.size.width / self.outputSize.width;
		float absH = self.image.size.height / self.outputSize.height;
		
		[element addAttribute:[NSXMLNode attributeWithName:[NSString stringWithUTF8String:kFCKeyX.c_str()] stringValue:[NSString stringWithFormat:@"%f", absX ]]];
		[element addAttribute:[NSXMLNode attributeWithName:[NSString stringWithUTF8String:kFCKeyY.c_str()] stringValue:[NSString stringWithFormat:@"%f", absY ]]];
		[element addAttribute:[NSXMLNode attributeWithName:[NSString stringWithUTF8String:kFCKeyWidth.c_str()] stringValue:[NSString stringWithFormat:@"%f", absW ]]];
		[element addAttribute:[NSXMLNode attributeWithName:[NSString stringWithUTF8String:kFCKeyHeight.c_str()] stringValue:[NSString stringWithFormat:@"%f", absH ]]];
		
		[self.lChild addSelfToManifest:manifest];
		[self.rChild addSelfToManifest:manifest];
	}
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"[%f,%f,%f,%f]{%@},{%@}", self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height, self.lChild, self.rChild];
}

@end
