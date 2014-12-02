//
//  CTLoginViewController.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTLoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *signInButton;

- (IBAction)buttonPressed:(id)sender;
@end
