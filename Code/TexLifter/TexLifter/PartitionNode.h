//
//  PartitionNode.h
//  TexLifter
//
//  Created by Martin Linklater on 26/08/2011.
//  Copyright (c) 2011 CurlyRocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

enum PartitionType {
	kPartitionTypeHorizontal,
	kPartitionTypeVertical
};

@interface PartitionNode : NSObject
@property(nonatomic) CGRect rect;
@property(nonatomic) PartitionType partitionType;
@property(nonatomic, strong) PartitionNode* lChild;
@property(nonatomic, strong) PartitionNode* rChild;
@property(nonatomic, strong) NSImage* image;
@property(nonatomic) NSInteger border;
@property(nonatomic, strong) NSString* name;

-(id)initWithRect:(CGRect)rect type:(PartitionType)partitionType outputSize:(NSSize)outputSize;
-(void)clearResult;
-(void)fitTexture:(NSImage*)candidateTexture withBorder:(NSInteger)border;
-(PartitionNode*)getBestFit;
-(void)compositeImageToImage:(NSImage*)output;
-(void)addSelfToManifest:(NSXMLElement*)manifest;
@end
