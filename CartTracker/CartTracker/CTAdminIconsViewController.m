//
//  CTAdminIconsViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/8/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//
// Class Description: CTAdminIconsViewController contains three buttons that link to
// the Cart, User Statistics and LogOut views.

#import "CTAdminIconsViewController.h"
#import "Constants.h"
#import "CTDataListViewController.h"
#import "CTLoginViewController.h"
#import "CTcartManager.h"

@interface CTAdminIconsViewController ()

@end

@implementation CTAdminIconsViewController
@synthesize firstTimeLogin;
@synthesize manager;

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
    
    self.title = @"Admin";
    if (self.firstTimeLogin == YES) {
        NSLog(@"inside AdminIcons");
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userButtonPressed:(id)sender {
    
    CTDataListViewController *userController = [[CTDataListViewController alloc] initWithData:@"Users"];
    userController.firstTimeLogin = self.firstTimeLogin;
    if (firstTimeLogin == YES) {
        NSLog(@"AdminIcon Bool %hhd",self.firstTimeLogin);
        [self.navigationController pushViewController:userController animated:NO];
    } else {
        [self.navigationController pushViewController:userController animated:YES];
    }
    
}

- (IBAction)cartButtonPressed:(id)sender {
    CTDataListViewController *cartsController = [[CTDataListViewController alloc] initWithData:@"Carts"];
    [self.navigationController pushViewController:cartsController animated:YES];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        CTLoginViewController *loginController = [[CTLoginViewController alloc] init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginController];
    }
}

- (IBAction)statisticsButtonPressed:(id)sender {
}

- (IBAction)logOutButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Confirmation"
                          message:@"Are you sure you want to log out"
                          delegate:self
                          cancelButtonTitle:@"Yes"
                          otherButtonTitles:@"No", nil];
    
    [alert show];
}
@end
