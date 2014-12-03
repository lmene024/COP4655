//
//  CTcartManager.m
//  CartTracker
//
//  Created by leo on 11/15/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTcartManager.h"
#import "CTbaseDataHandler.h"
#import "Cart.h"
#import "User.h"
#import "Request.h"
#import "Constants.h"


@implementation CTcartManager
{
    CTbaseDataHandler * dataHandler;    
}

- (NSManagedObjectContext *) context{
    
    if (!dataHandler) {
        dataHandler = [CTbaseDataHandler instance];
    }
    
    if (!_context) {
        _context = dataHandler.managedObjectContext;
    }
    return _context;
}


- (NSFetchRequest *) getAllCarts{
    return [self getDataForEntity:@"Cart"
                   withSortFields:@[@"cartID"]
                    andSortOrders:@[SORT_ASCENDING]
                    withPredicate:nil];
}

- (NSFetchRequest *) getAllUsers{
    return [self getDataForEntity:@"User"
                   withSortFields:@[@"lastName", @"firstName"]
                    andSortOrders:@[SORT_ASCENDING, SORT_ASCENDING]
                    withPredicate:nil];
}

- (NSFetchRequest *) getAllRequests{
    return [self getDataForEntity:@"Request"
                   withSortFields:@[@"reqID"]
                    andSortOrders:@[SORT_ASCENDING]
                    withPredicate:nil];
}

- (NSFetchRequest *) getCartsWithPredicate:(NSPredicate *)predicate{
    return [self getDataForEntity:@"Cart"
                   withSortFields:@[@"cartName"]
                    andSortOrders:@[SORT_ASCENDING]
                    withPredicate:predicate];
}

- (NSFetchRequest *) getUsersWithPredicate:(NSPredicate *)predicate{
    return [self getDataForEntity:@"User"
                   withSortFields:@[@"lastName", @"firstName"]
                    andSortOrders:@[SORT_ASCENDING, SORT_ASCENDING]
                    withPredicate:predicate];
}

- (NSFetchRequest *) getRequestsWithPredicate:(NSPredicate *)predicate{
    return [self getDataForEntity:@"Request"
                   withSortFields:@[@"reqID"]
                    andSortOrders:@[SORT_ASCENDING]
                    withPredicate:predicate];
}

- (NSFetchRequest *) getDataForEntity:(NSString *) entityName
                       withSortFields:(NSArray *) sortFields
                        andSortOrders:(NSArray *) sortOrders
                        withPredicate:(NSPredicate *) predicate
{
   
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
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
    
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    return fetchRequest;
   
}

- (Cart *) newCart{
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext:self.context];
    Cart * nCart = [[Cart alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.context];
    return nCart;
}

- (User *) newUser{
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    User * nUser = [[User alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.context];
    return nUser;
}

- (Request *) newRequest{
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:self.context];
    Request * nRequest = [[Request alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.context];
    return nRequest;
}


- (void) deleteCart:(Cart *) cart{
    [self.context deleteObject:cart];
}

- (void) deleteUser:(User *)user{
    [self.context deleteObject:user];
}

- (void) deleteRequest:(Request *)request{
    [self.context deleteObject:request];
}

- (bool) save{
    NSError * error;
    BOOL result = [dataHandler.managedObjectContext save:&error];
    return result;
}

@end
