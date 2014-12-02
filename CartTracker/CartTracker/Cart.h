//
//  Cart.h
//  CartTracker
//
//  Created by leo on 11/25/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Request;

@interface Cart : NSManagedObject

@property (nonatomic, retain) NSString * cartID;
@property (nonatomic, retain) NSString * cartName;
@property (nonatomic, retain) NSString * qrCode;
@property (nonatomic, retain) NSString * tagNumber;
@property (nonatomic, retain) NSNumber * useCount;
@property (nonatomic, retain) NSSet *requests;

@end

@interface Cart (CoreDataGeneratedAccessors)

- (void)addRequestsObject:(Request *)value;
- (void)removeRequestsObject:(Request *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

@end
