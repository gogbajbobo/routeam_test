//
//  EventDetailsVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "EventDetailsVC.h"

#import "ParticipantsTVC.h"


@interface EventDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *completion;
@property (weak, nonatomic) IBOutlet UILabel *info;



@end

@implementation EventDetailsVC

- (IBAction)participantsButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"showParticipants"
                              sender:sender];
    
}

- (void)showEventData {
    
    self.name.text = self.event.name;
    self.startTime.text = [[self dateFormatter] stringFromDate:self.event.startDate];
    self.finishTime.text = [[self dateFormatter] stringFromDate:self.event.finishDate];
    self.type.text = @"have to fill type";
    self.completion.text = [[self numberFormatter] stringFromNumber:self.event.completion];
    self.info.text = self.event.info;
    
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


#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self showEventData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showParticipants"] &&
        [segue.destinationViewController isKindOfClass:[ParticipantsTVC class]]) {
        
    }
    
}

@end
