//
//  CTAdminIconsViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/8/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTcartManager;

@interface CTAdminIconsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *userButton;
@property (strong, nonatomic) IBOutlet UIButton *cartsButton;
@property (strong, nonatomic) IBOutlet UIButton *statisticsButton;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (nonatomic, strong) CTcartManager * manager;
@property (nonatomic, strong) NSFetchedResultsController * dataController;
@property BOOL firstTimeLogin;

- (IBAction)userButtonPressed:(id)sender;
- (IBAction)cartButtonPressed:(id)sender;
- (IBAction)statisticsButtonPressed:(id)sender;
- (IBAction)logOutButtonPressed:(id)sender;

@end
