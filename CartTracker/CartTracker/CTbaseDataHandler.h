//
//  CTbaseDataHandler.h
//  CartTracker
//
//  Created by leo on 11/13/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTbaseDataHandler : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;

- (void) saveContext;
- (NSURL *) applicationDocsDirectory;

@property (strong, nonatomic) NSString * model;

+ (CTbaseDataHandler *) instance;

@end
