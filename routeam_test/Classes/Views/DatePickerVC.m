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
    
    if ([sender isEqual:self.datePicker]) {
        self.owner.pickerDate = self.datePicker.date;
    }
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}

- (void)setupDatePicker {
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    if (self.minDate) self.datePicker.minimumDate = self.minDate;
    if (self.maxDate) self.datePicker.maximumDate = self.maxDate;
    if (self.date) self.datePicker.date = self.date;
    
}


#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupDatePicker];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
