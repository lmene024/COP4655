//
//  CTcartManager.m
//  CartTracker
//
//  Created by leo on 11/15/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTcartManager.h"
#import "CTbaseDataHandler.h"

#define SORT_ASCENDING @"ASC"
#define SORT_DESCENDING @"DSC"

@implementation CTcartManager
{
    CTbaseDataHandler * dataHandler;
    NSManagedObjectContext * context;
    
}

- (NSManagedObjectContext *) context{
    if (!dataHandler) {
        dataHandler = [CTbaseDataHandler instance];
    }
    
    if (!context) {
        context = dataHandler.managedObjectContext;
    }
    return context;
}


- (NSFetchRequest *) getCarts{
    return [self getDataForEntity:@"Cart"
                   withSortFields:@[@"cartID"]
                    andSortOrders:@[SORT_ASCENDING]];
}

- (NSFetchRequest *) getUsers{
    return [self getDataForEntity:@"User"
                   withSortFields:@[@"lastName", @"firstName"]
                    andSortOrders:@[SORT_ASCENDING, SORT_ASCENDING]];
}

- (NSFetchRequest *) getRequests{
    return [self getDataForEntity:@"Request" withSortFields:@[@"reqID"] andSortOrders:@[SORT_ASCENDING]];
}

- (NSFetchRequest *) getDataForEntity:(NSString *) entityName
                       withSortFields:(NSArray *) sortFields
                        andSortOrders:(NSArray *) sortOrders
{
    if (!dataHandler) {
        dataHandler = [CTbaseDataHandler instance];
    }
    
    if (!context) {
        context = dataHandler.managedObjectContext;
    }
    

    
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSMutableArray * sortDescriptors = [[NSMutableArray alloc] init];
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    [fetchRequest setFetchBatchSize:20];
    
    if (sortFields != nil) {

    for (int i=0; i<sortFields.count; i++) {
        NSString * sortField = sortFields[i];
        bool ascending = true;
        if (sortField == nil || ![sortField isKindOfClass:[NSString class]]) {
            break;
        }
        
        if (sortOrders != nil && sortOrders.count>i) {
            if ([sortOrders[i] isEqual:SORT_DESCENDING]) {
                ascending = false;
            }
        }
        NSSortDescriptor * sortDesccriptor = [[NSSortDescriptor alloc] initWithKey:sortField ascending:ascending];
        
        [sortDescriptors addObject:sortDesccriptor];
    }
    }
    if (sortDescriptors != nil && sortDescriptors.count >0) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    return fetchRequest;
   
}

- (bool) save{
    NSError * error;
    BOOL result = [dataHandler.managedObjectContext save:&error];
    return result;
}

@end
