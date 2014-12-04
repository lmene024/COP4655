//
//  CTADetailViewController.m
//  CartTracker
//
//  Created by leo on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTADetailViewController.h"

@interface CTADetailViewController ()

@end

@implementation CTADetailViewController

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
    // Do any additional setup after loading the view.
    ((UIScrollView *)self.view).contentSize = [self.view.subviews[0] bounds].size;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotification];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotification];
}


-(void) registerForKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) deregisterForKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notification{
    NSDictionary * info = [notification userInfo];
    CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = self.activeField.frame.origin;
    CGFloat buttonHeight = self.activeField.frame.size.height;
    CGRect visibleRect = self.view.frame;
    CGFloat navbarHeight = self.navigationController.navigationBar.frame.size.height;
    
    visibleRect.size.height = visibleRect.size.height - keyboardSize.height - navbarHeight ;
    if (!CGRectContainsPoint(visibleRect, CGPointMake(buttonOrigin.x, buttonOrigin.y+buttonHeight))) {

        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [(UIScrollView *)self.view setContentOffset:scrollPoint animated:true];
    }
    
}

- (void) keyboardWillBeHidden:(NSNotification *) notification {
    id navBar = self.navigationController.navigationBar;
    CGPoint startPoint = CGPointZero;
    startPoint.y -= [navBar frame].origin.y + [navBar frame].size.height;
    
    [(UIScrollView *)self.view setContentOffset:startPoint animated:true];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return true;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    self.activeField = textField;
    return  true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
