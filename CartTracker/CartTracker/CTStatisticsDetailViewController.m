//
//  CTStatisticsDetailViewController.m
//  CartTracker
//
//  Created by leo on 12/10/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTStatisticsDetailViewController.h"
#import "CTcartManager.h"
#import "Constants.h"
#import "User.h"
#import "Cart.h"
#import "Request.h"

@interface CTStatisticsDetailViewController ()

@end

@implementation CTStatisticsDetailViewController{
    NSString * statistic;
    CTcartManager * manager;
}

- (instancetype) init{
    return nil;
}

- (instancetype) initWithStatistic:(NSString *)statisticToDisplay{
    self = [super init];
    if (self) {
        statistic = statisticToDisplay;
        manager = [[CTcartManager alloc] init];
        self.title = @"Statistics";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (statistic) {
        [self loadStatisticData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadStatisticData{
    if ([statistic isEqualToString: STAT_USER_OPEN_REQ]) {
        [self runUserOpenRequests];
    }else if ([statistic isEqualToString:STAT_USER_TOTAL_REQ]){
        [self runUserTotalRequests];
    }else if ([statistic isEqualToString:STAT_USER_LATE_RET]){
        [self runUserLateReturns];
    }else if ([statistic isEqualToString:STAT_USER_LAST_CART]){
        [self runUserLastCart];
    }else if ([statistic isEqualToString:STAT_USER_EXP_REQ]){
        [self runUserExpiredRequests];
    }else if ([statistic isEqualToString:STAT_REQ_COUNT_WEEKLY]){
        [self runRequestCountWeekly];
    }else if ([statistic isEqualToString:STAT_REQ_COUNT_HOURLY]){
        [self runRequestCountHourly];
    }else if ([statistic isEqualToString:STAT_CART_USE_TIME]){
        [self runCartUseTime];
    }else if ([statistic isEqualToString:STAT_CART_OPEN_REQ]){
        [self runCartOpenRequests];
    }else if ([statistic isEqualToString:STAT_CART_LAST_USE]){
        [self runCartLastUse];
    }else if ([statistic isEqualToString:STAT_CART_CURR_INUSE]){
        [self runCartsCurrentlyInUse];
    }else if ([statistic isEqualToString:STAT_CART_CURR_AVAIL]){
        [self runCartsCurrentlyAvailable];
    }else if ([statistic isEqualToString:STAT_CART_CLOSE_REQ]){
        [self runCartClosedRequests];
    }
    
}

- (NSString *) getFormatedNameWithFirst:(NSString *) firstName andLast: (NSString *) lastName{
    return [NSString stringWithFormat:@"%@, %@", lastName, firstName];
}

- (void) displayReport:(NSString *)title withData:(NSString *)data{
    self.outputField.lineBreakMode = NSLineBreakByWordWrapping;
    self.outputField.text = data;
    self.outputField.numberOfLines = 0;
    self.outputField.textAlignment = NSTextAlignmentJustified;
    
    NSLog(@"Field size: %f", self.outputField.frame.size.height);
    [self.outputField sizeToFit];
    NSLog(@"Field size: %f", self.outputField.frame.size.height);

    self.reportTitle.text = title;
}

- (void) runUserOpenRequests{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    
    NSPredicate * openRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue == REQUEST_STATUS_SCHEDULED;
    }];
    for (User *user in userArray) {
        NSSet * openRequests = [user.requests filteredSetUsingPredicate:openRequestsPredicate];
        [output appendFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], openRequests.count];
    }
    
    [self displayReport:STAT_USER_OPEN_REQ withData:output];
}

- (void) runUserTotalRequests{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    for (User *user in userArray) {
        [output appendFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], user.requests.count];
    }

    [self displayReport:STAT_USER_TOTAL_REQ withData:output];
}

