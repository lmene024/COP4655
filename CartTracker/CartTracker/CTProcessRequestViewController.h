//
//  CTProcessRequestViewController.h
//  CartTracker
//
//  Created by leo on 12/4/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTProcessRequestViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *loanView;
@property (strong, nonatomic) IBOutlet UIView *returnView;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;


@property (strong, nonatomic) IBOutlet UISearchBar *searchUserBar;
@property (strong, nonatomic) IBOutlet UITableView *userTableView;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;


- (IBAction)toggleView:(UISegmentedControl *)sender;

- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)scanButtonPressed:(id)sender;

@end
