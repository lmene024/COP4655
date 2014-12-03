//
//  CTRequestNewViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTRequestNewViewController.h"
#import "CTcartManager.h"
#import "User.h"

@interface CTRequestNewViewController ()

@end

@implementation CTRequestNewViewController
{
    NSArray *userArray;
}

@synthesize searchBar;
@synthesize manager;

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
    
    NSError *error = nil;
	
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    
    userArray = [[NSArray alloc] initWithArray:array];
    
    for (User *s in userArray) {
        NSLog(@"Name: %@",s.firstName);
    }
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    //[self.searchBar becomeFirstResponder];
    [super viewDidAppear:animated];
}

#pragma mark UISearchBarDelegate

/*

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"Search Bar Begin Editing");
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Cancel Button Pressed");
    
    self.searchBar.text=@"";
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    //self.tableView.allowsSelection = YES;
    //self.tableView.scrollEnabled = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
    
    NSLog(@"HELLO WORLDDDD SEARCHING");
	
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    //self.tableView.allowsSelection = YES;
    //self.tableView.scrollEnabled = YES;
    
    NSError *error = nil;
	
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    
    userArray = [[NSArray alloc] initWithArray:array];
    
    for (User *s in userArray) {
        NSLog(@"Name: %@",s.firstName);
    }
    
    //[self.tableView reloadData];
}
 
 */

#pragma mark - Table view data source


/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"sections in table view");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"rows in table view");
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Formating Cells");
    
    static NSString *FirstLevelCell= @"FirstLevelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
    }
    
    // Configure the cell
    
    NSLog(@"HELLOOOOO");
    
    [cell.textLabel setText:[userArray objectAtIndex:[indexPath row]]];
    
    return cell;
}
*/

@end