- (void) runUserLateReturns{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];

    NSPredicate * lateRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        if (request.reqStatus.intValue == REQUEST_STATUS_COMPLETED){
            //check if its later that 10 min
            NSDate * targetDate = [NSDate dateWithTimeInterval:60*10 sinceDate:request.schedEndTime];
            NSComparisonResult compare = [targetDate compare:request.realEndTime];
            return compare == NSOrderedAscending;
        }
        return false;
    }];
    for (User *user in userArray) {
        NSSet * lateRequests = [user.requests filteredSetUsingPredicate:lateRequestsPredicate];
        [output appendFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], lateRequests.count];
    }
    
    [self displayReport:STAT_USER_LATE_RET withData:output];
}

- (void) runUserLastCart{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];

    NSPredicate * validRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue!=REQUEST_STATUS_SCHEDULED;
    }];
    for (User *user in userArray) {
        NSSet * validRequests = [user.requests filteredSetUsingPredicate:validRequestsPredicate];
        NSArray * sortedRequests = [[validRequests allObjects] sortedArrayUsingComparator:^NSComparisonResult(Request * r1, Request * r2) {
            return [r1.schedStartTime compare:r2.schedStartTime];
        }];
        //get last item
        Request * lastRequestForUser = [sortedRequests lastObject];
        if (lastRequestForUser) {
            [output appendFormat:@"\n%@   %@", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], lastRequestForUser.cart.cartName];
        }
    }
    
    [self displayReport:STAT_USER_LAST_CART withData:output];
}

- (void) runUserExpiredRequests{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    
    NSPredicate * expiredRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        //get open requests
        if (request.reqStatus.intValue==REQUEST_STATUS_SCHEDULED){
            //look for those that are past the end time
            NSComparisonResult result = [request.schedEndTime compare:[NSDate date]];
            return result == NSOrderedAscending;
        }
        return false;
    }];
    for (User *user in userArray) {
        NSSet * expiredRequests = [user.requests filteredSetUsingPredicate:expiredRequestsPredicate];
        [output appendFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], expiredRequests.count];
    }
    
    [self displayReport:STAT_USER_EXP_REQ withData:output];
}

