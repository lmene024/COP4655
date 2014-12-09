//
//  CTProcessRequestViewController.h
//  CartTracker
//
//  Created by leo on 12/4/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class Request, User, Cart;


@interface CTProcessRequestViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate, UISearchDisplayDelegate, ZBarReaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIView *loanView;
@property (strong, nonatomic) IBOutlet UIView *returnView;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UIView *notFoundView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *chooserView;

@property (strong, nonatomic) IBOutlet UIViewController *searchContentsController;

@property (strong, nonatomic) IBOutlet UISearchBar *searchUserBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

@property (strong, nonatomic) IBOutlet UITextField *requestID;
@property (strong, nonatomic) IBOutlet UITextField *requestCart;
@property (strong, nonatomic) IBOutlet UITextField *requestDate;
@property (strong, nonatomic) IBOutlet UITextField *requestStatus;
@property (strong, nonatomic) IBOutlet UITextField *requestUser;
@property (strong, nonatomic) IBOutlet UITextField *requestStart;
@property (strong, nonatomic) IBOutlet UITextField *requestEnd;

@property (strong, nonatomic) IBOutlet UILabel *notFoundLabel;

- (IBAction)toggleView:(UISegmentedControl *)sender;

- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)scanButtonPressed:(id)sender;

@property (strong, nonatomic) User * userToProcess;
@property (strong, nonatomic) Request *requestToProcess;
@property (strong, nonatomic) Cart * cartToProcess;


@end
