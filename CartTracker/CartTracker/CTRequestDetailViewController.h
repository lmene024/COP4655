//
//  CTRequestDetailViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDetailViewDelegate.h"
#import "CTADetailViewController.h"

@class Request;
@class CTcartManager;

@interface CTRequestDetailViewController : CTADetailViewController <CTDetailViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *reqIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *cartTextField;
@property (strong, nonatomic) IBOutlet UITextField *reqStTextField;
@property (strong, nonatomic) IBOutlet UITextField *reqDateTextField;
@property (strong, nonatomic) IBOutlet UIButton *processButton;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UITextField *requestStartTime;
@property (strong, nonatomic) IBOutlet UITextField *requestEndTime;

@property (strong, nonatomic) Request *request;

@property (strong, nonatomic) CTcartManager *manager;
- (IBAction)processRequest:(id)sender;

@end
