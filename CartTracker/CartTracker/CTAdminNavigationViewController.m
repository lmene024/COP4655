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
#import "CTcartManager.h"
#import "Constants.h"

@interface CTAdminNavigationViewController ()

@end

@implementation CTAdminNavigationViewController

@synthesize firstTimeLogin;
@synthesize manager;

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
    adminViewController.manager = self.manager;
    adminViewController.firstTimeLogin = self.firstTimeLogin;
    
    UIColor* color3 = [UIColor colorWithRed: 0.769 green: 0.584 blue: 0.145 alpha: 1];
    
    // Changing navigation bar appearance
    [[UINavigationBar appearance] setBarTintColor:color3];
    
    //self.viewControllers = @[tableViewController];
    self.viewControllers = @[adminViewController];
    
    if (self.firstTimeLogin == YES) {
        NSLog(@"inside adminnavigation");
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [adminViewController performSelector:@selector(userButtonPressed:) withObject:NO afterDelay:0];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *) dataController{
    
    if (_dataController != nil) {
        return _dataController;
    }
    
    NSFetchRequest * fetchRequest;
    
    if (CART_VIEW) {
        fetchRequest = [manager getAllCarts];
    } else if (REQUEST_VIEW){
        fetchRequest = [manager getAllRequests];
    } else if (USERS_VIEW){
        fetchRequest = [manager getAllUsers];
    }
    
    NSFetchedResultsController * fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[manager context] sectionNameKeyPath:nil cacheName:@"test"];
    
    fetchedResultsController.delegate = self;
    self.dataController = fetchedResultsController;
    
    NSError * error = nil;
    
    if (![self.dataController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _dataController;
}


@end
