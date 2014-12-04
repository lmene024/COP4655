//
//  CTDataListViewController.m
//  CartTracker
//
//  Created by leo on 11/25/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTDataListViewController.h"
#import "CTCartDetailViewController.h"
#import "CTUserDetailViewController.h"
#import "CTRequestDetailViewController.h"
#import "CTRequestNewViewController.h"
#import "CTCartStatusTableViewCell.h"
#import "CTcartManager.h"
#import "Cart.h"
#import "Request.h"
#import "User.h"
#import "Constants.h"

@interface CTDataListViewController ()

@end

@implementation CTDataListViewController

#pragma mark - Properties

@synthesize manager;

#pragma mark - UIViewController

- (instancetype) init{
    //Prevent direct use of init without sepcifying data type
    return nil;
}

- (instancetype) initWithData:(NSString *)dataType{
    self = [super init];
    if (self) {
        self.title = dataType;
        self.manager = [[CTcartManager alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //searchBarFilteredArray = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.title];
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewItem:)];
    
    /*NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    searchBarDataArray = [[NSArray alloc] initWithArray:array];*/
    
    
    
    self.navigationItem.rightBarButtonItem = addItem;

}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"DidBeginEditing");
    
    isSearching = YES;
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [searchBarFilteredArray removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        //[self.tableView setHidden:YES];
        isSearching = NO;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //NSLog(@"Cancel clicked");
    
    self.searchBar.text=@"";
    
    //[self.tableView setHidden:YES];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    [self searchTableList];
}

-(void) searchTableList{
    //NSLog(@"Searching Table List...");
    
    [self.tableView setHidden:NO];
    
    NSString *searchString = self.searchBar.text;
    
    NSLog(@"SearchBarText: %@",self.searchBar.text);
    
    for (User *aUser in searchBarDataArray) {
        
        NSComparisonResult resultFirstName = [self compareString:aUser.firstName toSearchString:searchString];
        
        NSComparisonResult resultLastName = [self compareString:aUser.lastName toSearchString:searchString];
        
        if ((resultFirstName == NSOrderedSame) || (resultLastName == NSOrderedSame)) {
            NSLog(@"Testing result");
            [searchBarFilteredArray addObject:aUser];
        }
    }
    
}

-(NSComparisonResult) compareString:(NSString*)string toSearchString:(NSString*)searchString{
    
    NSComparisonResult result = [string compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
    
    return result;
}*/


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.dataController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.dataController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.title forIndexPath:indexPath];
    CTCartStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.title forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell ==nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.title];
        //cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        cell = [[CTCartStatusTableViewCell alloc] init];
    }
    
    [self setupCell:cell forIndexPath:indexPath];
    return cell;
}


