//
//  CTRequestDetailViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDetailViewDelegate.h"

@class Request;

@interface CTRequestDetailViewController : UIViewController <CTDetailViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *reqIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *cartTextField;
@property (strong, nonatomic) IBOutlet UITextField *reqStTextField;
@property (strong, nonatomic) IBOutlet UITextField *reqDateTextField;

@property (strong, nonatomic) Request *request;

@end