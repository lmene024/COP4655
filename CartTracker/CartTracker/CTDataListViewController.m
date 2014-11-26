//
//  CTDataListViewController.m
//  CartTracker
//
//  Created by leo on 11/25/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTDataListViewController.h"
#import "CTcartManager.h"
#import "Cart.h"

@interface CTDataListViewController ()

@end

@implementation CTDataListViewController

@synthesize manager;


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
    
    
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewItem:)];
    self.navigationItem.rightBarButtonItem = addItem;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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


- (NSFetchedResultsController *) dataController{
    if (_dataController != nil) {
        return _dataController;
    }
    
    NSFetchRequest * fetchRequest;
    if ([self.title isEqualToString:@"Carts"]) {
        fetchRequest = [manager getCarts];
    }
    
    NSFetchedResultsController * fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[manager context] sectionNameKeyPath:nil cacheName:self.title.copy];
    
    fetchedResultsController.delegate = self;
    self.dataController = fetchedResultsController;
    
    NSError * error = nil;
    if (![self.dataController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _dataController;
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
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


- (void) insertNewItem:(id) sender{
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext:manager.context];
    Cart * cart = [[Cart alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:manager.context];
    [cart setCartID:@"001"];
    [cart setCartName:@"My First Cart"];
    
    NSError * error = nil;
    bool saveResult = [manager.context save:&error];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.title forIndexPath:indexPath];
    // Configure the cell...
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.title];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    return cell;
}

- (void) setupCell:(UITableViewCell *) cell forIndexPath: (NSIndexPath *) indexPath{
    if ([self.title isEqualToString:@"Carts"]) {
        Cart * aCart = [self.dataController objectAtIndexPath:indexPath];
        cell.textLabel.text = aCart.cartName;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
