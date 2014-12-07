//
//  CTProcessRequestViewController.h
//  CartTracker
//
//  Created by leo on 12/4/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTProcessRequestViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UIView *loanView;
@property (strong, nonatomic) IBOutlet UIView *returnView;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;


@property (strong, nonatomic) IBOutlet UISearchBar *searchUserBar;
/*@property (strong, nonatomic) IBOutlet UITableView *tableView;*/
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

@property (strong, nonatomic) IBOutlet UITextField *requestID;
@property (strong, nonatomic) IBOutlet UITextField *requestCart;
@property (strong, nonatomic) IBOutlet UITextField *requestDate;
@property (strong, nonatomic) IBOutlet UITextField *requestStatus;
@property (strong, nonatomic) IBOutlet UITextField *requestUser;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)toggleView:(UISegmentedControl *)sender;

- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)scanButtonPressed:(id)sender;

@end
