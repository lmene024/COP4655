//
//  CTRequestNewViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTcartManager;

@interface CTRequestNewViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) CTcartManager *manager;

@property (nonatomic, strong) NSFetchedResultsController * dataController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;
@property  BOOL isSearching;

@end
