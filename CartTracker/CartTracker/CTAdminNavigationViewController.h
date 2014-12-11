//
//  CTAdminNavigationViewController.h
//  CartTracker
//
//  Created by leo on 11/25/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTcartManager.h"

@interface CTAdminNavigationViewController : UINavigationController

@property BOOL firstTimeLogin;
@property (nonatomic, strong) CTcartManager * manager;
@property (nonatomic, strong) NSFetchedResultsController * dataController;

@end
