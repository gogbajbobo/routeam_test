//
//  ParticipantsTVC.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "ParticipantsTVC.h"

@interface ParticipantsTVC ()

@end

@implementation ParticipantsTVC


#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Participants";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"participantCell"
                                                            forIndexPath:indexPath];
    return cell;

}



@end
