//
//  CTimageTransformer.m
//  CartTracker
//
//  Created by leo on 11/16/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTimageTransformer.h"

@implementation CTimageTransformer

+ (Class) transformedValueClass{
    return [NSData class];
}

- (id) transformedValue:(id)value{
    if (!value){
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id) reverseTransformedValue:(id)value{
    return [UIImage imageWithData:value];
}

@end
