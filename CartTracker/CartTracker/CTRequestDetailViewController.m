//
//  CTRequestDetailViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTRequestDetailViewController.h"
#import "Request.h"
#import "User.h"
#import "Cart.h"

@interface CTRequestDetailViewController ()

@end

@implementation CTRequestDetailViewController

#pragma mark - Properties

@synthesize request;
@synthesize reqIdTextField;
@synthesize reqStTextField;
@synthesize userTextField;
@synthesize cartTextField;

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.request != nil) {
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self loadDataToView];
        [self enableFields:NO andSetBorderStyle:UITextBorderStyleNone];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadDataToView{
    if (self.request != nil) {
        
        NSString *date = [NSDateFormatter
                          localizedStringFromDate:self.request.reqDate
                          dateStyle:NSDateFormatterShortStyle
                          timeStyle:NSDateFormatterNoStyle];
        
        [self.reqIdTextField setText:[self.request.reqID stringValue]];
        [self.reqDateTextField setText:date];
        NSLog(@"From: %@ To: %@",[self.request schedStartTime],[self.request schedEndTime]);
        [self.reqStTextField setText:[self.request.reqStatus stringValue]];
        [self.userTextField setText:self.request.user.firstName];
        [self.cartTextField setText:self.request.cart.cartID];
    }
}

#pragma mark - User Interface

/*! Description Set border style to the UITextFields
 
 @param UITextBorderStyle
 @return void
 
 */

-(void) setBorderStyleToUITextFields:(UITextBorderStyle) borderStyle{
    
    [self.reqIdTextField setBorderStyle:borderStyle];
    [self.userTextField setBorderStyle:borderStyle];
    [self.cartTextField setBorderStyle:borderStyle];
    [self.reqStTextField setBorderStyle:borderStyle];
    [self.reqDateTextField setBorderStyle:borderStyle];
}

/*! Description Method that enables the fields in the UI
 
 @param BOOL
 @return void
 
 */

-(void) fieldsAreEnabled:(BOOL)booleanValue{
    
    [self.reqIdTextField setEnabled:booleanValue];
    [self.reqDateTextField setEnabled:booleanValue];
    [self.reqStTextField setEnabled:booleanValue];
    [self.userTextField setEnabled:booleanValue];
    [self.cartTextField setEnabled:booleanValue];
    
}

/*! Description Method that enables/disables and sets the border style
 
 @param BOOl and UITextBorderStyle
 @return void
 
 */

-(void) enableFields:(BOOL)enableValue andSetBorderStyle:(UITextBorderStyle)borderStyle{
    [self fieldsAreEnabled:enableValue];
    [self setBorderStyleToUITextFields:borderStyle];
}

@end