- (void) runRequestCountWeekly{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * requestArray = [manager.context executeFetchRequest:[manager getAllRequests] error:&error];
    NSArray * filteredArray;
    NSString * outputFormat = @"Requests %@: %u\n";

    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps;
    unsigned int compFlags = NSYearForWeekOfYearCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    
    NSDate * firstDay;
    NSDate * lastDay;
    
    NSPredicate * weekPredicate;
    
    //setup dates for each period to analyze
    //last Week
    comps = [calendar components:compFlags fromDate:[NSDate dateWithTimeInterval:-1*WEEK_INTERVAL sinceDate:[NSDate date]]];
    [comps setWeekday:1];
    firstDay = [calendar dateFromComponents:comps];
    [comps setWeekday:7];
    lastDay = [calendar dateFromComponents:comps];

    weekPredicate = [NSPredicate predicateWithBlock:^BOOL(Request *req, NSDictionary *bindings) {
        NSComparisonResult first = [firstDay compare:req.reqDate];
        NSComparisonResult last = [lastDay compare:req.reqDate];
        return first == NSOrderedAscending && last == NSOrderedDescending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:weekPredicate];
    [output appendFormat:outputFormat, @"Last Week", filteredArray.count];

    //current week
    comps = [calendar components:compFlags fromDate:[NSDate date]];
    [comps setWeekday:1];
    firstDay = [calendar dateFromComponents:comps];
    [comps setWeekday:7];
    lastDay = [calendar dateFromComponents:comps];

    weekPredicate = [NSPredicate predicateWithBlock:^BOOL(Request *req, NSDictionary *bindings) {
        NSComparisonResult first = [firstDay compare:req.reqDate];
        NSComparisonResult last = [lastDay compare:req.reqDate];
        return first == NSOrderedAscending && last == NSOrderedDescending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:weekPredicate];
    [output appendFormat:outputFormat, @"Current Week", filteredArray.count];
    
    //nextWeek
    comps = [calendar components:compFlags fromDate:[NSDate dateWithTimeInterval:WEEK_INTERVAL sinceDate:[NSDate date]]];
    [comps setWeekday:1];
    firstDay = [calendar dateFromComponents:comps];
    [comps setWeekday:7];
    lastDay = [calendar dateFromComponents:comps];

    weekPredicate = [NSPredicate predicateWithBlock:^BOOL(Request *req, NSDictionary *bindings) {
        NSComparisonResult first = [firstDay compare:req.reqDate];
        NSComparisonResult last = [lastDay compare:req.reqDate];
        return first == NSOrderedAscending && last == NSOrderedDescending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:weekPredicate];
    [output appendFormat:outputFormat, @"Next Week", filteredArray.count];
    
    [self displayReport:STAT_REQ_COUNT_WEEKLY withData:output];
}

- (void) runRequestCountHourly{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * requestArray = [manager.context executeFetchRequest:[manager getAllRequests] error:&error];
    NSArray * filteredArray;
    NSString * outputFormat = @"Requests %@: %u\n";
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    unsigned int compFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    NSDateComponents * startTime = [[NSDateComponents alloc]init];
    NSDateComponents * endTime = [[NSDateComponents alloc] init];
    
    NSDate * startDate;
    NSDate * endDate;
    
    NSPredicate * timePredicate;
    
    //7-8am
    startTime.hour = 7;
    endTime.hour = 8;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];

        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"7:00am - 8:00am", filteredArray.count];
 
    //8-9am
    startTime.hour = 8;
    endTime.hour = 9;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"8:00am - 9:00am", filteredArray.count];

    
    //9-10am
    startTime.hour = 9;
    endTime.hour = 10;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"9:00am - 10:00am", filteredArray.count];

    //10-11am
    startTime.hour = 10;
    endTime.hour = 11;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"10:00am - 11:00am", filteredArray.count];

    
    //11am -12pm
    startTime.hour = 11;
    endTime.hour = 12;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"11:00am - 12:00pm", filteredArray.count];
   
    
    //12 -1pm
    startTime.hour = 12;
    endTime.hour = 13;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"12:00pm - 1:00pm", filteredArray.count];
    
    //1-2pm
    startTime.hour = 13;
    endTime.hour = 14;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"1:00pm - 2:00pm", filteredArray.count];
   
    //2-3pm
    startTime.hour = 14;
    endTime.hour = 15;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"2:00pm - 3:00pm", filteredArray.count];

    
    //3-4pm
    startTime.hour = 15;
    endTime.hour = 16;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"3:00pm - 4:00pm", filteredArray.count];
    
    //4-5pm
    startTime.hour = 16;
    endTime.hour = 17;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"4:00pm - 5:00pm", filteredArray.count];
    

    //5-6pm
    startTime.hour = 17;
    endTime.hour = 18;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"5:00pm - 6:00pm", filteredArray.count];
    
    //6-7pm
    startTime.hour = 18;
    endTime.hour = 19;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"6:00pm - 7:00pm", filteredArray.count];
   
    //7-8pm
    startTime.hour = 19;
    endTime.hour = 20;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"7:00pm - 8:00pm", filteredArray.count];

    //8-9pm
    startTime.hour = 20;
    endTime.hour = 21;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"8:00pm - 9:00pm", filteredArray.count];
    
    //9-10pm
    startTime.hour = 21;
    endTime.hour = 22;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"9:00pm - 10:00pm", filteredArray.count];
    
    //10-11pm
    startTime.hour = 22;
    endTime.hour = 23;
    startDate = [calendar dateFromComponents:startTime];
    endDate = [calendar dateFromComponents:endTime];
    timePredicate = [NSPredicate predicateWithBlock:^BOOL(Request * req, NSDictionary *bindings) {
        NSDateComponents * comps = [calendar components:compFlags fromDate:req.schedStartTime];
        NSDate * timeToCompare = [calendar dateFromComponents:comps];
        NSComparisonResult startResult = [startDate compare:timeToCompare];
        NSComparisonResult endResult = [endDate compare:timeToCompare];
        
        return startResult != NSOrderedDescending && endResult != NSOrderedAscending;
    }];
    filteredArray = [requestArray filteredArrayUsingPredicate:timePredicate];
    [output appendFormat:outputFormat, @"10:00pm - 11:00pm", filteredArray.count];
    
    
    
    [self displayReport:STAT_REQ_COUNT_HOURLY withData:output];
}

