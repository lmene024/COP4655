//
//  CTCartDetailViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTCartDetailViewController.h"
#import "Cart.h"
#import "CTcartManager.h"

#import "Constants.h"

@interface CTCartDetailViewController ()

@end

@implementation CTCartDetailViewController

@synthesize cartIdTextField,cartNameTextField,tagTextField;
@synthesize cart;
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
    // Do any additional setup after loading the view from its nib.
    
    if (self.cart != nil) {
        // The view is loaded for an existing cart
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self loadDataToView];
        [self enableFields:NO andSetBorderStyle:UITextBorderStyleNone];
    } else {
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                       target:self
                                       action:@selector(saveButton:)];
        
        self.navigationItem.rightBarButtonItem = saveButton;
        [self enableFields:YES andSetBorderStyle:UITextBorderStyleRoundedRect];
        
    }
    
}

/*! Description Method that loads the item selected in
    the UITableView and displays it in the view
 
 @param
 @return
 
 */

-(void) loadDataToView{
    
    if (self.cart != nil) {
        NSLog(@"Data Loaded");
        self.cartNameTextField.text = cart.cartName;
        self.cartIdTextField.text = cart.cartID;
        self.tagTextField.text = cart.tagNumber;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*! Description Method that handles editing mode of editBarButton
 
 @param
 @return
 
 */

-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        
        // Enabling UITextFields
        [self enableFields:YES andSetBorderStyle:UITextBorderStyleRoundedRect];
        
        self.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        
    } else {
        
        // Disabling UITextFields
        [self enableFields:NO andSetBorderStyle:UITextBorderStyleNone];
        
        self.navigationItem.hidesBackButton = NO;
        
        self.navigationItem.leftBarButtonItem = nil;
        
        NSLog(@"Done Button Pressed");
    }
}

#pragma mark - User Interface

/*! Description Set border style to the UITextFields
 
 @param UITextBorderStyle
 @return void
 
 */

-(void) setBorderStyleToUITextFields:(UITextBorderStyle) borderStyle{
    
    [self.cartIdTextField setBorderStyle:borderStyle];
    [self.cartNameTextField setBorderStyle:borderStyle];
    [self.tagTextField setBorderStyle:borderStyle];
}

/*! Description Method that enables the fields in the UI
 
 @param BOOL
 @return void
 
 */

-(void) fieldsAreEnabled:(BOOL)booleanValue{
    
    [self.cartIdTextField setEnabled:booleanValue];
    [self.cartNameTextField setEnabled:booleanValue];
    [self.tagTextField setEnabled:booleanValue];
}

/*! Description Method that enables/disables and sets the border style
 
 @param BOOl and UITextBorderStyle
 @return void
 
 */

-(void) enableFields:(BOOL)enableValue andSetBorderStyle:(UITextBorderStyle)borderStyle{
    [self fieldsAreEnabled:enableValue];
    [self setBorderStyleToUITextFields:borderStyle];
}

-(BOOL) fieldsAreEmpty{
    
    if ( FIELD_ISEMPTY(self.cartIdTextField.text)
        || FIELD_ISEMPTY(self.cartNameTextField.text)
        || FIELD_ISEMPTY(self.tagTextField.text)) {
        return YES;
    }
    
    return NO;
}

#pragma mark - IBAction

/*! Description Cancel Button selector
 
 @param
 @return
 
 */

-(IBAction)cancelButtonPressed:(id)sender{
    NSLog(@"Cancel Button Pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

/*! Description Save button selector
 
 @param
 @return
 
 */

-(IBAction)saveButton:(id)sender{
    
    Cart *aCart = [self.manager newCart];
    
    if (![self fieldsAreEmpty]) {
        
        [aCart setCartID:self.cartIdTextField.text];
        [aCart setCartName:self.cartNameTextField.text];
        [aCart setTagNumber:self.tagTextField.text];
        
        [manager save];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Some Fields are Empty"
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


- (IBAction)scanQrCode:(id)sender {
    ZBarReaderViewController * scannerController = [ZBarReaderViewController new];
    scannerController.readerDelegate = self;
    scannerController.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner * scanner = scannerController.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentViewController:scannerController animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol = nil;
    for (symbol in results) {
        //already set first barcode to symbol
        break;
    }
    NSString * qrText = symbol.data;
    
    self.barCodeImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:true completion:nil];
}


/*- (IBAction)scanQrCode:(id)sender {
    CTScannerQRViewController * scannerController = [[CTScannerQRViewController alloc] init];
//    scannerController.capture.delegate = self;
    
    [self presentViewController:scannerController animated:true completion:nil];
 }

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
    NSString * qrText = result.text;
    
    NSLog(@"Scanned: %@", qrText);
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
*/
@end
