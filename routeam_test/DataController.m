//
//  DataController.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "DataController.h"

@implementation DataController


#pragma mark - singleton

+ (instancetype)sharedController {

    static dispatch_once_t pred = 0;
    __strong static id _sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;

}


#pragma mark - class methods

+ (void)requestEventsData {
    
    [self getDataWithCompletionHandler:^(BOOL success, NSDictionary *data) {
        
        if (!success) return;
        [self handleEventsData:data];
        
    }];
    
}

+ (void)getDataWithCompletionHandler:(void (^)(BOOL success, NSDictionary *data))completionHandler {
    
    NSDictionary *returnData = [self eventsData];
    BOOL success = YES;
    
    completionHandler(success, returnData);
    
}

+ (NSDictionary *)eventsData {
    
    return @{};
    
}

+ (void)handleEventsData:(NSDictionary *)eventsData {
    
}
@end
