//
//  CTProcessRequestViewController.m
//  CartTracker
//
//  Created by leo on 12/4/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTProcessRequestViewController.h"
#import "CTcartManager.h"
#import "User.h"
#import "Request.h"
#import "Cart.h"
#import "Constants.h"

@interface CTProcessRequestViewController ()

@property (strong, nonatomic) CTcartManager * manager;
@end

@implementation CTProcessRequestViewController
{
    NSArray * userArray;
    NSMutableArray * filterArray;
    User * userToProcess;
    Request *requestToProcess;
    Cart * cartToProcess;
}

#pragma mark - Properties

@synthesize manager, searchUserBar, actionButton;

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Process";
        manager = [[CTcartManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //initially hide all views
    self.loanView.hidden = true;
    self.returnView.hidden = true;
    self.actionButton.hidden = true;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegates
#pragma mark UISearchBar

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchUserBar setText:[searchUserBar text]];
    [searchUserBar setShowsCancelButton:false animated:true];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchUserBar setShowsCancelButton:true animated:true];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [filterArray removeAllObjects];
    
    if (searchText.length !=0) {
        [self loadFilterArray];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setText:@""];

    [searchBar setShowsCancelButton:false animated:true];
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:false animated:true];
    [searchBar resignFirstResponder];
}

