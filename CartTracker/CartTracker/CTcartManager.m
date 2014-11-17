//
//  CTcartManager.m
//  CartTracker
//
//  Created by leo on 11/15/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTcartManager.h"
#import "CTbaseDataHandler.h"

@implementation CTcartManager
{
    CTbaseDataHandler * dataHandler;
    NSManagedObjectContext * context;
    
}

@synthesize managedCarts;


- (NSArray *) managedCarts{
    if (!dataHandler) {
        dataHandler = [CTbaseDataHandler instance];
    }
    
    if (!context) {
        context = dataHandler.managedObjectContext;
    }
    
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError * error = nil;
    
    managedCarts = [context executeFetchRequest:request error:&error];
    
    return managedCarts;
}

- (void) editCart {
    
}

@end
