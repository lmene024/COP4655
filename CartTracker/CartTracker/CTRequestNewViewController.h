//
//  CTRequestNewViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CTADetailViewController.h"


@class CTcartManager;
@class Cart;
@class User;

@interface CTRequestNewViewController : CTADetailViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) CTcartManager *manager;

@property (nonatomic, strong) NSFetchedResultsController * dataController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

@property  BOOL isSearching;

@property (strong, nonatomic) IBOutlet UISearchBar *cartSearchBar;
@property (strong, nonatomic) IBOutlet UILabel *requestDateLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *requestDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;

@property (nonatomic, retain) MFMailComposeViewController *confirmationComposer;

@property (strong, nonatomic) User *userForRequest;
@property (strong, nonatomic) Cart *cartForRequest;


@end
