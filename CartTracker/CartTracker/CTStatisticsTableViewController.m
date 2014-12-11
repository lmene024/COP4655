//
//  CTStatisticsTableViewController.m
//  CartTracker
//
//  Created by leo on 12/9/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTStatisticsTableViewController.h"
#import "CTStatisticsDetailViewController.h"
#import "Constants.h"


@interface CTStatisticsTableViewController ()

@end

@implementation CTStatisticsTableViewController
{
    NSArray * statistics;
    NSArray * cartStatistics;
    NSArray * userStatistics;
    NSArray * requestStatistics;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Statistics";
    
    //load underlying arrays first
    cartStatistics = @[STAT_CART_CURR_AVAIL, STAT_CART_CURR_INUSE, STAT_CART_OPEN_REQ, STAT_CART_CLOSE_REQ, STAT_CART_USE_TIME, STAT_CART_LAST_USE];
    userStatistics = @[STAT_USER_OPEN_REQ, STAT_USER_LATE_RET, STAT_USER_EXP_REQ, STAT_USER_LAST_CART, STAT_USER_TOTAL_REQ];
    requestStatistics = @[STAT_REQ_COUNT_HOURLY, STAT_REQ_COUNT_WEEKLY];
    
    //load these arrays into main array
    statistics = @[cartStatistics, userStatistics, requestStatistics];
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
    return statistics.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [statistics[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Statistics by Cart";
        case 1:
            return @"Statistics by User";
        case 2:
            return @"Statistics by Request";
        default:
            return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"statCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // Configure the cell...
    cell.textLabel.text = [[statistics objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * stat = [[statistics objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CTStatisticsDetailViewController * details = [[CTStatisticsDetailViewController alloc] initWithStatistic:stat];
    [self.navigationController pushViewController:details animated:true];
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
