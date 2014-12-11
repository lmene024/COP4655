//
//  CTDataListViewController.h
//  CartTracker
//
//  Created by leo on 11/25/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTcartManager;

@interface CTDataListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) CTcartManager * manager;
@property (nonatomic, strong) NSFetchedResultsController * dataController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarData;

- (instancetype) initWithData:(NSString *) dataType;

@end
