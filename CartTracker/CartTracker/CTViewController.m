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

@interface CTViewController ()

@end

@implementation CTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CTAdminNavigationViewController * adminController = [[CTAdminNavigationViewController alloc] init];
    
    CTRequestNavigationViewController *requestController = [[CTRequestNavigationViewController alloc] init];
    
    CTCalendarNavigationViewController * calendarController = [[CTCalendarNavigationViewController alloc] init];
    
    CTProcessNavigationViewController * processController = [[CTProcessNavigationViewController alloc]init];
    
    UIColor* color3 = [UIColor colorWithRed: 0.769 green: 0.584 blue: 0.145 alpha: 1];
    
    [[UITabBar appearance] setBarTintColor:color3];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];

    self.viewControllers = @[processController,calendarController,requestController, adminController];
    //UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    
    [self initTabBar];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

@end
