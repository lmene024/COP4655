//
//  CTbaseDataHandler.m
//  CartTracker
//
//  Created by leo on 11/13/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTbaseDataHandler.h"
#import "CTbaseDataHandlerSubclass.h"


@implementation CTbaseDataHandler

@synthesize managedObjectContext, managedObjectModel, persistentStoreCoordinator;
@synthesize model;
- (void) saveContext{
    NSError * error = nil;
    NSManagedObjectContext * managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            //FIXME - add proper error handling implementation
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (instancetype) init{
    //This Class Should not be instantiated directly
    return  nil;
}

- (instancetype) initFromSubClass{
    return [super init];
}

- (NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator * coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL * modelUrl = [[NSBundle mainBundle] URLForResource:model withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSString * storeName = [NSString stringWithFormat:@"%@.sqlite", model];
    NSURL * storeUrl = [[self applicationDocsDirectory] URLByAppendingPathComponent: storeName];
    
    NSError * error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]){
        //FIXME - add proper error handling implementation
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSURL *) applicationDocsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
