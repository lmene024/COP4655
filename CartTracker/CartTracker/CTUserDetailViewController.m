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
@synthesize licenseTextField,firstNameTextField,lastNameTextField,pantherIdTextField,passwordTextField,adminSwitch;
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
        //Creating a new user
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
        [self.emailTextField setText:user.email];
        [self.passwordTextField setText:user.password];
        [self.adminSwitch setOn:user.isAdmin.boolValue animated:true];
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
        
        //don't forget to save changes
        if (user!=nil) {
            [self saveUserDataForUser:user];
        }
        
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
    [self.emailTextField setBorderStyle:borderStyle];
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
    [self.emailTextField setEnabled:booleanValue];
    [self.adminSwitch setEnabled:booleanValue];
    //[self.passwordTextField setEnabled:booleanValue]; do not enable password outright check admin first
    [self.passwordTextField setEnabled:(self.adminSwitch.isOn && booleanValue)];
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
        || (adminSwitch.isOn && FIELD_ISEMPTY(self.passwordTextField.text))) {
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

- (bool) saveUserDataForUser:(User *)aUser{
    if (![self fieldsAreEmpty]) {
        
        [aUser setDriversLicense:self.licenseTextField.text];
        [aUser setEmpID:self.pantherIdTextField.text];
        [aUser setFirstName:self.firstNameTextField.text];
        [aUser setLastName:self.lastNameTextField.text];
        [aUser setPassword:self.passwordTextField.text];
        [aUser setEmail:self.emailTextField.text];
        [aUser setIsAdmin:[NSNumber numberWithBool:self.adminSwitch.isOn]];
        
        [self.manager save];
        return true;
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Some Fields are Empty"
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    return false;
}

- (IBAction)saveButton:(id)sender{
    
    User *aUser = [self.manager newUser];
    
    if ([self saveUserDataForUser:aUser]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}*/


- (IBAction)changeAdmin:(id)sender {
    passwordTextField.enabled = adminSwitch.isOn;
    if (user && ![sender isOn]) {
        //make sure we still have an available admin otherwise we will be locked out
        NSPredicate * findAdmins = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSNumber* admin =  [evaluatedObject isAdmin];
            bool isAdmin = [admin boolValue];
            return isAdmin;
        }];
        NSError * error = nil;
        NSArray * adminArray = [manager.context executeFetchRequest:[manager getUsersWithPredicate:findAdmins] error:&error];
        
        for (User* aUser in adminArray) {
            NSLog(@"Admin: %@ %@", aUser.firstName, aUser.lastName);
        }
        
        if (!adminArray.count>1) {
            //switch it back
            [adminSwitch setOn:true];
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Set Admin Error"
                                  message:@"Sorry, you must keep at least one admin, set another user to admin before changing this user"
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
            [alert show];
           
        }
    }
}
@end
