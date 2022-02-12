//
//  TopFXView.m
//  CR1
//
//  Created by Martin Linklater on 19/01/2012.
//  Copyright (c) 2012 Curly Rocket Ltd. All rights reserved.
//

#import "TopFXView_apple.h"

static TopFXView_apple* s_pInstance;

@implementation TopFXView_apple

@synthesize managedViewName = _managedViewName;
@synthesize vignetteImage = _vignetteImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		s_pInstance = self;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		
		_vignetteImage = [UIImage imageNamed:@"Imported/vignette_alpha.png"];
		
    }
    return self;
}

-(void)dealloc
{
	s_pInstance = nil;
}

-(void)update:(float)dt
{
//	float alpha = 0.6 + ((float)(rand() % 5) * 0.01);
//	self.alpha = alpha;
}

- (void)drawRect:(CGRect)rect
{
	
	CGContextRef c = UIGraphicsGetCurrentContext();

	[super drawRect:rect];	

	CGContextSaveGState(c);

//	CGContextSetBlendMode (c, kCGBlendModeScreen);
	
	CGContextDrawImage(c, rect, _vignetteImage.CGImage);
	
	CGContextRestoreGState(c);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

TopFXViewRef plt_TopFXView_Create( std::string name, std::string parent )
{
	return TopFXViewRef( new TopFXViewProxy( name, parent ) );
}

