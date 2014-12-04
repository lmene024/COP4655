//
//  CTLoginViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTcartManager.h"

@interface CTLoginViewController : UIViewController <NSFetchedResultsControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@property (nonatomic, strong) CTcartManager * manager;
@property (nonatomic, strong) NSFetchedResultsController * dataController;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)buttonPressed:(id)sender;
@end