//
//  CTContactUI.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/8/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTContactUI.h"
#import "CTLoginViewUI.h"

@implementation CTContactUI

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [CTLoginViewUI drawCanvas3];
}


@end
