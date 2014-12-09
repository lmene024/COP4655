//
//  CTCalendarNavigationViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/8/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTCalendarNavigationViewController.h"
#import "CTCalendarViewController.h"

@interface CTCalendarNavigationViewController ()

@end

@implementation CTCalendarNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Calendar";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CTCalendarViewController * calendarController = [[CTCalendarViewController alloc] init];
    
    UIColor* color3 = [UIColor colorWithRed: 0.769 green: 0.584 blue: 0.145 alpha: 1];
    
    // Changing navigation bar appearance
    [[UINavigationBar appearance] setBarTintColor:color3];
    
    self.viewControllers = @[calendarController];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
