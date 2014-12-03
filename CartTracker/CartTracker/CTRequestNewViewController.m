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
    NSMutableArray *filteredContentList;
}

#pragma mark - Properties

@synthesize searchBar;
@synthesize tableView;
@synthesize searchBarController;
@synthesize isSearching;
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
    
    filteredContentList = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    userArray = [[NSArray alloc] initWithArray:array];
    
    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    isSearching = YES;
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        [self.tableView setHidden:YES];
        isSearching = NO;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //NSLog(@"Cancel clicked");
    
    self.searchBar.text=@"";
    
    [self.tableView setHidden:YES];
    
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
    for (User *aUser in userArray) {
        NSComparisonResult result = [aUser.firstName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            NSLog(@"Testing result");
            [filteredContentList addObject:aUser];
        }
    }
    
}

#pragma mark - Table view data source

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
    
    if (isSearching) {
        return [filteredContentList count];
    }
    else {
        return [userArray count];
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
    
    User *aUser = [userArray objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    if (isSearching == YES) {
        User *a = [filteredContentList objectAtIndex:indexPath.row];
        cell.textLabel.text = a.firstName;
    }
    else {
        [cell.textLabel setText:aUser.firstName];
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UIView transitionWithView:self.tableView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionNone
                    animations:nil
                    completion:^(BOOL finished) {
                        [self.view.superview addSubview:self.tableView];
                    }];
    
}


@end
