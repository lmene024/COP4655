//
//  CTCalendarViewController.h
//  CartTracker
//
//  Created by leo on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTcartManager;

@interface CTCalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CTcartManager * manager;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)dateChanged:(id)sender;

@end
