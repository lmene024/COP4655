//
//  CTViewController.m
//  CartTracker
//
//  Created by leo on 11/13/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//
// Class Description: CTViewController is a subclass of UITabBarController. It contains
// the four main UINavigationViewControllers of the application

#import "CTViewController.h"
#import "CTAdminNavigationViewController.h"
#import "CTRequestNavigationViewController.h"
#import "CTCalendarViewController.h"
#import "CTProcessRequestViewController.h"
#import "CTProcessNavigationViewController.h"
#import "CTCalendarNavigationViewController.h"
#import "CTUserDetailViewController.h"
#import "CTcartManager.h"
#import "CTLoginViewController.h"
#import "Constants.h"

@interface CTViewController ()
{
    NSArray *userArray;
}
@end

@implementation CTViewController

@synthesize firstTimeLogin;
@synthesize manager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*self.manager = [[CTcartManager alloc] init];
    NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllUsers] error:&error];
    userArray = [[NSArray alloc] initWithArray:array];
    
    if ([userArray count] == 0) {
        NSLog(@"First Time User");
        CTLoginViewController *login = [[CTLoginViewController alloc] init];
        [self.tabBarController presentViewController:login animated:YES completion:nil];
    }*/
    
    CTAdminNavigationViewController * adminController = [[CTAdminNavigationViewController alloc] init];
    
    CTRequestNavigationViewController *requestController = [[CTRequestNavigationViewController alloc] init];
    
    CTCalendarNavigationViewController * calendarController = [[CTCalendarNavigationViewController alloc] init];
    
    CTProcessNavigationViewController * processController = [[CTProcessNavigationViewController alloc]init];
    
    UIColor* color3 = [UIColor colorWithRed: 0.769 green: 0.584 blue: 0.145 alpha: 1];
    
    [[UITabBar appearance] setBarTintColor:color3];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    adminController.firstTimeLogin = self.firstTimeLogin;

    self.viewControllers = @[processController,calendarController,requestController, adminController];
    
    //UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    
    [self initTabBar];
    

}

-(void) viewDidAppear:(BOOL)animated{
    
    if (self.firstTimeLogin == YES) {
        NSLog(@"firstTimeLoginTabBAr");
        //UIViewController *controller = [self.viewControllers objectAtIndex:3];
        //CTAdminNavigationViewController *nav = [self.viewControllers objectAtIndex:3];
        self.tabBarController.selectedIndex = 3;
    }
    
    /*CTAdminNavigationViewController *nav;
    
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:[CTAdminNavigationViewController class]]) {
            nav = (CTAdminNavigationViewController *)controller;
            break;
        }
    }
    CTUserDetailViewController *user = [[CTUserDetailViewController alloc] init];
    CTAdminNavigationViewController *adminNav = [[CTAdminNavigationViewController alloc] init];
    
    [nav pushViewController:user animated:YES];
    self.tabBarController.selectedIndex = 3;
    self.tabBarController.selectedViewController = adminNav;
    */
}

-(void) initTabBar{
    // set color of unselected text to green
    [[UITabBarItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
     
     forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]
     
     forState:UIControlStateSelected];
    [self setIconForTabBarItems];
}

-(void) setIconWithTitle:(NSString *)title
       withSelectedImage:(NSString *)selectedImageName
      andUnselectedImage:(NSString*)unselectedImageName
                 atIndex:(NSInteger)index{
    UITabBarItem *calendarItem = [self.tabBar.items objectAtIndex:index];
    UIImage *selectedImageCalendar = [UIImage imageNamed:selectedImageName];
    UIImage *unselectedImageCalendar = [UIImage imageNamed:unselectedImageName];
    //[item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:nil];
    
    calendarItem = [calendarItem initWithTitle:title image:unselectedImageCalendar selectedImage:selectedImageCalendar];
    [calendarItem setImage: [unselectedImageCalendar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

-(void) setIconForTabBarItems{
    
    //NSNumber *index = [NSNumber numberWithInteger:0];
    NSInteger index = 0;
    
    [self setIconWithTitle:@"Process"
         withSelectedImage:@"process_selected.png"
        andUnselectedImage:@"process_unselected.png"
                   atIndex:index];
    
    index = index + 1;
    
    [self setIconWithTitle:@"Calendar"
         withSelectedImage:@"calendarSelectedIcon.png"
        andUnselectedImage:@"calendarUnselectedIcon.png"
                   atIndex:index];
    
    index = index + 1;
    
    [self setIconWithTitle:@"Request"
         withSelectedImage:@"list_selected.png"
        andUnselectedImage:@"list_unselected.png"
                   atIndex:index];
    
    index = index + 1;
    
    [self setIconWithTitle:@"Admin"
         withSelectedImage:@"administrator-25.png"
        andUnselectedImage:@"administrator-25-2.png"
                   atIndex:index];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

@end
