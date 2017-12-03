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


@interface EventDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *completion;
@property (weak, nonatomic) IBOutlet UILabel *info;

@property (nonatomic, strong) Event *event;


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
    self.type.text = @"have to fill type";
    self.completion.text = [self.event completionText];
    self.info.text = self.event.info;
 
    NSString *typeImageName = [self.event typeImageName];
    if (!typeImageName) return;
    
    self.typeImageView.image = [UIImage imageNamed:typeImageName];
    
}

- (void)fetchEventDetailData {

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
        
    }
    
}

@end
