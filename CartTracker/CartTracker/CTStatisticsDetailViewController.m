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
    //    [self runRequestCountWeekly];
    }else if ([statistic isEqualToString:STAT_REQ_COUNT_HOURLY]){
    //    [self runRequestCountHourly];
    }else if ([statistic isEqualToString:STAT_CART_USE_TIME]){
    //    [self runCartUseTime];
    }else if ([statistic isEqualToString:STAT_CART_OPEN_REQ]){
    //    [self runCartOpenRequests];
    }else if ([statistic isEqualToString:STAT_CART_LAST_USE]){
    //    [self runCartLastUse];
    }else if ([statistic isEqualToString:STAT_CART_CURR_INUSE]){
    //    [self runCartsCurrentlyInUse];
    }else if ([statistic isEqualToString:STAT_CART_CURR_AVAIL]){
     //   [self runCartsCurrentlyAvailable];
    }else if ([statistic isEqualToString:STAT_CART_CLOSE_REQ]){
    //    [self runCartClosedRequests];
    }
    
}

- (NSString *) getFormatedNameWithFirst:(NSString *) firstName andLast: (NSString *) lastName{
    return [NSString stringWithFormat:@"%@, %@", lastName, firstName];
}

- (void) displayReport:(NSString *)title withData:(NSString *)data{
    self.outputField.lineBreakMode = NSLineBreakByWordWrapping;
    self.outputField.text = data;
    self.outputField.numberOfLines = 0;
    
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
        [output appendString:[NSString stringWithFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], openRequests.count]];
    }
    
    [self displayReport:STAT_USER_OPEN_REQ withData:output];
}

- (void) runUserTotalRequests{
    NSMutableString * output = [NSMutableString stringWithString:@""];
    NSError * error = nil;
    NSArray * userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    for (User *user in userArray) {
        [output appendString:[NSString stringWithFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], user.requests.count]];
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
        [output appendString:[NSString stringWithFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], lateRequests.count]];
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
        Request * lastRequestForUser = sortedRequests[sortedRequests.count-1];
        [output appendString:[NSString stringWithFormat:@"\n%@   %@", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], lastRequestForUser.cart.cartName]];
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
        [output appendString:[NSString stringWithFormat:@"\n%@   %u", [self getFormatedNameWithFirst:user.firstName andLast:user.lastName], expiredRequests.count]];
    }
    
    [self displayReport:STAT_USER_EXP_REQ withData:output];
}

@end
