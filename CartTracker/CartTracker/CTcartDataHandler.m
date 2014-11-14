//
//  CTcartDataHandler.m
//  CartTracker
//
//  Created by leo on 11/13/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTcartDataHandler.h"

@implementation CTcartDataHandler

@synthesize model;

- (instancetype) init{
    self = [super initFromSubClass];
    if (self) {
        model = @"CartModel";
    }
    return self;
}
@end
