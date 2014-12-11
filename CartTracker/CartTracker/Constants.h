//
//  Constants.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#ifndef CartTracker_Constants_h
#define CartTracker_Constants_h

#define SORT_ASCENDING @"ASC"
#define SORT_DESCENDING @"DSC"
#define CART_VIEW [self.title isEqualToString:@"Carts"]
#define REQUEST_VIEW [self.title isEqualToString:@"Requests"]
#define USERS_VIEW [self.title isEqualToString:@"Users"]

#define FIELD_ISEMPTY(x) [(x) isEqualToString:@""]

#define REQUEST_STATUS_SCHEDULED 0
#define REQUEST_STATUS_INPROCESS 1
#define REQUEST_STATUS_COMPLETED 2

#define MAX_REQUEST_TIME_VARIANCE 60*30

#define USERS 0
#define CARTS 1
#define STATISTICS 2
#define LOG_OUT 3

#define LOAN_INTERVAL [self.intervalStepper value] * 3600

#define STAT_CART_CURR_AVAIL @"Currently Available"
#define STAT_CART_CURR_INUSE @"Currently Unavailable"
#define STAT_CART_OPEN_REQ  @"Open Requests per Cart"
#define STAT_CART_CLOSE_REQ @"Closed Requests per Cart"
#define STAT_CART_USE_TIME  @"Use Time per Cart"
#define STAT_CART_LAST_USE @"Last Cart Use"

#define STAT_USER_OPEN_REQ @"Open Requests per User"
#define STAT_USER_LATE_RET @"Late Returns per User"
#define STAT_USER_EXP_REQ @"Expired Requests per User"
#define STAT_USER_LAST_CART @"Last Cart by User"
#define STAT_USER_TOTAL_REQ @"Total Requests by User"

#define STAT_REQ_COUNT_HOURLY @"Number of Requests per Hour"
#define STAT_REQ_COUNT_WEEKLY @"Number of Requests per Week"

#define WEEK_INTERVAL 60*60*24*7


#endif
