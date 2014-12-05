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

@synthesize manager, searchUserBar, tableView,actionButton;

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
    //[self.loanView setHidden:FALSE];
    
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
        [self.tableView setHidden:false];
        [self loadFilterArray];
   }else{
        [self.tableView setHidden:true];
    }
    [self.tableView reloadData];

}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setText:@""];
    [self.tableView setHidden:true];
    [searchBar setShowsCancelButton:false animated:true];
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:false animated:true];
    [searchBar resignFirstResponder];
    
    self.tableView.allowsSelection = true;
    self.tableView.scrollEnabled = true;
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
    [tableView setHidden:true];
    [self.tableView setHidden:true];
    //[self setClearButtonMode:searchUserBar];
    
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
        
        self.requestID.text = request.reqID.stringValue;
        self.requestCart.text = cart.cartName;
        self.requestUser.text = aUser.empID;
        self.requestStatus.text = [request.reqStatus stringValue];
        //self.requestDate.text = request.schedStartTime;
        NSLog(@"button enabled");
        self.detailView.hidden = false;
    }
}

- (NSPredicate *) getCurrentItems{
    NSDate * now = [NSDate date];
    now = [now dateByAddingTimeInterval:MAX_REQUEST_TIME_VARIANCE];
    now = [now dateByAddingTimeInterval:-(MAX_REQUEST_TIME_VARIANCE)];
    
    NSPredicate * currentItemsOnly = [NSPredicate predicateWithBlock:^BOOL(Request* request, NSDictionary *bindings) {
        NSComparisonResult * start = (NSComparisonResult *)[request.schedStartTime compare: now];
        NSComparisonResult * end = (NSComparisonResult *)[request.schedEndTime compare:now];
        
        return  (start != NSOrderedDescending && end!=NSOrderedAscending);
    }];
    return currentItemsOnly;
}


/*-(void) setClearButtonMode:(UISearchBar *)mySearchBar{
    UITextField *textField = [mySearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
}*/



#pragma mark - Save Request Methods

-(NSNumber*)formatStringToNSNumber:(NSString*)string{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * number = [f numberFromString:string];
    
    return number;
}

-(BOOL) fieldsAreEmpty{
    
    if ( FIELD_ISEMPTY(self.requestID.text)
        || FIELD_ISEMPTY(self.requestCart.text)
        || FIELD_ISEMPTY(self.requestUser.text)
        || FIELD_ISEMPTY(self.requestStatus.text)) {
        return YES;
    }
    
    return NO;
}

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
    [self saveRequestDataForRequest];
    // Implement the ability to edit a request to add a different status
}

- (IBAction)scanButtonPressed:(id)sender {
}

- (IBAction)toggleView:(UISegmentedControl *)sender {
    self.actionButton.hidden = false;
    
    if(sender.selectedSegmentIndex == 0){
        //show loan view
        self.loanView.hidden = false;
        
        //hide return view
        self.returnView.hidden = true;
        
        //reset dependent views
        self.tableView.hidden = true;
        self.detailView.hidden = true;
        
        //change button text
        [self.actionButton setTitle:@"Loan Cart" forState:self.actionButton.state];
        
        NSError * error = nil;
        userArray = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
        [self loadFilterArray];
        
    }else{
        //show return view
        self.returnView.hidden = false;
        [self.actionButton setTitle:@"Return Cart" forState:self.actionButton.state];
        
        //hide loan view
        self.loanView.hidden = true;
    }
}

@end

