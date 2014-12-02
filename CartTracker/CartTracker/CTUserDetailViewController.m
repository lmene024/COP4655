//
//  CTUserDetailViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTUserDetailViewController.h"
#import "CTCameraViewController.h"
#import "User.h"
#import "CTcartManager.h"
#import "Constants.h"

@interface CTUserDetailViewController ()

@end

@implementation CTUserDetailViewController

#pragma mark - Properties

@synthesize user;
@synthesize userImage;
@synthesize licenseTextField,firstNameTextField,lastNameTextField,pantherIdTextField,passwordTextField;
@synthesize manager;

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
    
    if (self.user != nil) {
        // The view is loaded for an existing user
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self loadDataToView];
        [self enableFields:NO andSetBorderStyle:UITextBorderStyleNone];
    } else {
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                       target:self
                                       action:@selector(saveButton:)];
        
        self.navigationItem.rightBarButtonItem = saveButton;
        [self enableFields:YES andSetBorderStyle:UITextBorderStyleRoundedRect];
    }
}

-(void) loadDataToView{
    
    if (self.user != nil) {
        
        [self.userImage setImage:user.image];
        [self.licenseTextField setText:user.driversLicense];
        [self.firstNameTextField setText:user.firstName];
        [self.lastNameTextField setText:user.lastName];
        [self.pantherIdTextField setText:user.empID];
        [self.passwordTextField setText:user.password];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*! Description Method that handles editing mode of editBarButton
 
 @param
 @return
 
 */

-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        // Enabling UITextFields
        [self enableFields:YES andSetBorderStyle:UITextBorderStyleRoundedRect];
        
        self.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        
    } else {
        // Disabling UITextFields
        [self enableFields:NO andSetBorderStyle:UITextBorderStyleNone];
        
        self.navigationItem.hidesBackButton = NO;
        
        self.navigationItem.leftBarButtonItem = nil;
        
    }
}

#pragma mark - User Interface

/*! Description Set border style to the UITextFields
 
 @param UITextBorderStyle
 @return void
 
 */

-(void) setBorderStyleToUITextFields:(UITextBorderStyle) borderStyle{
    
    [self.licenseTextField setBorderStyle:borderStyle];
    [self.firstNameTextField setBorderStyle:borderStyle];
    [self.lastNameTextField setBorderStyle:borderStyle];
    [self.pantherIdTextField setBorderStyle:borderStyle];
    [self.passwordTextField setBorderStyle:borderStyle];
}

/*! Description Method that enables the fields in the UI
 
 @param BOOL
 @return void
 
 */

-(void) fieldsAreEnabled:(BOOL)booleanValue{
    
    [self.licenseTextField setEnabled:booleanValue];
    [self.firstNameTextField setEnabled:booleanValue];
    [self.lastNameTextField setEnabled:booleanValue];
    [self.pantherIdTextField setEnabled:booleanValue];
    [self.passwordTextField setEnabled:booleanValue];
}

/*! Description Method that enables/disables and sets the border style
 
 @param BOOl and UITextBorderStyle
 @return void
 
 */

-(void) enableFields:(BOOL)enableValue andSetBorderStyle:(UITextBorderStyle)borderStyle{
    
    [self fieldsAreEnabled:enableValue];
    [self setBorderStyleToUITextFields:borderStyle];
}

-(BOOL) fieldsAreEmpty{
    
    if ( FIELD_ISEMPTY(self.firstNameTextField.text)
        || FIELD_ISEMPTY(self.lastNameTextField.text)
        || FIELD_ISEMPTY(self.licenseTextField.text)
        || FIELD_ISEMPTY(self.pantherIdTextField.text)
        || FIELD_ISEMPTY(self.passwordTextField.text)) {
        return YES;
    }
    
    return NO;
}

#pragma mark - IBAction

/*! Description Cancel Button selector
 
 @param
 @return
 
 */

-(IBAction)cancelButtonPressed:(id)sender{
    NSLog(@"Cancel Button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)takePicture:(id)sender {
    
#warning Implement Camera View Controller
    //CTCameraViewController *cameraViewController = [[CTCameraViewController alloc] init];
    //[self.navigationController pushViewController:cameraViewController animated:NO];
    
}

/*! Description Save button selector
 
 @param
 @return
 
 */

-(IBAction)saveButton:(id)sender{
    
    User *aUser = [self.manager newUser];
    
    if (![self fieldsAreEmpty]) {
        
        [aUser setDriversLicense:self.licenseTextField.text];
        [aUser setEmpID:self.pantherIdTextField.text];
        [aUser setFirstName:self.firstNameTextField.text];
        [aUser setLastName:self.lastNameTextField.text];
        [aUser setPassword:self.passwordTextField.text];
    
        [manager save];
    
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Some Fields are Empty"
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
@end
