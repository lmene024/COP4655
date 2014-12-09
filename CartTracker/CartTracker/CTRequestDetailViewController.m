//
//  CTRequestDetailViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//
// Class Description: The CTRequestDetailViewController is in charge of handling the detail view
// of an existing request. It offers the capability to edit & save changes to an existing request

#import "CTRequestDetailViewController.h"
#import "CTRequestNewViewController.h"
#import "CTcartManager.h"
#import "Request.h"
#import "User.h"
#import "Cart.h"
#import "Constants.h"
#import "CTProcessNavigationViewController.h"

@interface CTRequestDetailViewController ()

@end

@implementation CTRequestDetailViewController

@synthesize manager;

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

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        
        CTRequestNewViewController * editRequestController = [[CTRequestNewViewController alloc] init];
        editRequestController.existingRequest = request;
        editRequestController.manager = self.manager;
        [self.navigationController pushViewController:editRequestController animated:YES];
        self.editing = false;
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

/*-(BOOL) fieldsAreEmpty{
 
 if ( FIELD_ISEMPTY(self.reqIdTextField.text)
 || FIELD_ISEMPTY(self.reqDateTextField.text)
 || FIELD_ISEMPTY(self.reqStTextField.text)
 || FIELD_ISEMPTY(self.userTextField.text)
 || FIELD_ISEMPTY(self.cartTextField.text)) {
 return YES;
 }
 
 return NO;
 }*/

#pragma mark UIAlertView

-(void) showEmptyFieldAlertView{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:@"Some Fields are Empty"
                          delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)processRequest:(id)sender {
    //[self.navigationController]
    //UITabBarController *tabController = self.tabBarController;
}

@end
