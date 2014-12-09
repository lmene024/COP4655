//
//  CTCartDetailViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTDetailViewDelegate.h"
#import "CTADetailViewController.h"
#import "ZBarSDK.h"
//#import "ZXingObjC.h"

@class Cart,CTcartManager;

@interface CTCartDetailViewController : CTADetailViewController <CTDetailViewDelegate, ZBarReaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *cartIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *cartNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *tagTextField;
@property (strong, nonatomic) IBOutlet UIImageView *barCodeImage;
@property (strong, nonatomic) IBOutlet UIButton *scanButton;

@property (strong, nonatomic) CTcartManager * manager;
@property (nonatomic, strong) NSFetchedResultsController * dataController;

@property (nonatomic, retain) Cart *cart;

- (IBAction)scanQrCode:(id)sender;

@end
