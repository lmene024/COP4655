//
//  CTViewController.m
//  CartTracker
//
//  Created by leo on 11/13/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTViewController.h"
#import "CTAdminNavigationViewController.h"
#import "CTRequestNavigationViewController.h"
#import "CTCalendarViewController.h"

@interface CTViewController ()

@end

@implementation CTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CTAdminNavigationViewController * adminController = [[CTAdminNavigationViewController alloc] init];
    CTRequestNavigationViewController *requestController = [[CTRequestNavigationViewController alloc] init];
    CTCalendarViewController * calendarController = [[CTCalendarViewController alloc] init];
    
    self.viewControllers = @[adminController,requestController, calendarController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

@end
