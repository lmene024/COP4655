//
//  CTRequestNewViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//
// Class Description: This view controller handles the creation of a new request in the application.
// It contains two UISearchBar objects that provide the capability to search for a valid user and available cart.

#import <MessageUI/MessageUI.h>
#import "CTRequestNewViewController.h"
#import "CTcartManager.h"
#import "User.h"
#import "Cart.h"
#import "Request.h"
#import "Constants.h"

@interface CTRequestNewViewController ()

@end

@implementation CTRequestNewViewController
{
    NSArray *userArray;
    NSMutableArray *filteredContentList;
    NSArray *cartArray;
    NSMutableArray *filteredCartArray;
    Boolean isSecondSearchBar;
 //   User *userForRequest;
 //   Cart *cartForRequest;
}

#pragma mark - Properties

@synthesize searchBar;
@synthesize tableView;
@synthesize searchBarController;
@synthesize isSearching;
@synthesize manager;
@synthesize cartSearchBar;
@synthesize requestDateLabel;
@synthesize requestDatePicker;
@synthesize notesLabel;
@synthesize notesTextView;
@synthesize confirmationComposer;
@synthesize cartForRequest, userForRequest;
@synthesize intervalStepper;
@synthesize intervalLabel;

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
    
    [self initArrays];
    
    [self initIntervalStepper];
    
    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    
    [self.cartSearchBar setBarTintColor:[UIColor whiteColor]];
    
    //[self setViewHidden:YES];
    
    [self setTitle:@"New Request"];
    
    [self.requestDatePicker setMinimumDate:[NSDate date]];
    [self.requestDatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.requestDatePicker setDate:[NSDate date]];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(saveButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;

    if (cartForRequest) {
        [self.cartSearchBar setText:cartForRequest.cartName];
       // [self searchBarTextDidBeginEditing:self.cartSearchBar];
       // [self searchBar:cartSearchBar textDidChange:cartForRequest.cartName];
       // [self searchBarTextDidEndEditing:self.cartSearchBar];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Init methods


/*! Init the cart array and filtered cart array. These are used to set up the UISearchBar
 
 @param
 @return
 
 */
-(void) initArrays{
    filteredContentList = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    userArray = [[NSArray alloc] initWithArray:array];
    
    filteredCartArray = [[NSMutableArray alloc] init];
    NSError *error2 = nil;
    NSArray *arrayCart = [manager.context executeFetchRequest:[manager getAllCarts] error:&error2];
    cartArray = [[NSArray alloc] initWithArray:arrayCart];
}

/*! Method that initializes the UIStepper
 
 @param
 @return
 
 */

-(void) initIntervalStepper{
    [self.intervalStepper setValue:1];
    [self.intervalStepper setMaximumValue:4];
    [self.intervalStepper setMinimumValue:0];
    [self.intervalStepper setWraps:YES];
    [self.intervalStepper setAutorepeat:YES];
    NSUInteger value = self.intervalStepper.value;
    self.intervalLabel.text = [NSString stringWithFormat:@"%d", value];
}

#pragma mark - Delegates

#pragma mark UISearchBarDelegate

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setText:[searchBar text]];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.cartSearchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    
    isSearching = YES;
    
    //[self setViewHidden:YES];
    
    if (searchBar == self.cartSearchBar) {
        isSecondSearchBar = YES;
        NSLog(@"%hhu",isSecondSearchBar);
    } else {
        isSecondSearchBar = NO;
    }
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.cartSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    [filteredCartArray removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self.tableView setHidden:NO];
        //[self setViewHidden:YES];
        [self searchTableList];
    }
    else {
        [self.tableView setHidden:YES];
        isSearching = NO;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    if (isSecondSearchBar) {
        self.cartSearchBar.text=@"";
        cartForRequest = nil;
    }else{
        self.searchBar.text=@"";
        userForRequest = nil;
    }
    [self.tableView setHidden:YES];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.cartSearchBar setShowsCancelButton:NO animated:YES];
    [self.cartSearchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.cartSearchBar setShowsCancelButton:NO animated:YES];
    [self.cartSearchBar resignFirstResponder];
    
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;

    [self searchTableList];
}

/*! Method that performs the search for the UISearchBar
 
 @param none
 @return none
 
 */

