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

-(void) setIconForTabBarItems{
    UITabBarItem *calendarItem = [self.tabBar.items objectAtIndex:3];
    UIImage *selectedImageCalendar = [UIImage imageNamed:@"calendarSelectedIcon.png"];
    UIImage *unselectedImageCalendar = [UIImage imageNamed:@"calendarUnselectedIcon.png"];
    //[item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:nil];
    
    calendarItem = [calendarItem initWithTitle:@"Calendar" image:unselectedImageCalendar selectedImage:selectedImageCalendar];
    [calendarItem setImage: [unselectedImageCalendar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *adminItem = [self.tabBar.items objectAtIndex:1];
    UIImage *selectedImageAdmin = [UIImage imageNamed:@"administrator-25.png"];
    UIImage *unselectedImageAdmin = [UIImage imageNamed:@"administrator-25-2.png"];
    //[item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:nil];
    
    adminItem = [adminItem initWithTitle:@"Admin" image:unselectedImageAdmin selectedImage:selectedImageAdmin];
    [adminItem setImage: [unselectedImageAdmin imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *processItem = [self.tabBar.items objectAtIndex:0];
    UIImage *selectedImageProcess = [UIImage imageNamed:@"process_selected.png"];
    UIImage *unselectedImageProcess = [UIImage imageNamed:@"process_unselected.png"];
    //[item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:nil];
    
    processItem = [processItem initWithTitle:@"Process" image:unselectedImageProcess selectedImage:selectedImageProcess];
    [processItem setImage: [unselectedImageProcess imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *requestItem = [self.tabBar.items objectAtIndex:2];
    UIImage *selectedImageRequest = [UIImage imageNamed:@"list_selected.png"];
    UIImage *unselectedImageRequest = [UIImage imageNamed:@"list_unselected.png"];
    //[item1 setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:nil];
    
    requestItem = [requestItem initWithTitle:@"Request" image:unselectedImageRequest selectedImage:selectedImageRequest];
    [requestItem setImage: [unselectedImageRequest imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
