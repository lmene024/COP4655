//
//  CTCalendarViewController.m
//  CartTracker
//
//  Created by leo on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTCalendarViewController.h"
#import "CTcartManager.h"
#import "Cart.h"
#import "Request.h"
#import "CTCartStatusTableViewCell.h"
#import "CTRequestDetailViewController.h"
#import "CTRequestNewViewController.h"
#import "Constants.h"
#import "CTRequestNavigationViewController.h"

@interface CTCalendarViewController ()

@end

@implementation CTCalendarViewController
{
    NSArray * cartsArray;
    NSDateFormatter * sqlDateFormatter;
}
@synthesize DatePicker, tableView, manager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DatePicker.maximumDate = [NSDate distantFuture];
        DatePicker.minimumDate = [NSDate distantPast];
        
        sqlDateFormatter = [[NSDateFormatter alloc] init];
        [sqlDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        self.title = @"Calendar";
        manager = [[CTcartManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSError * error = nil;
    cartsArray = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];
    [tableView registerNib:[UINib nibWithNibName:@"CTCartStatusTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartCell"];
    //[tableView registerClass:[CTCartStatusTableViewCell class] forCellReuseIdentifier:@"CartCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cartsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"CartCell";
    
    CTCartStatusTableViewCell * cell = (CTCartStatusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CTCartStatusTableViewCell alloc] init];
    }
    
    [self setupCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void) setupCell:(CTCartStatusTableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    Cart * cart = cartsArray[indexPath.row];
    cell.cartName.text = cart.cartName;
    cell.cartID.text = cart.cartID;
    cell.cartStatus.backgroundColor = [UIColor greenColor];
    
    
    NSSet * requestSet = [cart.requests filteredSetUsingPredicate:[self getCurrentItems]];
    if (requestSet.count > 0) {
        Request * request = (Request *)[requestSet allObjects][0];
        if (request.reqStatus.intValue == REQUEST_STATUS_SCHEDULED) {
            cell.cartStatus.backgroundColor = [UIColor redColor];
        }else if (request.reqStatus.intValue == REQUEST_STATUS_INPROCESS){
            cell.cartStatus.backgroundColor = [UIColor yellowColor];
        }else
            cell.cartStatus.backgroundColor = [UIColor greenColor];
    }
}

- (NSPredicate *) getCurrentItems{
    NSPredicate * currentItemsOnly = [NSPredicate predicateWithBlock:^BOOL(Request* request, NSDictionary *bindings) {
        NSComparisonResult * start = (NSComparisonResult *)[request.schedStartTime compare: DatePicker.date];
        NSComparisonResult * end = (NSComparisonResult *)[request.schedEndTime compare:DatePicker.date];
        
        return  (start != NSOrderedDescending && end!=NSOrderedAscending);
    }];
    return currentItemsOnly;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static CTCartStatusTableViewCell * cell = nil;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell"];
    }
    
    [cell layoutIfNeeded];
    CGSize size = cell.contentView.frame.size;
    return size.height;
}

- (IBAction)dateChanged:(id)sender {
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Cart * cart = [cartsArray objectAtIndex:indexPath.row];
    NSSet * requestSet = [cart.requests filteredSetUsingPredicate:[self getCurrentItems]];
    UITabBarController * tabController = self.tabBarController;
    CTRequestNavigationViewController * reqNav;
    for (UIViewController * controller in tabController.viewControllers) {
        if ([controller isKindOfClass:[CTRequestNavigationViewController class]]) {
            reqNav = (CTRequestNavigationViewController *)controller;
            break;
        }
    }
    
    
    
    if (requestSet.count>0) {
        //show the request detail
        Request * request = [requestSet allObjects][0];
        CTRequestDetailViewController * requestDetails = [[CTRequestDetailViewController alloc] init];
        [requestDetails setRequest:request];
        
        [reqNav pushViewController:requestDetails animated:true];
        tabController.selectedViewController = reqNav;
    }else{
        //allow a new request
        CTRequestNewViewController * newRequest = [[CTRequestNewViewController alloc]init];
        newRequest.cartForRequest = cart;
        [reqNav pushViewController:newRequest animated:true];
        tabController.selectedViewController = reqNav;
    }
}
@end
