//
//  FilterOptionsVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "FilterOptionsVC.h"

#import <CoreData/CoreData.h>
#import "DataModel.h"
#import "DataController.h"
#import "SettingsController.h"


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


- (NSDictionary *)filterOptions {
    
    NSDictionary *filterOptions = [SettingsController currentSettings][FILTER_OPTIONS];
    NSLog(@"filterOptions %@", filterOptions);

    return filterOptions;
    
}

- (NSArray *)events {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Event class])];
    NSArray *events = [[DataController document].managedObjectContext executeFetchRequest:request
                                                                                    error:nil];
    return events;
    
}

- (NSDateFormatter *)dateFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return dateFormatter;
    
}


#pragma mark - actions

- (IBAction)typeSwitchChanged:(id)sender {
    NSLog(@"typeSwitchChanged");
}

- (IBAction)nameSwitchChanged:(id)sender {
    NSLog(@"nameSwitchChanged");
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


#pragma mark - initialize elements

- (void)initializeElements {
    
    [self updateTypeFilter];
    [self updateNameFilter];
    [self updateStartDateFilter];
    [self updateFinishDateFilter];
    [self updateCompletionMinFilter];
    [self updateCompletionMaxFilter];
    
}

- (void)updateTypeFilter {
    
    BOOL state = [[self filterOptions][FILTER_TYPE][FILTER_STATE] boolValue];
    self.typeSwitch.on = state;
    self.typeLabel.enabled = state;
    self.typeSegmentedControl.enabled = state;
    
    NSNumber *value = [self filterOptions][FILTER_TYPE][FILTER_VALUE];
    self.typeSegmentedControl.selectedSegmentIndex = value ? value.integerValue : -1;
    
}

- (void)updateNameFilter {
    
    BOOL state = [[self filterOptions][FILTER_NAME][FILTER_STATE] boolValue];
    self.nameSwitch.on = state;
    self.nameLabel.enabled = state;
    self.nameTextField.enabled = state;
    
    NSString *value = [self filterOptions][FILTER_NAME][FILTER_VALUE];
    self.nameTextField.text = value;

}

- (void)updateStartDateFilter {
    
    BOOL state = [[self filterOptions][FILTER_STARTDATE][FILTER_STATE] boolValue];
    self.startDateSwitch.on = state;
    self.startDateLabel.enabled = state;
    self.startDateValueButton.enabled = state;
    
    NSDate *value = [self filterOptions][FILTER_STARTDATE][FILTER_VALUE];
    if (!value) value = [[self events] valueForKeyPath:@"@min.startDate"];
    
    [self.startDateValueButton setTitle:[[self dateFormatter] stringFromDate:value]
                               forState:UIControlStateNormal];
    
}

- (void)updateFinishDateFilter {
    
    BOOL state = [[self filterOptions][FILTER_FINISHDATE][FILTER_STATE] boolValue];
    self.finishDateSwitch.on = state;
    self.finishDateLabel.enabled = state;
    self.finishDateValueButton.enabled = state;

    NSDate *value = [self filterOptions][FILTER_FINISHDATE][FILTER_VALUE];
    if (!value) value = [[self events] valueForKeyPath:@"@max.finishDate"];
    
    [self.finishDateValueButton setTitle:[[self dateFormatter] stringFromDate:value]
                                forState:UIControlStateNormal];

}

- (void)updateCompletionMinFilter {

    BOOL state = [[self filterOptions][FILTER_COMPLETION_MIN][FILTER_STATE] boolValue];
    self.completionMinSwitch.on = state;
    self.completionMinLabel.enabled = state;
    self.completionMinSlider.enabled = state;
    
    NSNumber *value = [self filterOptions][FILTER_COMPLETION_MIN][FILTER_VALUE];
    self.completionMinSlider.value = value ? value.floatValue : 0.0;

}

- (void)updateCompletionMaxFilter {
    
    BOOL state = [[self filterOptions][FILTER_COMPLETION_MAX][FILTER_STATE] boolValue];
    self.completionMaxSwitch.on = state;
    self.completionMaxLabel.enabled = state;
    self.completionMaxSlider.enabled = state;
    
    NSNumber *value = [self filterOptions][FILTER_COMPLETION_MAX][FILTER_VALUE];
    self.completionMaxSlider.value = value ? value.floatValue : 1.0;

}


#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self initializeElements];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Filter options";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
