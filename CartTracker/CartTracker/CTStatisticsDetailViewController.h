//
//  CTStatisticsDetailViewController.h
//  CartTracker
//
//  Created by leo on 12/10/14.
//  Copyright (c) 2014 FIU. All rights reserved.
//

#import "CTADetailViewController.h"

@interface CTStatisticsDetailViewController : CTADetailViewController

@property (strong, nonatomic) IBOutlet UILabel *outputField;
@property (strong, nonatomic) IBOutlet UILabel *reportTitle;

- (instancetype) initWithStatistic:(NSString * ) statisticToDisplay;

@end
