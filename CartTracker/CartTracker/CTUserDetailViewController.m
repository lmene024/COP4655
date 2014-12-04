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
{
    bool didAddImage;
}

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
        [self setTitle:@"User"];
    } else {
        //Creating a new user
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                       target:self
                                       action:@selector(saveButton:)];
        
        self.navigationItem.rightBarButtonItem = saveButton;
        [self setTitle:@"New User"];
        [self enableFields:YES andSetBorderStyle:UITextBorderStyleRoundedRect];
    }
    //set didAdd image to false to prevent saving a default image
    didAddImage = false;
}

-(void) loadDataToView{
    
    if (self.user != nil) {
        
        [self.licenseTextField setText:user.driversLicense];
        [self.firstNameTextField setText:user.firstName];
        [self.lastNameTextField setText:user.lastName];
        [self.pantherIdTextField setText:user.empID];
        [self.emailTextField setText:user.email];
        [self.passwordTextField setText:user.password];
        [self.adminSwitch setOn:user.isAdmin.boolValue animated:true];
        
        //check if we have a saved image to show
        if (user.image) {
            [self.userImage setImage:user.image];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*! Method that handles editing mode of editBarButton
 
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
        // save changes before finishing edit
        if([self saveUserDataForUser:user]){
            
            // Disabling UITextFields
            [self enableFields:NO andSetBorderStyle:UITextBorderStyleNone];
            
            self.navigationItem.hidesBackButton = NO;
            
            self.navigationItem.leftBarButtonItem = nil;
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

/*! Method that enables the fields in the UI
 
 @param Boolean
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

/*! Method that enables/disables and sets the border style
 
 @param Boolean and UITextBorderStyle
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

/*! Cancel Button selector
 
 @param
 @return
 
 */

-(IBAction)cancelButtonPressed:(id)sender{
    NSLog(@"Cancel Button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)takePicture:(id)sender {
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [sender tag] == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:true completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    userImage.image = image;
    if (!self.isEditing && user != nil) {
        //picture taken from the detail view
        [user setImage:image];
        [manager save];
    }else{
        //defer saving until the entire record is saved
        didAddImage = true;
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

/*! Save button selector
 
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
        
        if (didAddImage) {
            [aUser setImage:userImage.image];
            //reset did add flag
            didAddImage = false;
        }
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
        NSArray * userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
        
        NSArray * adminArray = [userArray filteredArrayUsingPredicate:findAdmins];
        
        for (User* aUser in adminArray) {
            NSLog(@"Admin: %@ %@", aUser.firstName, aUser.lastName);
        }
        
        if (adminArray.count<=1) {
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
