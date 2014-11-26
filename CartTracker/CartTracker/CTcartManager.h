//
//  CTcartManager.h
//  CartTracker
//
//  Created by leo on 11/15/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTcartManager : NSObject

@property (nonatomic, readonly) NSFetchRequest * getCarts;
@property (nonatomic, readonly) NSFetchRequest * getUsers;
@property (nonatomic, readonly) NSFetchRequest * getRequests;

- (NSManagedObjectContext *) context;

@end