- (void) loadFilterArray{
    NSString * searchString = self.searchUserBar.text;
    NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(User* aUser, NSDictionary *bindings) {
        NSComparisonResult result = [aUser.firstName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        NSComparisonResult result2 = [aUser.lastName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        return (result == NSOrderedSame) || (result2 == NSOrderedSame);
    }];
    
    if (filterArray == nil) {
        filterArray = [NSMutableArray arrayWithArray:[userArray filteredArrayUsingPredicate:predicate]];
    }else
        [filterArray addObjectsFromArray:[userArray filteredArrayUsingPredicate:predicate]];
    
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    User * aUser = [filterArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [self getFormatedNameWithFirst:aUser.firstName andLast:aUser.lastName];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    userToProcess = [filterArray objectAtIndex:indexPath.row];
    NSLog(@"userToProcess:%@ %@",userToProcess.firstName,userToProcess.lastName);
    [self.searchUserBar setText:[self getFormatedNameWithFirst:userToProcess.firstName andLast:userToProcess.lastName]];
    
    [self.searchUserBar resignFirstResponder];
    [self.searchUserBar setShowsCancelButton:false animated:false];
#warning not sure why but there are two table views showing up here...
    [self.searchDisplayController setActive:false animated:true];
    [self displayRequestForUser:userToProcess];
}

#pragma mark Methods for UITableView

- (NSString *) getFormatedNameWithFirst:(NSString *) firstName andLast: (NSString *) lastName{
    return [NSString stringWithFormat:@"%@, %@", lastName, firstName];
}

- (void) displayRequestForUser:(User *) aUser{
    
    NSSet * allRequests = aUser.requests;
    
    NSSet * requestSet = [allRequests filteredSetUsingPredicate:[self getCurrentItems]];
    
    NSLog(@"User: %@ #ofrequests %d",aUser.firstName,[aUser.requests count]);
    
    NSLog(@"getCurrentIterms: %@",[self getCurrentItems]);
    
    NSLog(@"requestSet: %@",requestSet);
    
    Request * request;
    
    if (requestSet.count>0) {
        request = [requestSet allObjects][0];
    }
    
    if (request) {
        Cart * cart = request.cart;
        requestToProcess = request;
        cartToProcess = cart;
        userToProcess = aUser;
        
        NSLog(@"Display Request");
        
        self.requestID.text = request.reqID.stringValue;
        self.requestCart.text = cart.cartName;
        self.requestUser.text = aUser.empID;
        self.requestStatus.text = [request.reqStatus stringValue];
        //self.requestDate.text = request.schedStartTime;
        NSLog(@"button enabled");
        self.detailView.hidden = false;

        //enable action button
        [self.actionButton setEnabled:true];
        
        requestToProcess = request;
    }
}

- (NSPredicate *) getCurrentItems{
    NSDate * startTime, * endTime = [NSDate date];
    endTime = [endTime dateByAddingTimeInterval:MAX_REQUEST_TIME_VARIANCE];
    
    startTime = [startTime dateByAddingTimeInterval:-(MAX_REQUEST_TIME_VARIANCE)];
    
    NSPredicate * currentItemsOnly = [NSPredicate predicateWithBlock:^BOOL(Request* request, NSDictionary *bindings) {
        NSComparisonResult * start = (NSComparisonResult *)[request.schedStartTime compare: startTime];
        NSComparisonResult * end = (NSComparisonResult *)[request.schedEndTime compare:endTime];
        
        return  (start != NSOrderedDescending && end!=NSOrderedAscending) && request.reqStatus.intValue == REQUEST_STATUS_SCHEDULED;
    }];
    return currentItemsOnly;
}


#pragma mark - Save Request Methods

/*! Method that takes an NSString string and formats the value into an
    NSNumber object.
 
 @param NSString string
 @return NSNumber
 
 */

-(NSNumber*)formatStringToNSNumber:(NSString*)string{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * number = [f numberFromString:string];
    
    return number;
}

/*! MEethod that validates if the fields are empty or not
 
 @param
 @return
 
 */

-(BOOL) fieldsAreEmpty{
    
    if ( FIELD_ISEMPTY(self.requestID.text)
        || FIELD_ISEMPTY(self.requestCart.text)
        || FIELD_ISEMPTY(self.requestUser.text)
        || FIELD_ISEMPTY(self.requestStatus.text)) {
        return YES;
    }
    
    return NO;
}

/*! Method that updates a request's status
 
 @param
 @return
 
 */

- (BOOL) saveRequestDataForRequest{
    if (![self fieldsAreEmpty]) {
        
        NSNumber *requestId = [self formatStringToNSNumber:self.requestID.text];
        NSNumber *requestStatus = [self formatStringToNSNumber:self.requestStatus.text];
        
        [requestToProcess setReqID:requestId];
        [requestToProcess setReqStatus:requestStatus];
        [requestToProcess setCart:cartToProcess];
        [requestToProcess setUser:userToProcess];
        
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

#pragma mark - IBAction

- (IBAction)actionButtonPressed:(id)sender {
    NSLog(@"Action button pressed");
    //Check which function we are performing
    if (self.chooserView.selectedSegmentIndex == 0) {
        if (requestToProcess.cart.qrCode!=nil) {
            //Start QR scanner
            [self scanQrCode:nil];
        }else{
            //process manually
            
        }
    }else{
        if (requestToProcess != nil) {
            //check if request is open
            if (requestToProcess.reqStatus.intValue == REQUEST_STATUS_INPROCESS) {
                //set it to completed
                requestToProcess.reqStatus = [NSNumber numberWithInt:REQUEST_STATUS_COMPLETED];
                [manager save];
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Request Complete"
                                                                 message:@"Your Request has been closed"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}


- (IBAction)scanButtonPressed:(id)sender {
    [self scanQrCode:nil];
}

- (IBAction)toggleView:(UISegmentedControl *)sender {
    self.actionButton.hidden = false;
    self.actionButton.enabled = false;
    if(sender.selectedSegmentIndex == 0){
        //show loan view
        self.loanView.hidden = false;
        
        //hide return view
        self.returnView.hidden = true;
        
        //reset dependent views
        self.detailView.hidden = true;
        
        //change button text
        [self.actionButton setTitle:@"Loan Cart" forState:self.actionButton.state];
        [self.actionButton setTitle:@"Loan Cart" forState:UIControlStateNormal];
        
        //load user data to search by user
        NSError * error = nil;
        userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
        [self loadFilterArray];
        
    }else{
        //show return view
        self.returnView.hidden = false;

        //hide loan view
        self.loanView.hidden = true;

        [self.actionButton setTitle:@"Return Cart" forState:self.actionButton.state];
        [self.actionButton setTitle:@"Return Cart" forState:UIControlStateNormal];
       
    }
}

#pragma qr scanning
- (void)scanQrCode:(id)sender {
    ZBarReaderViewController * scannerController = [ZBarReaderViewController new];
    scannerController.readerDelegate = self;
    scannerController.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner * scanner = scannerController.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentViewController:scannerController animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol = nil;
    for (symbol in results) {
        //already set first barcode to symbol
        break;
    }
    
    //check for process action
    if (self.chooserView.selectedSegmentIndex == 0) {
     
    //check if cart is correct
    if ([symbol.data compare:requestToProcess.cart.qrCode]==NSOrderedSame) {
        requestToProcess.reqStatus = [NSNumber numberWithInt:REQUEST_STATUS_INPROCESS];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Request Processed"
                                                         message:@"Your Request has been processed"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Request Error"
                                                         message:@"Your Cart Keys do not match your selected cart"
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
    }else{
        NSString * qrCode = symbol.data;
        //find request by cart QR code
        NSPredicate * cartPredicate = [NSPredicate predicateWithBlock:^BOOL(Cart * checkCart, NSDictionary *bindings) {
            return [checkCart.qrCode compare:qrCode] == NSOrderedSame;
        }];
        NSError * error = nil;
        NSArray * carts = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];
        Cart * cart = [carts filteredArrayUsingPredicate:cartPredicate][0];
        if (cart != nil) {
            //find open request for this cart
            NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(Request * checkRequest, NSDictionary *bindings) {
                return checkRequest.reqStatus.intValue == REQUEST_STATUS_INPROCESS;
            }];
            NSSet * requestSet = [cart.requests filteredSetUsingPredicate:predicate];
            Request * request;
            
            if (requestSet != nil && requestSet.count>0) {
                request = [requestSet allObjects][0];
            }
            
            if (request != nil) {
                requestToProcess = request;
            }
        }
    }
    [picker dismissViewControllerAnimated:true completion:nil];
}


@end

