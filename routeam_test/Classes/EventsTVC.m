//
//  EventsTVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "EventsTVC.h"

#import <CoreData/CoreData.h>
#import "DataModel.h"
#import "DataController.h"

#import "EventDetailsVC.h"
#import "SettingsTVC.h"


@interface EventsTVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;


@end

@implementation EventsTVC

- (NSFetchedResultsController *)resultsController {
    
    if (!_resultsController && self.context) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Event class])];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"eventId"
                                                                  ascending:YES
                                                                   selector:@selector(compare:)]];
        
        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                 managedObjectContext:self.context
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
        
        _resultsController.delegate = self;
        
    }
    
    return _resultsController;
    
}


#pragma mark - view lifecycle

- (void)fetchEvents {
    
    self.resultsController = nil;
    
    NSError *error;
    
    if (![self.resultsController performFetch:&error]) {
        NSLog(@"%@ performFetch error %@", NSStringFromClass([self class]), error);
    } else {
        [self.tableView reloadData];
    }
    
}

- (void)documentReady:(NSNotification *)notification {
    
    if ([notification.object isKindOfClass:[UIManagedDocument class]]) {
        
        UIManagedDocument *document = (UIManagedDocument *)notification.object;
        self.context = document.managedObjectContext;
        [self fetchEvents];
        
    }
    
}

- (void)subscribeToNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentReady:)
                                                 name:@"documentReady"
                                               object:nil];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self subscribeToNotifications];
    self.title = @"Events";
    
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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"
                                                            forIndexPath:indexPath];

    Event *event = [self.resultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = event.name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showEventDetails"
                              sender:indexPath];
    
}

#pragma mark - NSFetchedResultsController delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showEventDetails"] &&
        [segue.destinationViewController isKindOfClass:[EventDetailsVC class]] &&
        [sender isKindOfClass:[NSIndexPath class]]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        Event *event = [self.resultsController objectAtIndexPath:indexPath];
        EventDetailsVC *eventDetailsVC = (EventDetailsVC *)segue.destinationViewController;
        eventDetailsVC.event = event;
        
    }

    if ([segue.identifier isEqualToString:@"showSettings"] &&
        [segue.destinationViewController isKindOfClass:[SettingsTVC class]]) {
                
    }

}

@end
