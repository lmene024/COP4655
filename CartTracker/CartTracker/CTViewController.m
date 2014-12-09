//
//  CTViewController.m
//  CartTracker
//
//  Created by leo on 11/13/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

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

    self.viewControllers = @[processController, adminController,requestController, calendarController];
    //UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    // set color of unselected text to green
    [[UITabBarItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]
     
     forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]
     
     forState:UIControlStateSelected];
    
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:3];
    UIImage *selectedImage = [UIImage imageNamed:@"calendarSelectedIcon.png"];
    UIImage *unselectedImage = [UIImage imageNamed:@"calendarUnselectedIcon.png"];
    //[item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:nil];
    
    //NSArray *tabBarItems = [[NSArray alloc] initWithArray:self.tabBar.items];
    //UITabBarItem *item = [tabBarItems objectAtIndex:3];
    
    //item1 = [item1 initWithTitle:@"Calendar" image:selectedImage selectedImage:selectedImage];
    [self.tabBar setTintColor:[UIColor blackColor]];
    
    [item1 setImage: [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage: selectedImage];
    
    //[item1 initWithTitle:@"Calendar" image:selectedImage selectedImage:selectedImage];
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
