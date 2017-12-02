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
#import "SettingsController.h"

#import "SpinnerView.h"
#import "EventDetailsVC.h"
#import "SettingsTVC.h"


#define CELL_IMAGE_HEIGHT 40.0


@interface EventsTVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) SpinnerView *spinner;
@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;


@end

@implementation EventsTVC

- (NSFetchedResultsController *)resultsController {
    
    if (!_resultsController && self.context) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Event class])];
        request.sortDescriptors = @[[self currentSortDescriptor]];

        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                 managedObjectContext:self.context
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
        
        _resultsController.delegate = self;
        
    }
    
    return _resultsController;
    
}

- (NSSortDescriptor *)currentSortDescriptor {

    NSDictionary *currentSettings = [SettingsController currentSettings];
    NSDictionary *sortOptions = currentSettings[SORT_OPTIONS];
    NSString *currentSortOption = sortOptions[CURRENT_SORT];

    NSString *sortKey = [[currentSortOption capitalizedString] stringByReplacingOccurrencesOfString:@" "
                                                                                         withString:@""];
    NSString *firstLetter = [sortKey substringToIndex:1].lowercaseString;
    sortKey = [firstLetter stringByAppendingString:[sortKey substringFromIndex:1]];

    BOOL asc = [sortOptions[currentSortOption] isEqualToString:SORT_ACS];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey
                                                                     ascending:asc
                                                                      selector:@selector(compare:)];
    return sortDescriptor;
    
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
        [self.spinner removeFromSuperview];
        
    }
    
}

- (void)subscribeToNotifications {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(documentReady:)
               name:DOCUMENT_READY_NOTIFICATION
             object:nil];

    [nc addObserver:self
           selector:@selector(fetchEvents)
               name:SORT_ORDER_CHANGED_NOTIFICATION
             object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self subscribeToNotifications];
    self.title = @"Events";
    self.spinner = [SpinnerView spinnerViewWithFrame:self.view.frame];
    [self.view addSubview:self.spinner];
    
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

    cell.textLabel.text = [NSString stringWithFormat:@"%@ — %@", event.name, [event completionText]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ — %@", [event startDateString], [event finishDateString]];
    
    [self setTypeImageForCell:cell
                        event:event];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showEventDetails"
                              sender:indexPath];
    
}

- (void)setTypeImageForCell:(UITableViewCell *)cell event:(Event *)event {
    
    NSString *typeImageName = nil;
    
    switch (event.type.integerValue) {
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
    
    [self setImage:typeImage
           forCell:cell];
    
}

- (void)setImage:(UIImage *)cellImage forCell:(UITableViewCell *)cell {
    
    if (!cellImage) return;
    
    cell.imageView.image = cellImage;
    
    CGFloat widthScale = CELL_IMAGE_HEIGHT / cellImage.size.width;
    CGFloat heightScale = CELL_IMAGE_HEIGHT / cellImage.size.height;
    
    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    
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
