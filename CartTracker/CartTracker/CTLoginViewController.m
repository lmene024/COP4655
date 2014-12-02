//
//  CTLoginViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTLoginViewController.h"
#import "CTViewController.h"

@interface CTLoginViewController ()

@end

@implementation CTLoginViewController

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
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) validateLogin{
    BOOL login = NO;
    
    return login;
}

- (IBAction)buttonPressed:(id)sender {
    
    NSLog(@"Button Pressed");
    
    CTViewController *controller = [[CTViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
