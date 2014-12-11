//
//  CTLoginViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//
// Class Description: CTLoginViewController is in charge of validating the login process of a user

#import "CTUserDetailViewController.h"
#import "CTLoginViewController.h"
#import "CTViewController.h"
#import "Constants.h"
#import "User.h"

@interface CTLoginViewController ()

@end

@implementation CTLoginViewController
{
    NSArray *userArray;
    BOOL firstTimeUser;
}

#pragma mark - Properties

@synthesize manager;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginView;
@synthesize backgroundImage;
@synthesize backgroundLogo;

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
    
    self.manager = [[CTcartManager alloc]init];
    NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    userArray = [[NSArray alloc] initWithArray:array];
    
    [self firstTimeAuthentification];
    
    // Do any additional setup after loading the view from its nib.
    //[self popupImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)buttonPressed:(id)sender {
    
    NSLog(@"Button Pressed");
    
    if (firstTimeUser == YES) {
        CTAdminNavigationViewController *nav = [[CTAdminNavigationViewController alloc] init];
        nav.firstTimeLogin = firstTimeUser;
        NSLog(@"controller firstTimeLogin : %hhd",nav.firstTimeLogin);
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        if ([self validateCredentials]) {
            CTViewController *controller = [[CTViewController alloc] init];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    
}

#pragma mark - Validation

-(BOOL) validateCredentials{
    
    BOOL result = NO;
    
        if ([self compareUser:self.usernameTextField.text
                 withPassword:self.passwordTextField.text]) {
            CTViewController *controller = [[CTViewController alloc] init];
            [self presentViewController:controller animated:YES completion:nil];
            result = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Check username or password"
                                  delegate:self
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil];
            [alert show];
            result = NO;
        }
    
    return result;
}

-(BOOL) firstTimeAuthentification{
    
    if ([userArray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Login"
                              message:@"Welcome to Cart Tracker! Press Sign In to create a new user"
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
        [alert show];
        firstTimeUser = YES;
        NSLog(@"firstTimeUser : %hhd",firstTimeUser);
        return YES;
    } else {
        return NO;
    }
    
}

-(BOOL) compareUser:(NSString*)user withPassword:(NSString*) password{
    
    BOOL userIsValid = NO;
    
#if DEBUG
    return YES;
#endif
    
    //NSLog(@"Testing compare user");
    for (User *aUser in userArray) {
        //NSLog(@"%@ %@",aUser.email,aUser.password);
        if ([aUser.email isEqualToString:user]) {
            //NSLog(@"ADKNFASDF");
            if ([aUser.password isEqualToString:password]) {
                NSLog(@"FOUND %@ %@",aUser.email,aUser.password);
                userIsValid = YES;
            }
        }
    }
    
    return userIsValid;
}

- (NSFetchedResultsController *) dataController{
    
    if (_dataController != nil) {
        return _dataController;
    }
    
    NSFetchRequest * fetchRequest;
    
    if (CART_VIEW) {
        fetchRequest = [manager getAllCarts];
    } else if (REQUEST_VIEW){
        fetchRequest = [manager getAllRequests];
    } else if (USERS_VIEW){
        fetchRequest = [manager getAllUsers];
    }
    
    NSFetchedResultsController * fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[manager context] sectionNameKeyPath:nil cacheName:@"test"];
    
    fetchedResultsController.delegate = self;
    self.dataController = fetchedResultsController;
    
    NSError * error = nil;
    
    if (![self.dataController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _dataController;
}

#pragma mark - UITextFieldDelegate

// Message used from the protocol

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if ([self validateCredentials]) {
        CTViewController *controller = [[CTViewController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    textField.text = @"";
    
    return YES;
}

// Click away the keyboard

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - User Interface

-(void)popupImage
{
    self.backgroundImage.hidden = NO;
    self.backgroundLogo.hidden = NO;
    [self.loginView setHidden:YES];
    self.backgroundImage.alpha = 1.0f;
    self.backgroundLogo.alpha = 1.0f;
    // Then fades it away after 2 seconds
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        self.backgroundImage.alpha = 0.0f;
        self.backgroundLogo.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view
        self.backgroundImage.hidden = YES;
    }];
    [self.loginView setHidden:NO];
}

@end
