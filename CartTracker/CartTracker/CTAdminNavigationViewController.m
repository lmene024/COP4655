//
//  CTAdminNavigationViewController.m
//  CartTracker
//
//  Created by leo on 11/25/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTAdminNavigationViewController.h"
#import "CTDataListViewController.h"
#import "CTAdminTableViewController.h"
#import "CTAdminIconsViewController.h"

@interface CTAdminNavigationViewController ()

@end

@implementation CTAdminNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Admin";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CTAdminTableViewController * tableViewController = [[CTAdminTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    CTAdminIconsViewController *adminViewController = [[CTAdminIconsViewController alloc] init];
    
    
    UIColor* color3 = [UIColor colorWithRed: 0.769 green: 0.584 blue: 0.145 alpha: 1];
    
    // Changing navigation bar appearance
    [[UINavigationBar appearance] setBarTintColor:color3];
    
    //self.viewControllers = @[tableViewController];
    self.viewControllers = @[adminViewController];

    
    //CTDataListViewController * cartController = [[CTDataListViewController alloc] initWithData:@"Carts"];
    //self.viewControllers = @[cartController];
    
    //CTDataListViewController * requestController = [[CTDataListViewController alloc] initWithData:@"Requests"];
    //self.viewControllers = @[requestController];
    
    //CTDataListViewController *userController = [[CTDataListViewController alloc] initWithData:@"Users"];
    //self.viewControllers = @[userController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
