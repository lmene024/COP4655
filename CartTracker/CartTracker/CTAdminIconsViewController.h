//
//  CTAdminIconsViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/8/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTAdminIconsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *userButton;
@property (strong, nonatomic) IBOutlet UIButton *cartsButton;
@property (strong, nonatomic) IBOutlet UIButton *statisticsButton;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
- (IBAction)buttonPressed:(id)sender;

@end
