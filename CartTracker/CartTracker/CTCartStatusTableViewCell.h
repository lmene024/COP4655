//
//  CTCartStatusTableViewCell.h
//  CartTracker
//
//  Created by leo on 12/2/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCartStatusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainText;
@property (weak, nonatomic) IBOutlet UILabel *subText;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UILabel *centerText;
@end
