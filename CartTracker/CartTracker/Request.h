//
//  Request.h
//  CartTracker
//
//  Created by leo on 11/16/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cart, User;

@interface Request : NSManagedObject

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * realEndTime;
@property (nonatomic, retain) NSDate * realStartTime;
@property (nonatomic, retain) NSDate * reqDate;
@property (nonatomic, retain) NSNumber * reqID;
@property (nonatomic, retain) NSNumber * reqStatus;
@property (nonatomic, retain) NSDate * schedEndTime;
@property (nonatomic, retain) NSDate * schedStartTime;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) Cart *cart;
@property (nonatomic, retain) User *user;

@end