-(void) runCartUseTime {
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * cartArray = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];
    
    NSPredicate * closedRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue == REQUEST_STATUS_COMPLETED;
    }];
    for (Cart * cart in cartArray) {
        //calculate total use from requests
        int seconds = 0;
        for (Request * req in [cart.requests filteredSetUsingPredicate:closedRequestsPredicate]) {
            seconds += [req.realEndTime timeIntervalSinceDate:req.realStartTime];
        }
        
        [output appendFormat:@"%@ use time: %u hours\n", cart.cartName, seconds/60/60];
    }
    
    [self displayReport:STAT_CART_USE_TIME withData:output];

}

-(void) runCartOpenRequests{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * cartArray = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];

    NSPredicate * openRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue == REQUEST_STATUS_SCHEDULED;
    }];

    for (Cart * cart in cartArray) {
        NSSet * openRequests =  [cart.requests filteredSetUsingPredicate:openRequestsPredicate];
   
        
        [output appendFormat:@"%u Open Requests for %@:\n", openRequests.count, cart.cartName];
    }

    [self displayReport:STAT_CART_OPEN_REQ withData:output];
}

- (void) runCartLastUse{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * cartArray = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];

    NSPredicate * processedRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue != REQUEST_STATUS_SCHEDULED;
    }];

    for (Cart * cart in cartArray) {
        NSSet * processedRequests =  [cart.requests filteredSetUsingPredicate:processedRequestsPredicate];
        NSArray * sortedRequests = [[processedRequests allObjects] sortedArrayUsingComparator:^NSComparisonResult(Request * r1, Request * r2) {
            return [r1.schedEndTime compare:r2.schedEndTime];
        }];
        Request * lastUse = [sortedRequests lastObject];
        
        if (lastUse) {
            [output appendFormat:@"%@ last used on %@ by %@:\n", cart.cartName, [NSDateFormatter localizedStringFromDate:lastUse.schedEndTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle], [self getFormatedNameWithFirst:lastUse.user.firstName andLast:lastUse.user.lastName]];
        }
    }

    [self displayReport:STAT_CART_LAST_USE withData:output];
}

- (void) runCartsCurrentlyInUse{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * requestsArray = [manager.context executeFetchRequest:[manager getAllRequests] error:&error];
    
    NSPredicate * inUseRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue == REQUEST_STATUS_INPROCESS;
    }];
    
    int currentlyUnreturnedCarts = [[requestsArray filteredArrayUsingPredicate:inUseRequestsPredicate] count];
    
    [output appendFormat:@"%u Carts are currently in use or have not been checked in.", currentlyUnreturnedCarts];
    
    [self displayReport:STAT_CART_CURR_INUSE withData:output];
}

-(void) runCartsCurrentlyAvailable{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * cartsArray = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];
    
    NSPredicate * inUseRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue == REQUEST_STATUS_INPROCESS;
    }];
    
    int countCarts = 0;

    for (Cart * cart in cartsArray) {
        NSSet * requestsInProcessforCart = [cart.requests filteredSetUsingPredicate:inUseRequestsPredicate];
        if (requestsInProcessforCart.count == 0) {
            countCarts ++;
        }
    }
    
    [output appendFormat:@"%u Carts are currently Available for use", countCarts];
    
    [self displayReport:STAT_CART_CURR_AVAIL withData:output];
    
}

- (void) runCartClosedRequests{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * cartArray = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];
    
    NSPredicate * openRequestsPredicate = [NSPredicate predicateWithBlock:^BOOL(Request * request, NSDictionary *bindings) {
        return request.reqStatus.intValue == REQUEST_STATUS_COMPLETED;
    }];
    
    for (Cart * cart in cartArray) {
        NSSet * openRequests =  [cart.requests filteredSetUsingPredicate:openRequestsPredicate];
        
        
        [output appendFormat:@"%u Completed Requests for %@:\n", openRequests.count, cart.cartName];
    }
    
    [self displayReport:STAT_CART_CLOSE_REQ withData:output];
    
}
@end
