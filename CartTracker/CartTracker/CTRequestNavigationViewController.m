//
//  CTRequestNavigationViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTRequestNavigationViewController.h"
#import "CTDataListViewController.h"

@interface CTRequestNavigationViewController ()

@end

@implementation CTRequestNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Request";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CTDataListViewController * requestController = [[CTDataListViewController alloc] initWithData:@"Requests"];
    self.viewControllers = @[requestController];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