- (void) setupCell:(UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath{
    
    NSString *cellInformation;
    
    if (CART_VIEW) {
        
        Cart * aCart = [self.dataController objectAtIndexPath:indexPath];
        
        //cellInformation = [NSString stringWithFormat:@"%@, %@",aCart]
        
        cell.textLabel.text = aCart.cartName;
        
    } else if (REQUEST_VIEW){
        
        Request *aRequest = [self.dataController objectAtIndexPath:indexPath];
        
        // Show open requests only
        if (aRequest.reqStatus == [NSNumber numberWithInt:1]) {
            cellInformation = [NSString stringWithFormat:@"%@  %@  %@",aRequest.reqID,aRequest.cart.cartID,aRequest.user.firstName];
        }
        
        cell.textLabel.text = cellInformation;
        
    } else if (USERS_VIEW){
        
        User *aUser = [self.dataController objectAtIndexPath:indexPath];
        
        cellInformation = [NSString stringWithFormat:@"%@,  %@",aUser.lastName,aUser.firstName];
        
        cell.textLabel.text = cellInformation;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (USERS_VIEW) {
            
            User *aUser = [self.dataController objectAtIndexPath:indexPath];
            
            NSLog(@"User deleted: %@",aUser.firstName);
            
            [manager deleteUser:aUser];
            
        } else if (CART_VIEW) {
            
            Cart *aCart = [self.dataController objectAtIndexPath:indexPath];
            
            NSLog(@"User deleted: %@",aCart.cartName);
            
            [manager deleteCart:aCart];
        } else if (REQUEST_VIEW){
            Request *aRequest = [self.dataController objectAtIndexPath:indexPath];
            NSLog(@"Reques Deleted: %@",aRequest.reqID);
            [manager deleteRequest:aRequest];
        }
        
        [manager save];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

 
/*

- (void) setupCustomCell:(CTCartStatusTableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath{
    
    NSString *cellInformation;
    
    if (CART_VIEW) {
        
        Cart * aCart = [self.dataController objectAtIndexPath:indexPath];
        
        //cellInformation = [NSString stringWithFormat:@"%@, %@",aCart]
        
        cell.cartName.text = aCart.cartName;
        
    } else if (REQUEST_VIEW){
        
        Request *aRequest = [self.dataController objectAtIndexPath:indexPath];
        
        // Show open requests only
        if (aRequest.reqStatus == [NSNumber numberWithInt:1]) {
            //cellInformation = [NSString stringWithFormat:@"%@  %@  %@",aRequest.reqID,aRequest.cart.cartID,aRequest.user.firstName];
            //cell.cartName.text = aRequest.user.firstName;
            //cell.cartID.text = [aRequest.reqID stringValue];
            //cell.cartStatus.backgroundColor = [UIColor yellowColor];
        }
        
        //cell.textLabel.text = cellInformation;
        
    } else if (USERS_VIEW){
        
        User *aUser = [self.dataController objectAtIndexPath:indexPath];
        
        cellInformation = [NSString stringWithFormat:@"%@,  %@",aUser.lastName,aUser.firstName];
        
        cell.cartName.text = cellInformation;
    }
}
 
 */

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

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self setupCell:[tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - UITableViewDelegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    // Pass the selected object to the new view controller.
    
    if (CART_VIEW) {
        
        Cart * aCart = [self.dataController objectAtIndexPath:indexPath];
        CTCartDetailViewController *cartDetailViewController = [[CTCartDetailViewController alloc] init];
        cartDetailViewController.cart = aCart;
        [self.navigationController
         pushViewController:cartDetailViewController
         animated:YES];
        
    } else if (REQUEST_VIEW){
        
        Request *aRequest = [self.dataController objectAtIndexPath:indexPath];
        CTRequestDetailViewController *requestDetailViewController = [[CTRequestDetailViewController alloc] init];
        requestDetailViewController.request = aRequest;
        [self.navigationController
         pushViewController:requestDetailViewController
         animated:YES];
        
        
        
    } else if (USERS_VIEW){
        
        User *aUser = [self.dataController objectAtIndexPath:indexPath];
        CTUserDetailViewController *userDetailViewController = [[CTUserDetailViewController alloc] init];
        userDetailViewController.user = aUser;
        userDetailViewController.manager = self.manager;
        [self.navigationController
         pushViewController:userDetailViewController
         animated:YES];
        
    }
}

#pragma mark - IBAction

/*! Selector for UIBarButtonItem Add in UITableView
 
 @param
 @return
 
 */

- (void) insertNewItem:(id) sender{
    
    if (CART_VIEW) {
        
        CTCartDetailViewController *cartController = [[CTCartDetailViewController alloc] init];
        cartController.manager = self.manager;
        cartController.cart = nil;
        [self.navigationController pushViewController:cartController animated:YES];
        
    } else if (REQUEST_VIEW) {
        
        CTRequestNewViewController *requestController = [[CTRequestNewViewController alloc] init];
        requestController.manager = self.manager;
        [self.navigationController pushViewController:requestController animated:YES];
        
    } else if (USERS_VIEW){
        
        CTUserDetailViewController *userController = [[CTUserDetailViewController alloc] init];
        userController.user = nil;
        userController.manager = self.manager;
        [self.navigationController pushViewController:userController animated:YES];
        
    }
    
    //[manager save];
}


@end
