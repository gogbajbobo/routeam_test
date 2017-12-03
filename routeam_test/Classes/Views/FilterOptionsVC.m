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
#import "FilterHelper.h"


@interface FilterOptionsVC () <UITextFieldDelegate>

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

- (NSNumberFormatter *)numberFormatter {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    return numberFormatter;
    
}


#pragma mark - actions

- (IBAction)typeSwitchChanged:(id)sender {

    if ([sender isEqual:self.typeSwitch]) {
        [self updateTypeFilterSetting];
    }
    
}

- (IBAction)nameSwitchChanged:(id)sender {
    
    if ([sender isEqual:self.nameSwitch]) {
        [self updateNameFilterSetting];
    }
    
}

- (IBAction)startDateSwitchChanged:(id)sender {

    if ([sender isEqual:self.startDateSwitch]) {
        [self updateStartDateFilterSetting];
    }

}

- (IBAction)finishDateSwitchChanged:(id)sender {

    if ([sender isEqual:self.finishDateSwitch]) {
        [self updateFinishDateFilterSetting];
    }

}

- (IBAction)completionMinSwitchChanged:(id)sender {
    
    if ([sender isEqual:self.completionMinSwitch]) {
        [self updateCompletionMinFilterSetting];
    }

}

- (IBAction)completionMaxSwitchChanged:(id)sender {

    if ([sender isEqual:self.completionMaxSwitch]) {
        [self updateCompletionMaxFilterSetting];
    }

}

- (IBAction)typeValueChanged:(id)sender {
    
    if ([sender isEqual:self.typeSegmentedControl]) {
        [self updateTypeFilterSetting];
    }
}

- (IBAction)nameValueChanged:(id)sender {
    
    if ([sender isEqual:self.nameTextField]) {
        [self updateNameFilterSetting];
    }
    
}

- (IBAction)startDateFilterPressed:(id)sender {
    // show date picker
}

- (IBAction)finishDateFilterPressed:(id)sender {
    // show date picker
}

- (IBAction)completionMinChanged:(id)sender {
    
    if ([sender isEqual:self.completionMinSlider]) {
        [self updateCompletionMinFilterSetting];
    }

}

- (IBAction)completionMaxChanged:(id)sender {
    
    if ([sender isEqual:self.completionMaxSlider]) {
        [self updateCompletionMaxFilterSetting];
    }

}


#pragma mark - update settings

- (void)updateTypeFilterSetting {
    
    NSDictionary *settingValue = @{FILTER_STATE: @(self.typeSwitch.on),
                                   FILTER_VALUE: @(self.typeSegmentedControl.selectedSegmentIndex)
                                   };
    
    [self updateSetting:FILTER_TYPE
              withValue:settingValue];
    
    [self updateTypeFilter];

}

- (void)updateNameFilterSetting {

    NSDictionary *settingValue = @{FILTER_STATE: @(self.nameSwitch.on),
                                   FILTER_VALUE: self.nameTextField.text
                                   };
    
    [self updateSetting:FILTER_NAME
              withValue:settingValue];
    
    [self updateNameFilter];

}

- (void)updateStartDateFilterSetting {
    
    NSDictionary *settingValue = @{FILTER_STATE: @(self.startDateSwitch.on)};
    
    [self updateSetting:FILTER_STARTDATE
              withValue:settingValue];
    
    [self updateStartDateFilter];

}

- (void)updateFinishDateFilterSetting {

    NSDictionary *settingValue = @{FILTER_STATE: @(self.finishDateSwitch.on)};
    
    [self updateSetting:FILTER_FINISHDATE
              withValue:settingValue];
    
    [self updateFinishDateFilter];

}

- (void)updateCompletionMinFilterSetting {
    
    NSDictionary *settingValue = @{FILTER_STATE: @(self.completionMinSwitch.on),
                                   FILTER_VALUE: @(self.completionMinSlider.value)
                                   };
    
    [self updateSetting:FILTER_COMPLETION_MIN
              withValue:settingValue];
    
    [self updateCompletionMinFilter];

}

- (void)updateCompletionMaxFilterSetting {
    
    NSDictionary *settingValue = @{FILTER_STATE: @(self.completionMaxSwitch.on),
                                   FILTER_VALUE: @(self.completionMaxSlider.value)
                                   };
    
    [self updateSetting:FILTER_COMPLETION_MAX
              withValue:settingValue];
    
    [self updateCompletionMaxFilter];

}

- (void)updateSetting:(NSString *)setting withValue:(NSDictionary *)settingValue {
    
    if (![setting isEqualToString:FILTER_NAME]) {
        [self dismissKeyboard];
    }
    
    NSDictionary *newSetting = @{@"option": FILTER_OPTIONS,
                                 @"setting": setting,
                                 @"value": settingValue
                                 };
    [SettingsController setNewSettingValue:newSetting];
    
    [self updateFilteredEventsCount];

}


#pragma mark - initialize elements

- (void)initializeElements {
    
    self.nameTextField.delegate = self;
    
    [self updateTypeFilter];
    [self updateNameFilter];
    [self updateStartDateFilter];
    [self updateFinishDateFilter];
    [self updateCompletionMinFilter];
    [self updateCompletionMaxFilter];
    [self updateFilteredEventsCount];
    
}


#pragma mark - update elements

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
    float sliderValue = value ? value.floatValue : 0.0;
    self.completionMinSlider.value = sliderValue;
    self.completionMinLabel.text = [NSString stringWithFormat:@"%@ %@", FILTER_COMPLETION_MIN, [[self numberFormatter] stringFromNumber:@(sliderValue)]];
    
    if (sliderValue > self.completionMaxSlider.value) {
#warning - change completionMaxSlider.value
    }

}

- (void)updateCompletionMaxFilter {
    
    BOOL state = [[self filterOptions][FILTER_COMPLETION_MAX][FILTER_STATE] boolValue];
    self.completionMaxSwitch.on = state;
    self.completionMaxLabel.enabled = state;
    self.completionMaxSlider.enabled = state;
    
    NSNumber *value = [self filterOptions][FILTER_COMPLETION_MAX][FILTER_VALUE];
    float sliderValue = value ? value.floatValue : 1.0;
    self.completionMaxSlider.value = sliderValue;
    self.completionMaxLabel.text = [NSString stringWithFormat:@"%@ %@", FILTER_COMPLETION_MAX, [[self numberFormatter] stringFromNumber:@(sliderValue)]];

    if (sliderValue < self.completionMinSlider.value) {
#warning - change completionMinSlider.value
    }

}

- (void)updateFilteredEventsCount {
    
    NSUInteger eventsCount = [[self events] filteredArrayUsingPredicate:[FilterHelper eventsPredicate]].count;
    
    self.filteredEventsCountLabel.text = [NSString stringWithFormat:@"Filtered events count: %@", @(eventsCount)];
    
}


#pragma mark - keyboard

- (void)addTapGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)dismissKeyboard {
    [self.nameTextField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.nameTextField]) {
        [self dismissKeyboard];
    }
    
    return YES;
}


#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self addTapGesture];
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
