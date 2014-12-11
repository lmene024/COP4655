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
@synthesize firstTimeLogin;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CTCartStatusTableViewCell" bundle:nil] forCellReuseIdentifier:self.title];
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewItem:)];
    
    // Change color to all Navigation Buttons
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    /*NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    searchBarDataArray = [[NSArray alloc] initWithArray:array];*/
    
    self.navigationItem.rightBarButtonItem = addItem;
    
    if (self.firstTimeLogin == YES) {
        [self performSelector:@selector(insertNewItem:) withObject:nil afterDelay:0.25];
        //[self.navigationItem.rightBarButtonItem performSelector:@selector(insertNewItem:) withObject:NO afterDelay:0.25];
        /*CTUserDetailViewController *userController = [[CTUserDetailViewController alloc] init];
        userController.manager = self.manager;
        userController.firstTimeLogin = self.firstTimeLogin;
        [self.navigationController pushViewController:userController animated:YES];*/
        
    }

}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    CTCartStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.title forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell ==nil) {
        cell = [[CTCartStatusTableViewCell alloc] init];
    }
    
    [self setupCell:cell forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (REQUEST_VIEW) {
        
        static CTCartStatusTableViewCell * cell = nil;
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:self.title];
        }
        
        [cell layoutIfNeeded];
        CGSize size = cell.contentView.frame.size;
        return size.height;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void) setupCell:(CTCartStatusTableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath{
    
    NSString *cellInformation;
    
    if (CART_VIEW) {
        
        Cart * aCart = [self.dataController objectAtIndexPath:indexPath];
        
        //cellInformation = [NSString stringWithFormat:@"%@, %@",aCart]
        
        cell.textLabel.text = aCart.cartName;
        
    } else if (REQUEST_VIEW){
        
        Request *aRequest = [self.dataController objectAtIndexPath:indexPath];
        
        NSString *name = [self getFormatedNameWithFirst:aRequest.user.firstName andLast:aRequest.user.lastName];
        NSString *date = [NSDateFormatter localizedStringFromDate:aRequest.schedStartTime
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterShortStyle];
        switch (aRequest.reqStatus.intValue) {
            case REQUEST_STATUS_INPROCESS:
                cell.statusView.backgroundColor = [UIColor yellowColor];
                break;
            case REQUEST_STATUS_COMPLETED:
                cell.statusView.backgroundColor = [UIColor redColor];
                break;
            default:
                cell.statusView.backgroundColor = [UIColor greenColor];
                break;
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //put everything on one line
            cellInformation = [NSString stringWithFormat:@"%@  %@  Cart: %@", name, date, aRequest.cart.cartName];
            cell.centerText.text = cellInformation;
        }else{
            //split up the info
            cellInformation = [NSString stringWithFormat:@"%@", name];
            NSString * cellSub = [NSString stringWithFormat:@"%@ Cart: %@", date, aRequest.cart.cartName];
            cell.mainText.text = cellInformation;
            cell.subText.text = cellSub;
        }
       
        
        
    } else if (USERS_VIEW){
        
        User *aUser = [self.dataController objectAtIndexPath:indexPath];
        
        cellInformation = [self getFormatedNameWithFirst:aUser.firstName andLast:aUser.lastName];
        
        cell.textLabel.text = cellInformation;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
}

- (NSString *) getFormatedNameWithFirst:(NSString *) firstName andLast: (NSString *) lastName{
    return [NSString stringWithFormat:@"%@, %@", lastName, firstName];
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
            
            if ([self validateUserDeletion:aUser]) {
                NSLog(@"User deleted: %@",aUser.firstName);
                [manager deleteUser:aUser];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:@"Can't delete a user with pending requests"
                                      delegate:self
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } else if (CART_VIEW) {
            
            Cart *aCart = [self.dataController objectAtIndexPath:indexPath];
            
            NSLog(@"User deleted: %@",aCart.cartName);
            
            [manager deleteCart:aCart];
            
        } else if (REQUEST_VIEW){
            Request *aRequest = [self.dataController objectAtIndexPath:indexPath];
            NSLog(@"Reques Deleted: %@",aRequest.reqID);
            if ([self validateRequestDeletion:aRequest]) {
                [manager deleteRequest:aRequest];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Can't delete a request once it has been processed"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
        [manager save];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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
        cartDetailViewController.manager = self.manager;
        [self.navigationController
         pushViewController:cartDetailViewController
         animated:YES];
        
    } else if (REQUEST_VIEW){
        
        Request *aRequest = [self.dataController objectAtIndexPath:indexPath];
        CTRequestDetailViewController *requestDetailViewController = [[CTRequestDetailViewController alloc] init];
        requestDetailViewController.request = aRequest;
        requestDetailViewController.manager = self.manager;
        [self.navigationController
         pushViewController:requestDetailViewController
         animated:YES];
        
    } else if (USERS_VIEW){
        
        User *aUser = [self.dataController objectAtIndexPath:indexPath];
        CTUserDetailViewController *userDetailViewController = [[CTUserDetailViewController alloc] init];
        userDetailViewController.user = aUser;
        userDetailViewController.manager = self.manager;
        NSLog(@"User %@ has #requests: %lu",aUser.firstName,(unsigned long)[aUser.requests count]);
        [self validateUserDeletion:aUser];
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
        NSLog(@"Cart View");
        CTCartDetailViewController *cartController = [[CTCartDetailViewController alloc] init];
        cartController.manager = self.manager;
        cartController.cart = nil;
        [self.navigationController pushViewController:cartController animated:YES];
        
    } else if (REQUEST_VIEW) {
        
        CTRequestNewViewController *requestController = [[CTRequestNewViewController alloc] init];
        requestController.manager = self.manager;
        [self.navigationController pushViewController:requestController animated:YES];
        
    } else if (USERS_VIEW){
        NSLog(@"USers VIew");
        CTUserDetailViewController *userController = [[CTUserDetailViewController alloc] init];
        userController.user = nil;
        userController.manager = self.manager;
        userController.firstTimeLogin = self.firstTimeLogin;
        [self.navigationController pushViewController:userController animated:NO];
        
    }
    
    //[manager save];
}

#pragma mark - Validation

/*! Validates if a user has any pending or active requests. It he/she has any, then the method
 return YES. Otherwise NO
 
 @param User
 @return Boolean
 
 */

-(BOOL) validateUserDeletion:(User*)aUser{
    
    NSSet * requestSet = aUser.requests;
    if (requestSet.count > 0) {
        for (Request *req in requestSet) {
            if ((req.reqStatus.intValue == REQUEST_STATUS_SCHEDULED) ||
                (req.reqStatus.intValue == REQUEST_STATUS_INPROCESS) ){
                NSLog(@"Has an Active Request");
                return NO;
            }
        }
    }
    return YES;
}

- (bool) validateRequestDeletion:(Request *) request{
    return request.reqStatus.intValue == REQUEST_STATUS_SCHEDULED;
}

@end