-(void) searchTableList{
    //NSLog(@"Searching Table List...");
    
    [self setViewHidden:YES];
    [self.tableView setHidden:NO];
    
    // Searching users
    if (!isSecondSearchBar) {
        for (User *aUser in userArray) {
            NSString *searchString = self.searchBar.text;
            NSLog(@"SearchBarText: %@",self.searchBar.text);
            NSComparisonResult result = [aUser.firstName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            NSComparisonResult result2 = [aUser.lastName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            
            if ((result == NSOrderedSame) || (result2 == NSOrderedSame)) {
                NSLog(@"Testing result");
                [filteredContentList addObject:aUser];
            }
        }
    } else {
        // Searching carts
        
        NSString *searchString = self.cartSearchBar.text;
        NSLog(@"SearchBarText: %@",searchString);
        
        for (Cart *aCart in cartArray) {
            NSComparisonResult cartResult = [aCart.cartName
                                             compare:searchString
                                             options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                             range:NSMakeRange(0, [searchString length])];
            if (cartResult == NSOrderedSame) {
                NSLog(@"Testing result");
                [filteredCartArray addObject:aCart];
                //cartFound = aCart;
            }
        }
        
    }

}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //NSLog(@"sections in table view");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"rows in table view");
    
    if (!isSecondSearchBar) {
        if (isSearching) {
            return [filteredContentList count];
        }
        else {
            return [userArray count];
        }
    } else{
        if (isSearching) {
            return [filteredCartArray count];
        } else {
            return [cartArray count];
        }
    }
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (!isSecondSearchBar) {
        User *aUser = [userArray objectAtIndex:[indexPath row]];
        
        // Configure the cell...
        if (isSearching == YES) {
            User *a = [filteredContentList objectAtIndex:indexPath.row];
           /* NSMutableString *firstAndLast = [[NSMutableString alloc] initWithString:a.lastName];
            [firstAndLast appendString:@", "];
            [firstAndLast appendString:a.firstName];
            cell.textLabel.text = firstAndLast;
            */
            cell.textLabel.text = [self getFormatedNameWithFirst:a.firstName andLast:a.lastName];
        }
        else {
            /*
            NSMutableString *firstAndLast = [[NSMutableString alloc] initWithString:aUser.lastName];
            [firstAndLast appendString:@", "];
            [firstAndLast appendString:aUser.firstName];
            [cell.textLabel setText:firstAndLast];
             */
            cell.textLabel.text = [self getFormatedNameWithFirst:aUser.firstName andLast:aUser.lastName];
        }
    } else {
        
        Cart *aCart = [cartArray objectAtIndex:[indexPath row]];
        
        if (isSearching) {
            Cart *c = [filteredCartArray objectAtIndex:[indexPath row]];
            cell.textLabel.text = c.cartName;
        } else {
            [cell.textLabel setText:aCart.cartName];
        }
    }
    
    
    
    return cell;
}

/*! Method that formats a NSString firstName & NSString lastName together (e.g. Ruggiero, Andres)
 
 @param NSString firstName & NSString lastName
 @return NSString
 
 */

- (NSString *) getFormatedNameWithFirst:(NSString *) firstName andLast: (NSString *) lastName{
    return [NSString stringWithFormat:@"%@, %@", lastName, firstName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setViewHidden:NO];
    
    //[self.searchBar setText:[userArray objectAtIndex:[indexPath row]]];
    //[self.cartSearchBar setText:[cartArray objectAtIndex:[indexPath row]]];
    
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (!isSecondSearchBar){
        
       /* NSString *userName = cell.textLabel.text;
        
        [self.searchBar setText:userName];
        
        NSArray *splitName = [userName componentsSeparatedByString:@","];
        
        //splitName[0] contains the last name of the person
        userForRequest = [self searchArray:userArray withCriteria:splitName[0] theClass:[User class]];
        */
        userForRequest = [filteredContentList objectAtIndex:indexPath.row];
        [self.searchBar setText:[self getFormatedNameWithFirst:userForRequest.firstName andLast:userForRequest.lastName]];
        
    } else {
        /*
        NSString *cartName = cell.textLabel.text;
        [self.cartSearchBar setText:cartName];
        cartForRequest = [self searchArray:cartArray withCriteria:cartName theClass:[Cart class]];
         */
        cartForRequest = [filteredCartArray objectAtIndex:indexPath.row];
        [self.cartSearchBar setText:cartForRequest.cartName];
    }
    
    [self.searchBar resignFirstResponder];
    [self.cartSearchBar resignFirstResponder];
    
    [self.searchBar setShowsCancelButton:NO animated:NO];
    [self.cartSearchBar setShowsCancelButton:NO animated:NO];
    
    [self setClearButtonMode:self.searchBar];
    [self setClearButtonMode:self.cartSearchBar];

    [self.tableView setHidden:YES];
    //[self setViewHidden:NO];
}


#pragma mark MFMailComposeViewControllerDelegate

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"Inside Mail Delegate");
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[self reservationSucessful];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Email Method

