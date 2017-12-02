//
//  FilterOptionsVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "FilterOptionsVC.h"

@interface FilterOptionsVC ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *filteredEventsCountLabel;

@property (weak, nonatomic) IBOutlet UISwitch *typeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *nameSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *startDateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *finishDateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *completionMinSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *completionMaxSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *startDateValueButton;
@property (weak, nonatomic) IBOutlet UIButton *finishDateValueButton;
@property (weak, nonatomic) IBOutlet UISlider *completionMinSlider;
@property (weak, nonatomic) IBOutlet UISlider *completionMaxSlider;


@end

@implementation FilterOptionsVC


#pragma mark - actions

- (IBAction)typeSwitchChanged:(id)sender {
}

- (IBAction)nameSwitchChanged:(id)sender {
}

- (IBAction)startDateSwitchChanged:(id)sender {
}

- (IBAction)finishDateSwitchChanged:(id)sender {
}

- (IBAction)completionMinSwitchChanged:(id)sender {
}

- (IBAction)completionMaxSwitchChanged:(id)sender {
}

- (IBAction)typeValueChanged:(id)sender {
}

- (IBAction)nameValueChanged:(id)sender {
}

- (IBAction)startDateFilterPressed:(id)sender {
}

- (IBAction)finishDateFilterPressed:(id)sender {
}

- (IBAction)completionMinChanged:(id)sender {
}

- (IBAction)completionMaxChanged:(id)sender {
}


#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Filter options";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
