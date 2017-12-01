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

    NSString *sortOrder = [self sortOptions][[SettingsController sortKeys][indexPath.row]];
    UIImage *sortImage = [[UIImage imageNamed:sortOrder] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:sortImage];
    accessoryView.tintColor = cell.selected ? [UIColor blueColor] : [UIColor lightGrayColor];
    
    cell.accessoryView = accessoryView;
    
}


@end
