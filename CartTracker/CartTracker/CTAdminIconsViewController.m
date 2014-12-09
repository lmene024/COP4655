//
//  CTAdminIconsViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/8/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTAdminIconsViewController.h"
#import "Constants.h"
#import "CTDataListViewController.h"

@interface CTAdminIconsViewController ()

@end

@implementation CTAdminIconsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    int tag = [sender tag];
    switch (tag) {
        case USERS:
        {   CTDataListViewController *userController = [[CTDataListViewController alloc] initWithData:@"Users"];
            [self.navigationController pushViewController:userController animated:YES];
        }
            break;
        case CARTS:
        {
            CTDataListViewController *cartsController = [[CTDataListViewController alloc] initWithData:@"Carts"];
            [self.navigationController pushViewController:cartsController animated:YES];
        }
            break;
        case STATISTICS:
        {
            
        }
            break;
        case LOG_OUT:
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Confirmation"
                                  message:@"Are you sure you want to log out"
                                  delegate:self
                                  cancelButtonTitle:@"Yes"
                                  otherButtonTitles:@"No", nil];
            
            [alert show];
        }
            break;
    }
}

@end
