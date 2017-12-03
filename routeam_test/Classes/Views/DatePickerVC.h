//
//  DatePickerVC.h
//  routeam_test
//
//  Created by Maxim Grigoriev on 03/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatePickerOwner.h"


@interface DatePickerVC : UIViewController

@property (nonatomic, weak) id <DatePickerOwner> owner;

@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *date;

@end
