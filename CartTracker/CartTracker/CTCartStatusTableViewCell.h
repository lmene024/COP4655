//
//  CTCartStatusTableViewCell.h
//  CartTracker
//
//  Created by leo on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCartStatusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cartName;
@property (weak, nonatomic) IBOutlet UILabel *cartID;
@property (weak, nonatomic) IBOutlet UIView *cartStatus;
@end
