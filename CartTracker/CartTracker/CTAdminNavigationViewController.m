//
//  CTAdminNavigationViewController.m
//  CartTracker
//
//  Created by leo on 11/25/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//
// Class Description: CTAdminNavigationController is a sublcass of
// UINavigationViewController. It contains
// the AdminIconsViewController that handles Admin options.

#import "CTAdminNavigationViewController.h"
#import "CTDataListViewController.h"
#import "CTAdminIconsViewController.h"

@interface CTAdminNavigationViewController ()

@end

@implementation CTAdminNavigationViewController

@synthesize firstTimeLogin;

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
    
    CTAdminIconsViewController *adminViewController = [[CTAdminIconsViewController alloc] init];
    adminViewController.firstTimeLogin = self.firstTimeLogin;
    
    UIColor* color3 = [UIColor colorWithRed: 0.769 green: 0.584 blue: 0.145 alpha: 1];
    
    // Changing navigation bar appearance
    [[UINavigationBar appearance] setBarTintColor:color3];
    
    //self.viewControllers = @[tableViewController];
    self.viewControllers = @[adminViewController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
