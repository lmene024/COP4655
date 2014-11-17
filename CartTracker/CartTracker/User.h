//
//  User.h
//  CartTracker
//
//  Created by leo on 11/16/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * driversLicense;
@property (nonatomic, retain) NSString * empID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * isAdmin;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * requestCount;
@property (nonatomic, retain) NSSet *requests;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRequestsObject:(Request *)value;
- (void)removeRequestsObject:(Request *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

@end
