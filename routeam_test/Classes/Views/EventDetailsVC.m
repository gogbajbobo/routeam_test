//
//  EventDetailsVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "EventDetailsVC.h"

#import "DataController.h"
#import "DataModel.h"
#import "ParticipantsTVC.h"
#import "SpinnerView.h"


@interface EventDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *completion;
@property (weak, nonatomic) IBOutlet UILabel *info;

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) SpinnerView *spinner;


@end

@implementation EventDetailsVC

- (IBAction)participantsButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"showParticipants"
                              sender:sender];
    
}

- (void)showEventData {
    
    self.name.text = self.event.name;
    self.startTime.text = [self.event startDateString];
    self.finishTime.text = [self.event finishDateString];

    EventType type = self.event.type.integerValue;
    switch (type) {
        case EventTypeUnits:
            self.type.text = @"Completion by units";
            break;
        case EventTypeSum:
            self.type.text = @"Completion by sum";
            break;
        case EventTypeNames:
            self.type.text = @"Completion by names";
            break;
        default:
            self.type.text = @"Completion by none";
            break;
    }

    self.completion.text = [self.event completionText];
    self.info.text = self.event.info;
 
    NSString *typeImageName = [self.event typeImageName];
    if (!typeImageName) return;
    
    self.typeImageView.image = [UIImage imageNamed:typeImageName];
    
}

- (void)fetchEventDetailData {

    self.spinner = [SpinnerView spinnerViewWithFrame:self.view.frame];
    [self.view addSubview:self.spinner];

    [DataController getDetailDataForEventId:self.eventId withCompletionHandler:^(BOOL success, NSDictionary *data) {
        
        if (success) {
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Event class])];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId == %@", self.eventId];
            request.predicate = predicate;
            
            NSError *error = nil;
            
            self.event = [[DataController document].managedObjectContext executeFetchRequest:request
                                                                                       error:&error].lastObject;
            
            if (self.event) [self showEventData];
            
        }
        
        [self.spinner removeFromSuperview];
        
    }];

}


#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"Event details";
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self fetchEventDetailData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showParticipants"] &&
        [segue.destinationViewController isKindOfClass:[ParticipantsTVC class]]) {
        
        ParticipantsTVC *participantsTVC = (ParticipantsTVC *)segue.destinationViewController;
        participantsTVC.eventId = self.eventId;
        
    }
    
}

@end
