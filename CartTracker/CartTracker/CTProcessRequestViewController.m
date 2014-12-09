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
}

#pragma mark - Properties

@synthesize manager, searchUserBar, actionButton, chooserView;
@synthesize requestToProcess, userToProcess, cartToProcess;

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
    //self.chooserView.selectedSegmentIndex = 0;
    
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
        self.requestStatus.text = [self displayStatusFor:request.reqStatus.intValue];
        NSString *date = [NSDateFormatter
                          localizedStringFromDate:request.schedStartTime
                          dateStyle:NSDateFormatterShortStyle
                          timeStyle:NSDateFormatterNoStyle];
        self.requestDate.text = date;
        
        NSString * start = [NSDateFormatter localizedStringFromDate:request.schedStartTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        NSString * end = [NSDateFormatter localizedStringFromDate:request.schedEndTime dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        self.requestStart.text = start;
        self.requestEnd.text = end;
        
        NSLog(@"button enabled");
        self.detailView.hidden = false;
        self.notFoundView.hidden = true;
        
        //enable action button
        if (request.reqStatus.intValue == REQUEST_STATUS_SCHEDULED) {
            [self.actionButton setEnabled:true];
        }
        
        requestToProcess = request;
    }else{
        //remove detail view if it was shown
        self.detailView.hidden = true;
        [self.actionButton setEnabled:false];
        //load not found details
        self.notFoundLabel.text = [NSString stringWithFormat:@"No current Request was found\rfor User: %@\rPlease check at a later time!", [self getFormatedNameWithFirst:userToProcess.firstName andLast:userToProcess.lastName]];
        self.notFoundView.hidden = false;
    }
}

- (NSString *) displayStatusFor:(int) requestStatus{
    switch (requestStatus){
        case REQUEST_STATUS_COMPLETED:
            return @"Closed";
        case REQUEST_STATUS_INPROCESS:
            return @"In Process";
        case REQUEST_STATUS_SCHEDULED:
            return @"Ready";
        default:
            return @"";
    }
}

- (NSPredicate *) getCurrentItems{
    NSDate * startTime, * endTime = [NSDate date];
    endTime = [endTime dateByAddingTimeInterval:MAX_REQUEST_TIME_VARIANCE];
    
    startTime = [startTime dateByAddingTimeInterval:-(MAX_REQUEST_TIME_VARIANCE)];
    
    NSPredicate * currentItemsOnly = [NSPredicate predicateWithBlock:^BOOL(Request* request, NSDictionary *bindings) {
        NSComparisonResult * start = (NSComparisonResult *)[request.schedStartTime compare: startTime];
        NSComparisonResult * end = (NSComparisonResult *)[request.schedEndTime compare:endTime];
        
        return  (start != NSOrderedDescending && end!=NSOrderedAscending);
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
            //cannot process without assigning a QR code
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cart Error"
                                                             message:[NSString stringWithFormat:@"There is no QR code associated with %@.\rPlease add a QR code in the Admin section for this cart.", requestToProcess.cart.cartName]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:nil, nil];
            [alert show];
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
        self.notFoundView.hidden = true;
        
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
        [self processRequestWithQRData:symbol.data];
    }else{
        [self processReturnForQRData:symbol.data];
    }
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(void) processRequestWithQRData:(NSString *) qrData{
    //check if cart is correct
    UIAlertView * alert = [UIAlertView alloc];
    if ([qrData compare:requestToProcess.cart.qrCode]==NSOrderedSame) {
        //Cart is correct
        int status = requestToProcess.reqStatus.intValue;
        if (status == REQUEST_STATUS_SCHEDULED) {
            //This request is ready to process
            requestToProcess.reqStatus = [NSNumber numberWithInt:REQUEST_STATUS_INPROCESS];
            requestToProcess.realStartTime = [NSDate date];
            [manager save];
            alert = [[UIAlertView alloc] initWithTitle:@"Request Processed"
                                               message:@"Your Request has been processed\rCart is ready to lend"
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil];
        }else if(status == REQUEST_STATUS_INPROCESS){
            //This request has already been processed
            alert = [alert initWithTitle:@"Request Already Processed"
                                 message:@"This Request has already been processed!"
                                delegate:nil
                       cancelButtonTitle:@"Cancel"
                       otherButtonTitles:nil, nil];
        }else{
            //This request has ben closed
            alert = [alert initWithTitle:@"Request Closed"
                                 message:@"This Request has already been completed\rPlease cereate a new request"
                                delegate:nil
                       cancelButtonTitle:@"Cancel"
                       otherButtonTitles:nil, nil];
        }
        //clear out request details
        requestToProcess = nil;
        userToProcess = nil;
        
        self.detailView.hidden = true;
        self.actionButton.enabled =false;
        
        self.searchUserBar.text = @"";
        
    } else {
        //Wrong cart has been selected
        alert = [alert initWithTitle:@"Request Error"
                             message:@"Your Cart Keys do not match your selected cart"
                            delegate:nil
                   cancelButtonTitle:@"Cancel"
                   otherButtonTitles:nil, nil];
    }
    [alert show];
}

- (void) processReturnForQRData:(NSString *) qrData{
    //find request by cart QR code
    NSPredicate * cartPredicate = [NSPredicate predicateWithBlock:^BOOL(Cart * checkCart, NSDictionary *bindings) {
        return [checkCart.qrCode compare:qrData] == NSOrderedSame;
    }];
    UIAlertView * alert = [UIAlertView alloc];
    NSError * error = nil;
    NSArray * carts = [[manager.context executeFetchRequest:[manager getAllCarts] error:&error] filteredArrayUsingPredicate:cartPredicate];
    Cart * cart;
    if (carts!=nil && carts.count>0) {
        cart = carts[0];
    }
    if (cart != nil) {
        //find all requests for this cart that have not been closed out
        NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(Request * checkRequest, NSDictionary *bindings) {
            return checkRequest.reqStatus.intValue == REQUEST_STATUS_INPROCESS;
        }];
        NSSet * requestSet = [cart.requests filteredSetUsingPredicate:predicate];
        
        if (requestSet != nil && requestSet.count>0) {
            NSMutableArray * requestsToClose = [NSMutableArray arrayWithCapacity:requestSet.count];
            for (Request * request in requestSet) {
                if (request) {
                    request.reqStatus = [NSNumber numberWithInt:REQUEST_STATUS_COMPLETED];
                    request.realEndTime = [NSDate date];
                    [requestsToClose addObject:request.reqID];
                }
                //save
                [manager save];
            }
            alert = [alert initWithTitle:@"Requests Closed"
                                 message:[NSString stringWithFormat:@"You have successfully closed the following requests:\r %@ for Cart: %@", requestsToClose, cart.cartName]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil, nil];
        }else{
            //no cart matching this QR code
            alert = [alert initWithTitle:@"Cart Error"
                                 message:@"No Pending Requests to Close for this Cart!"
                                delegate:nil
                       cancelButtonTitle:@"Cancel"
                       otherButtonTitles:nil, nil];
        }
        
    } else{
        //no cart matching this QR code
        alert = [alert initWithTitle:@"Cart Error"
                             message:@"No Pending Requests to Close for this Cart!"
                            delegate:nil
                   cancelButtonTitle:@"Cancel"
                   otherButtonTitles:nil, nil];

    }
    [alert show];
}


@end

