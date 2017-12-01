//
//  SortOptionsTVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "SortOptionsTVC.h"

#import "SettingsController.h"


@interface SortOptionsTVC ()

@property (nonatomic) NSInteger currentSortOptionIndex;


@end

@implementation SortOptionsTVC


- (NSInteger)currentSortOptionIndex {

    NSString *currentSortOption = [self sortOptions][CURRENT_SORT];
    return [[SettingsController sortKeys] indexOfObject:currentSortOption];
    
}

- (NSDictionary *)sortOptions {

    NSDictionary *currentSettings = [SettingsController currentSettings];
    NSDictionary *sortOptions = currentSettings[SORT_OPTIONS];
    
    return sortOptions;
    
}


#pragma mark - view lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"Sort options";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sortOptionCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [self cellTitleForIndexPath:indexPath];
    
    [cell setSelected:(indexPath.row == [self currentSortOptionIndex])];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelected:(indexPath.row == [self currentSortOptionIndex])];
}

- (NSString *)cellTitleForIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return @"Type";
            break;

        case 1:
            return @"Name";
            break;

        case 2:
            return @"Start date";
            break;

        case 3:
            return @"Finish date";
            break;

        case 4:
            return @"Completion";
            break;

        default:
            return nil;
            break;
    }
    
}


@end
