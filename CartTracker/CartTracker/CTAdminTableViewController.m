//
//  CTAdminTableViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTAdminTableViewController.h"
#import "CTDataListViewController.h"
#import "CTLoginViewController.h"
#import "User.h"

@interface CTAdminTableViewController ()

@end

@implementation CTAdminTableViewController
{
    NSArray *adminOptions;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat startingPoint = 194.0;
    CGRect tableRect = self.view.bounds;
    tableRect.origin.y = startingPoint;
    tableRect.size.height -= startingPoint;
    
    adminOptions = [[NSArray alloc] initWithObjects:@"Users",@"Carts",@"Statistics",@"Log Out", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStyleGrouped]; // or plain, whichever you need
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; // do this if grouped, looks better!
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [adminOptions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FirstLevelCell= @"FirstLevelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
    }
    
    // Configure the cell
    
    NSLog(@"HELLOOOOO");

    cell.textLabel.text = [adminOptions objectAtIndex:[indexPath row]];
    
    return cell;
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


#pragma mark - UITableViewDelegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    NSString *option = [adminOptions objectAtIndex:[indexPath row]];
    
    if ([option isEqualToString:@"Users"]) {
        CTDataListViewController *userController = [[CTDataListViewController alloc] initWithData:@"Users"];
        [self.navigationController pushViewController:userController animated:YES];
    } else if ([option isEqualToString:@"Carts"]){
        CTDataListViewController *cartsController = [[CTDataListViewController alloc] initWithData:@"Carts"];
        [self.navigationController pushViewController:cartsController animated:YES];
    } else if ([option isEqualToString:@"Log Out"]) {
        UIAlertView *alert = [[UIAlertView alloc]
    initWithTitle:@"Confirmation"
    message:@"Are you sure you want to log out"
    delegate:self
    cancelButtonTitle:@"Yes"
    otherButtonTitles:@"No", nil];
        
        [alert show];
    }

}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        CTLoginViewController *loginController = [[CTLoginViewController alloc] init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginController];
    }
}

@end
