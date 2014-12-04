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
#import "Cart.h"

@interface CTRequestNewViewController ()

@end

@implementation CTRequestNewViewController
{
    NSArray *userArray;
    NSMutableArray *filteredContentList;
    NSArray *cartArray;
    NSMutableArray *filteredCartArray;
    Boolean isSecondSearchBar;
}

#pragma mark - Properties

@synthesize searchBar;
@synthesize tableView;
@synthesize searchBarController;
@synthesize isSearching;
@synthesize manager;
@synthesize cartSearchBar;
@synthesize requestDateLabel;
@synthesize requestDatePicker;
@synthesize notesLabel;
@synthesize notesTextView;

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
    
    [self initArrays];
    
    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    [self.cartSearchBar setBarTintColor:[UIColor whiteColor]];
    
    [self setViewHidden:YES];
    
    [self setTitle:@"New Request"];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(saveButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Do any additional setup after loading the view from its nib.
}

-(void) initArrays{
    filteredContentList = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    userArray = [[NSArray alloc] initWithArray:array];
    
    filteredCartArray = [[NSMutableArray alloc] init];
    NSError *error2 = nil;
    NSArray *arrayCart = [manager.context executeFetchRequest:[manager getAllCarts] error:&error2];
    cartArray = [[NSArray alloc] initWithArray:arrayCart];
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

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setText:[searchBar text]];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.cartSearchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    
    isSearching = YES;
    
    [self setViewHidden:YES];
    
    if (searchBar == self.cartSearchBar) {
        isSecondSearchBar = YES;
        NSLog(@"%hhu",isSecondSearchBar);
    } else {
        isSecondSearchBar = NO;
    }
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.cartSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    [filteredCartArray removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self.tableView setHidden:NO];
        [self setViewHidden:YES];
        [self searchTableList];
    }
    else {
        [self.tableView setHidden:YES];
        isSearching = NO;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.text=@"";
    self.cartSearchBar.text=@"";
    
    [self.tableView setHidden:YES];
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.cartSearchBar setShowsCancelButton:NO animated:YES];
    [self.cartSearchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.cartSearchBar setShowsCancelButton:NO animated:YES];
    [self.cartSearchBar resignFirstResponder];
    
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;

    [self searchTableList];
}

-(void) searchTableList{
    //NSLog(@"Searching Table List...");
    
    [self.tableView setHidden:NO];
    
    if (!isSecondSearchBar) {
        for (User *aUser in userArray) {
            NSString *searchString = self.searchBar.text;
            NSLog(@"SearchBarText: %@",self.searchBar.text);
            NSComparisonResult result = [aUser.firstName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            if (result == NSOrderedSame) {
                NSLog(@"Testing result");
                [filteredContentList addObject:aUser];
            }
        }
    } else {
        NSString *searchString = self.cartSearchBar.text;
        NSLog(@"SearchBarText: %@",searchString);
        
        for (Cart *aCart in cartArray) {
            NSComparisonResult cartResult = [aCart.cartName
                                             compare:searchString
                                             options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                             range:NSMakeRange(0, [searchString length])];
            if (cartResult == NSOrderedSame) {
                NSLog(@"Testing result");
                [filteredCartArray addObject:aCart];
            }
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
    
    if (!isSecondSearchBar) {
        if (isSearching) {
            return [filteredContentList count];
        }
        else {
            return [userArray count];
        }
    } else{
        if (isSearching) {
            return [filteredCartArray count];
        } else {
            return [cartArray count];
        }
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
    
    if (!isSecondSearchBar) {
        User *aUser = [userArray objectAtIndex:[indexPath row]];
        
        // Configure the cell...
        if (isSearching == YES) {
            User *a = [filteredContentList objectAtIndex:indexPath.row];
            cell.textLabel.text = a.firstName;
        }
        else {
            [cell.textLabel setText:aUser.firstName];
        }
    } else {
        
        Cart *aCart = [cartArray objectAtIndex:[indexPath row]];
        
        if (isSearching) {
            Cart *c = [filteredCartArray objectAtIndex:[indexPath row]];
            cell.textLabel.text = c.cartName;
        } else {
            [cell.textLabel setText:aCart.cartName];
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //[self.searchBar setText:[userArray objectAtIndex:[indexPath row]]];
    //[self.cartSearchBar setText:[cartArray objectAtIndex:[indexPath row]]];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (!isSecondSearchBar){
        [self.searchBar setText:cell.textLabel.text];
    } else {
        [self.cartSearchBar setText:cell.textLabel.text];
    }
    
    [self.searchBar resignFirstResponder];
    [self.cartSearchBar resignFirstResponder];
    
    [self.searchBar setShowsCancelButton:NO animated:NO];
    [self.cartSearchBar setShowsCancelButton:NO animated:NO];
    
    [self setClearButtonMode:self.searchBar];
    [self setClearButtonMode:self.cartSearchBar];

    [self.tableView setHidden:YES];
    [self setViewHidden:NO];
}

#pragma mark - Update UI

-(void) setViewHidden:(BOOL)value{
    [requestDateLabel setHidden:value];
    [requestDatePicker setHidden:value];
    [notesLabel setHidden:value];
    [notesTextView setHidden:value];
}

-(void) setClearButtonMode:(UISearchBar *)mySearchBar{
    UITextField *textField = [mySearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
}

#pragma mark - IBAction

-(IBAction)saveButtonPressed:(id)sender{
    NSDate *date = self.requestDatePicker.date;
    
    if ((![self.cartSearchBar.text isEqualToString:@""]) & (![self.searchBar.text isEqualToString:@""])) {
        for (Cart *aCart in cartArray) {
            if ([self.cartSearchBar.text isEqualToString:aCart.cartName]) {
#warning Validate is a cart is at use or not
            }
        }
    }
}

@end