-(void) composeEmailToUserEmail:(NSString*)email {
    
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"<h1>You just made a reservation!</h1>"; // Change the message body to HTML
    // To address
    NSLog(@"Message sent to email: %@",userForRequest.email);
    NSArray *toRecipents = [NSArray arrayWithObject:email];
    
    confirmationComposer = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        
        [confirmationComposer setDelegate:self];
        [confirmationComposer setMailComposeDelegate:self];
        [confirmationComposer setSubject:emailTitle];
        [confirmationComposer setMessageBody:messageBody isHTML:YES];
        [confirmationComposer setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:confirmationComposer animated:YES completion:NULL];
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        [self composeEmailToUserEmail:userForRequest.email];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else if([title isEqualToString:@"No"])
    {
        NSLog(@"Button 2 was selected.");
        //[self reservationSucessful];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - User Interface

/*! Method that sets the SetHidden property of elements of the View
 
 @param Boolean value: Yes to hide view, No otherwise
 @return
 
 */

-(void) setViewHidden:(BOOL)value{
    [self.intervalLabel setHidden:value];
    [self.intervalStepper setHidden:value];
    [requestDateLabel setHidden:value];
    [requestDatePicker setHidden:value];
    [notesLabel setHidden:value];
    [notesTextView setHidden:value];
}

/*! Method that sets clear button mode
 
 @param UISearchBar
 @return none
 
 */

-(void) setClearButtonMode:(UISearchBar *)mySearchBar{
    UITextField *textField = [mySearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
}

#pragma mark - IBAction

/*! Selector to the UIButton Save: Saves a new request
 
 @param
 @return
 
 */

-(IBAction)saveButtonPressed:(id)sender{
    
    if ((![self.cartSearchBar.text isEqualToString:@""]) & (![self.searchBar.text isEqualToString:@""])) {
        
        //Get the cart requested by the user
        BOOL cartIsValid = [self validateCarAvailability:cartForRequest forUser:userForRequest];
        
        if (cartIsValid) {
            
            Request *req = [self.manager newRequest];
            
            NSLog(@"User: %@ Cart %@",userForRequest.firstName,cartForRequest.cartName);
            
            [req setUser:userForRequest];
            [req setCart:cartForRequest];
            [req setSchedStartTime:self.requestDatePicker.date];
            NSLog(@"Request Date Picker: %@",[self.requestDatePicker date]);
            [req setSchedEndTime:[self.requestDatePicker.date dateByAddingTimeInterval:LOAN_INTERVAL]];
            NSNumber *number = [NSNumber numberWithInt: REQUEST_STATUS_SCHEDULED];
            [req setReqStatus:number];
            [req setReqDate:self.requestDatePicker.date];
            [req setNote:self.notesTextView.text];
            
            [manager save];
            
            NSLog(@"%@ Has a request from %@ to %@",userForRequest.firstName,[req schedStartTime],[req schedEndTime]);
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Email Confirmation"
                                  message:@"Do you want to send a confirmation email?"
                                  delegate:self
                                  cancelButtonTitle:@"Yes"
                                  otherButtonTitles:@"No",nil];
            [alert show];
            
        }
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

- (IBAction)intervalStepperPressed:(id)sender {
    
    double intervalStepperValue = [intervalStepper value];
    
    NSString *labelText = [[NSString alloc] initWithFormat:@"%d",(int)intervalStepperValue];
    
    self.intervalLabel.text = labelText;
    
}

#pragma mark - Validation Methods


/*! Checks if a Cart is available for a User
 
 @param Cart and User
 @return Boolean: YES if the cart is available, and NO if the cart is not available
 
 */

-(BOOL) validateCarAvailability:(Cart *)cart forUser:(User*)user{
    NSPredicate * currentItemsOnly = [NSPredicate predicateWithBlock:^BOOL(Request* request, NSDictionary *bindings) {
        NSComparisonResult * start = (NSComparisonResult *)[request.schedStartTime compare: requestDatePicker.date];
        NSComparisonResult * end = (NSComparisonResult *)[request.schedEndTime compare:requestDatePicker.date];
        
        return  (start != NSOrderedDescending && end != NSOrderedAscending);
    }];
    
    NSSet * requestSet = [cart.requests filteredSetUsingPredicate:currentItemsOnly];
    NSLog(@"requestSet count: %lu",(unsigned long)[requestSet count]);
    
    int requestCount = [requestSet count];
    
    if (requestCount == 0) {
        NSLog(@"Free");
        
        return YES;
    } else {
        NSLog(@"Request is more than 0");
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Cart is busy at the selected time"
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil,nil];
        [alert show];
        
        return NO;
    }
}

-(void) reservationSucessful{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Notification"
                          message:@"Reservation Sucessful"
                          delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil];
    [alert show];
}

/*! Method that iterates and lookds for an Element in Array with a determined Criteria
 
 @param NSArray, NSString & id
 @return
 
 */
/*
-(id) searchArray:(NSArray *)array withCriteria:(NSString*)criteria theClass:(id)element{
    if ([element class] == [Cart class]) {
        NSLog(@"CLASS CART");
        for (Cart *aCart in cartArray) {
            if ([aCart.cartName isEqualToString:criteria]) {
                NSLog(@"FOUND CART %@",aCart);
                return aCart;
            }
        }
    } else if ([element class] == [User class]){
        NSLog(@"CLASS USER");
        for (User *aUser in userArray) {
            NSLog(@"aUser name: %@ element name: %@",aUser.firstName,criteria);
            if ([aUser.lastName isEqualToString:criteria]) {
                NSLog(@"FOUND USER %@",aUser);
                return aUser;
            }
        }
    }
    
    return nil;
}
 */

@end
