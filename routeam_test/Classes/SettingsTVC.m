//
//  SettingsTVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "SettingsTVC.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC


#pragma mark - view lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"Settings";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"
                                                            forIndexPath:indexPath];
    return cell;
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
