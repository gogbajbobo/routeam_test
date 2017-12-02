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
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
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
    self.startTime.text = [self.event startDateString];
    self.finishTime.text = [self.event finishDateString];
    self.type.text = @"have to fill type";
    self.completion.text = [self.event completionText];
    self.info.text = self.event.info;
 
    NSString *typeImageName = nil;
    
    switch (self.event.type.integerValue) {
        case 0:
            typeImageName = @"icons8-expensive_filled";
            break;
        case 1:
            typeImageName = @"icons8-sigma_filled";
            break;
        case 2:
            typeImageName = @"icons8-table_of_content_filled";
            break;
            
        default:
            break;
    }
    
    if (!typeImageName) return;
    
    UIImage *typeImage = [UIImage imageNamed:typeImageName];
    
    self.typeImageView.image = typeImage;
    
    CGFloat widthScale = self.typeImageView.frame.size.width / typeImage.size.width;
    CGFloat heightScale = self.typeImageView.frame.size.height / typeImage.size.height;
    
    self.typeImageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);

}


#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self showEventData];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Event details";
    
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
