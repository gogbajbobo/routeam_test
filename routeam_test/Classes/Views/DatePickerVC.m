//
//  DatePickerVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 03/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "DatePickerVC.h"

@interface DatePickerVC ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;



@end

@implementation DatePickerVC

- (IBAction)datePickerValueChanged:(id)sender {
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}


#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
