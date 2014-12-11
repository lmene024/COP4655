//
//  CTCartDetailViewController.m
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//
// Class Description: This class handles the detail view of a cart.
// It contains the ability to edit & save changes to an existing cart.
// This view controller is also used to create a new Cart in the application.

#import "CTCartDetailViewController.h"
#import "Cart.h"
#import "CTcartManager.h"

#import "Constants.h"

@interface CTCartDetailViewController ()

@property (strong, nonatomic) NSString * cartQrData;

@end

@implementation CTCartDetailViewController
{
    bool didAddQR;
    NSArray *cartArray;
}

#pragma mark - Properties

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
    [self initArray];
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
        [saveButton setTintColor:[UIColor blackColor]];
        
        self.navigationItem.rightBarButtonItem = saveButton;
        [self enableFields:YES andSetBorderStyle:UITextBorderStyleRoundedRect];
        [self setIdValueForTextField];
        [self setCartNameWithMaxValue:[self getMaxCartId]+1];
    }
    
    didAddQR = false;
}

/*! Initialize the array with existing carts
 
 @param
 @return
 
 */

-(void)initArray{
    NSError *error = nil;
    NSArray *array = [manager.context executeFetchRequest:[manager getAllCarts] error:&error];
    cartArray = [[NSArray alloc] initWithArray:array];
}

/*! Method that returns the maximum cart ID number
 
 @param
 @return
 
 */

-(int) getMaxCartId{
    int maxCartId = 0;
    for (Cart *aCart in cartArray) {
        if ([aCart.cartID intValue] > maxCartId) {
            maxCartId = [aCart.cartID intValue];
        }
    }
    
    return maxCartId;
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
        
        if (cart.qrCode !=nil) {
            self.cartQrData = cart.qrCode;
            self.barCodeImage.image = [self createNonInterpolatedUIImageFromCIImage:[self generateQRForString:cart.qrCode]];
        }
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
        if([self saveDataForCart:cart]){
            // Disabling UITextFields
            [self enableFields:NO andSetBorderStyle:UITextBorderStyleNone];
            
            self.navigationItem.hidesBackButton = NO;
            
            self.navigationItem.leftBarButtonItem = nil;
            
            NSLog(@"Done Button Pressed");
        }
    }
}

#pragma mark - User Interface

/*! Description Set border style to the UITextFields
 
 @param UITextBorderStyle
 @return void
 
 */

-(void) setBorderStyleToUITextFields:(UITextBorderStyle) borderStyle{
    
    if (borderStyle == UITextBorderStyleNone) {
        [self.cartIdTextField setBorderStyle:borderStyle];
        [self.cartNameTextField setBorderStyle:borderStyle];
    }
    [self.tagTextField setBorderStyle:borderStyle];
}

/*! Description Method that enables the fields in the UI
 
 @param BOOL
 @return void
 
 */

-(void) fieldsAreEnabled:(BOOL)booleanValue{
    
    
    if (!booleanValue) {
        [self.cartIdTextField setEnabled:booleanValue];
        [self.cartNameTextField setEnabled:booleanValue];
    }
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

/*! Method that validates is fields are empty
 
 @param
 @return
 
 */

-(BOOL) fieldsAreEmpty{
    
    if ( FIELD_ISEMPTY(self.cartIdTextField.text)
        || FIELD_ISEMPTY(self.cartNameTextField.text)
        || FIELD_ISEMPTY(self.tagTextField.text)) {
        return YES;
    }
    
    return NO;
}

/*! Method that sets the Cart Id value
 
 @param
 @return
 
 */

-(void) setIdValueForTextField{
    int maxCartId = [self getMaxCartId];
    NSString *max = [[NSString alloc] initWithFormat:@"%d",maxCartId+1];
    [self.cartIdTextField setText:max];
    [self.cartIdTextField setEnabled:NO];
}

/*! Method that sets by default the Cart name 
    to Cart#(CartId)
 
 @param
 @return
 
 */

-(void) setCartNameWithMaxValue:(int)maxValue{
    NSString *cartName = [[NSString alloc] initWithFormat:@"Cart #%d",maxValue];
    [self.cartNameTextField setText:cartName];
    [self.cartNameTextField setEnabled:NO];
}

#pragma mark UIAlertView

-(void) showEmptyFieldAlertView{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:@"Some Fields are Empty"
                          delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil, nil];
    [alert show];
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

- (bool) saveDataForCart:(Cart *) aCart{
    if (![self fieldsAreEmpty]) {
        
        [aCart setCartID:self.cartIdTextField.text];
        [aCart setCartName:self.cartNameTextField.text];
        [aCart setTagNumber:self.tagTextField.text];
        
        if (didAddQR) {
            [aCart setQrCode:self.cartQrData];
            didAddQR = false;
        }
        
        [manager save];
        
        return true;
        
    } else {
        
        [self showEmptyFieldAlertView];
    }
    return false;
}

/*! Button that saves the cart
 
 @param
 @return
 
 */

-(IBAction)saveButton:(id)sender{
    
    if (![self fieldsAreEmpty]) {
        Cart *aCart = [self.manager newCart];
        [self saveDataForCart:aCart];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showEmptyFieldAlertView];
    }
    
}

/*! Scan QR code button
 
 @param
 @return
 
 */

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
    self.cartQrData = symbol.data;
    NSLog(@"QR Data: %@", symbol.data);
    if (!self.isEditing && cart!=nil) {
        [cart setQrCode:symbol.data];
        [manager save];
    }else{
        didAddQR = true;
    }
    
    UIImage * qrImage = [self createNonInterpolatedUIImageFromCIImage:[self generateQRForString:symbol.data]];
    
    self.barCodeImage.image = qrImage;
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (CIImage *)generateQRForString:(NSString * )qrString{
    NSData * stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter * qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    CGFloat scale = [[UIScreen mainScreen] scale]*10;
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                                scale:scaledImage.scale
                                          orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;
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

@end
