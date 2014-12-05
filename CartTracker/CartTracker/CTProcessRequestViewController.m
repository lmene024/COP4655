//
//  CTProcessRequestViewController.m
//  CartTracker
//
//  Created by leo on 12/4/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTProcessRequestViewController.h"

@interface CTProcessRequestViewController ()

@end

@implementation CTProcessRequestViewController


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
    
    //initially hide all views
    self.loanView.hidden = true;
    self.returnView.hidden = true;
    self.actionButton.hidden = true;
    self.actionButton.enabled = false;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleView:(UISegmentedControl *)sender {
    self.actionButton.hidden = false;

    if(sender.selectedSegmentIndex == 0){
        //show loan view
        self.loanView.hidden = false;
        [self.actionButton setTitle:@"Loan Cart" forState:self.actionButton.state];
        
        //hide return view
        self.returnView.hidden = true;
    }else{
        //show return view
        self.returnView.hidden = false;
        [self.actionButton setTitle:@"Return Cart" forState:self.actionButton.state];
        
        //hide loan view
        self.loanView.hidden = true;
    }
}

- (IBAction)actionButtonPressed:(id)sender {
}

- (IBAction)scanButtonPressed:(id)sender {
}
@end
