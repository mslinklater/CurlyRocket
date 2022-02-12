//
//  main.m
//  TexLifter
//
//  Created by Martin Linklater on 25/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCCore.h"
#import "Packer.h"

int main (int argc, const char * argv[])
{
	@autoreleasepool {
	    
		if (argc <= 1) {
			FC_FATAL(@"No input file");
		}
		
		BOOL verbose = NO;

		for (int i = 0; i < argc; i++) {
			if (strcmp("-v", argv[i]) == 0) {
				verbose = YES;
			}
		}
		
	    NSString* inputFile = [NSString stringWithFormat:@"%s", argv[1]];

		NSLog(@"Processing with input file: %@", inputFile);
		
		Packer* packer = [[Packer alloc] initWithConfig:inputFile];
		[packer go:verbose];
	}
    return 0;
}

