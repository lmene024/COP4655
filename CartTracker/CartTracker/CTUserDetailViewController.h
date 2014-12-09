//
//  CTUserDetailViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDetailViewDelegate.h"
#import "CTADetailViewController.h"

@class User,CTcartManager;

@interface CTUserDetailViewController : CTADetailViewController <CTDetailViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contactView;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UITextField *licenseTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *pantherIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@property (strong, nonatomic) IBOutlet UISwitch *adminSwitch;
@property (strong, nonatomic) CTcartManager * manager;

- (IBAction)changeAdmin:(id)sender;

@property (nonatomic, retain) User *user;
- (IBAction)takePicture:(id)sender;

@end