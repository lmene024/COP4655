//
//  CTViewController.h
//  CartTracker
//
//  Created by leo on 11/13/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTcartManager;

@interface CTViewController : UITabBarController

@property BOOL firstTimeLogin;
@property (nonatomic, strong) CTcartManager * manager;
@property (nonatomic, strong) NSFetchedResultsController * dataController;

@end
