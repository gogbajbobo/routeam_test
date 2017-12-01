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
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    cell.textLabel.text = [SettingsController sortKeys][indexPath.row];

    [cell setSelected:(indexPath.row == [self currentSortOptionIndex])];

    NSString *sortOrder = [self sortOrderForIndexPath:indexPath];
    UIImage *sortImage = [[UIImage imageNamed:sortOrder] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:sortImage];
    accessoryView.tintColor = cell.selected ? [UIColor blueColor] : [UIColor lightGrayColor];
    
    cell.accessoryView = accessoryView;
    
}

- (NSString *)sortOrderForIndexPath:(NSIndexPath *)indexPath {
    return [self sortOptions][[SettingsController sortKeys][indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self currentSortOptionIndex] == indexPath.row) {
        
        NSString *sortOrder = [self sortOrderForIndexPath:indexPath];
        
        if ([sortOrder isEqualToString:SORT_ACS]) {
            sortOrder = SORT_DESC;
        } else if ([sortOrder isEqualToString:SORT_DESC]) {
            sortOrder = SORT_ACS;
        }

        NSDictionary *newSortSetting = @{@"option": SORT_OPTIONS,
                                         @"setting": [SettingsController sortKeys][indexPath.row],
                                         @"value": sortOrder
                                         };
        
        [SettingsController setNewSettingValue:newSortSetting];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        
    } else {
        
        NSDictionary *newCurrentSortSetting = @{@"option": SORT_OPTIONS,
                                                @"setting": CURRENT_SORT,
                                                @"value": [SettingsController sortKeys][indexPath.row]
                                                };

        [SettingsController setNewSettingValue:newCurrentSortSetting];

    }
    
}


@end
