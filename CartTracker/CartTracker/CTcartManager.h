//
//  CTcartManager.h
//  CartTracker
//
//  Created by leo on 11/15/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cart;
@class User;
@class Request;

@interface CTcartManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext * context;

- (NSFetchRequest *) getAllCarts;
- (NSFetchRequest *) getAllUsers;
- (NSFetchRequest *) getAllRequests;

- (NSFetchRequest *) getCartsWithPredicate:(NSPredicate *)predicate;
- (NSFetchRequest *) getUsersWithPredicate:(NSPredicate *)predicate;
- (NSFetchRequest *) getRequestsWithPredicate:(NSPredicate *)predicate;

- (Cart *) newCart;
- (User *) newUser;
- (Request *) newRequest;

- (void) deleteCart:(Cart *)cart;
- (void) deleteUser:(User *)user;
- (void) deleteRequest:(Request *)request;

- (bool) save;

@end
