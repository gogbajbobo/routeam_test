//
//  ParticipantsTVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "ParticipantsTVC.h"

#import <CoreData/CoreData.h>
#import "DataController.h"
#import "DataModel.h"


@interface ParticipantsTVC ()

@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;


@end


@implementation ParticipantsTVC

- (NSManagedObjectContext *)context {
    return [DataController document].managedObjectContext;
}

- (NSFetchedResultsController *)resultsController {
    
    if (!_resultsController && self.context) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Participant class])];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"participantId"
                                                                  ascending:YES
                                                                   selector:@selector(compare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"event.eventId == %@", self.eventId];
        
        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                 managedObjectContext:self.context
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
        
    }
    
    return _resultsController;
    
}

- (void)fetchParticipants {
    
    if (!self.context) return;
    
    self.resultsController = nil;
    
    NSError *error;
    
    if (![self.resultsController performFetch:&error]) {
        NSLog(@"%@ performFetch error %@", NSStringFromClass([self class]), error);
    } else {
        [self.tableView reloadData];
    }
    
}

- (NSNumberFormatter *)numberFormatter {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    return numberFormatter;
    
}


#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Participants";
    [self fetchParticipants];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = self.resultsController.sections[section];
    return [sectionInfo numberOfObjects];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"participantCell"
                                                            forIndexPath:indexPath];

    Participant *participant = [self.resultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ — plan: %@", participant.name, [[self numberFormatter] stringFromNumber:participant.plan]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Completion: %@", [[self numberFormatter] stringFromNumber:participant.completion]];
    
    return cell;

}



@end
