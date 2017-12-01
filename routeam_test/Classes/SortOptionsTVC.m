//
//  SortOptionsTVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "SortOptionsTVC.h"

@interface SortOptionsTVC ()

@end

@implementation SortOptionsTVC

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


@end
