//
//  CTLoginViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTLoginViewController.h"
#import "CTViewController.h"
#import "Constants.h"
#import "User.h"

@interface CTLoginViewController ()

@end

@implementation CTLoginViewController
{
    NSArray *userArray;
}

@synthesize manager;
@synthesize usernameTextField;
@synthesize passwordTextField;

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
    
    //NSLog(@"%@",userArray);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    NSLog(@"Button Pressed");
    
    /*if ([self validateCredentials]) {
        CTViewController *controller = [[CTViewController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Check username or password"
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
        [alert show];
    }*/
    
    CTViewController *controller = [[CTViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(BOOL) validateCredentials{
    
    return [self compareUser:self.usernameTextField.text
         withPassword:self.passwordTextField.text];
}

-(BOOL) compareUser:(NSString*)user withPassword:(NSString*) password{
    
    BOOL userIsValid = NO;
    
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
    textField.text = @"";
    
    return YES;
}

// Click away the keyboard

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

@end
