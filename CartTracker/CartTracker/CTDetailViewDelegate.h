//
//  CTDetailView.h
//  CartTracker
//
//  Created by Andres Ruggiero on 12/1/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTDetailViewDelegate <NSObject>

@optional
-(void) loadDataToView;
-(void) setEditing:(BOOL)editing animated:(BOOL)animated;
-(void) setBorderStyleToUITextFields:(UITextBorderStyle) borderStyle;
-(void) fieldsAreEnabled:(BOOL)booleanValue;
-(void) enableFields:(BOOL)enableValue andSetBorderStyle:(UITextBorderStyle)borderStyle;
-(BOOL) fieldsAreEmpty;
-(IBAction)cancelButtonPressed:(id)sender;
-(IBAction)saveButton:(id)sender;

@end
