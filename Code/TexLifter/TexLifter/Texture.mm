//
//  Texture.m
//  TexLifter
//
//  Created by Martin Linklater on 25/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import "Texture.h"

@implementation Texture
@synthesize image = _image;
@synthesize filename = _filename;
@synthesize strippedName = _strippedName;
@synthesize hash = _hash;
@synthesize area = _area;

//-(id)initWithUrl:(NSURL *)url stripPath:(NSString *)stripPath
-(id)initWithUrl:(NSURL *)url
{
	self = [super init];
	if (self) {
		
//		NSString* absoluteString = [url absoluteString];
//		self.filename = absoluteString;
//		NSString* stripPattern = [stripPath lastPathComponent];
//		NSRange stripRange = [absoluteString rangeOfString:stripPattern];
		
//		self.strippedName = [absoluteString substringFromIndex:stripRange.location + stripRange.length + 1];
		
		self.image = [[NSImage alloc] initWithContentsOfURL:url];		
		NSSize imageSize = self.image.size;
		self.area = imageSize.width * imageSize.height;	
	}
	return self;
}

-(void)dealloc
{
	self.image = nil;
	self.filename = nil;
	self.hash = nil;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"Texture: %@ %f x %f", self.filename, self.image.size.width, self.image.size.height];
}

@end
