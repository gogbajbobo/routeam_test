//
//  SettingsController.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

+ (NSDictionary *)currentSettings {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *settings = [userDefaults dictionaryForKey:@"settings"];
    
    if (!settings) settings = [self initSettings];
    
    return settings;
    
}

+ (NSArray *)sortKeys {
    return @[SORT_TYPE, SORT_NAME, SORT_STARTDATE, SORT_FINISHDATE, SORT_COMPLETION, CURRENT_SORT];
}

+ (NSArray *)sortValues {
    return @[SORT_ACS, SORT_DESC, SORT_ACS, SORT_ACS, SORT_ACS, SORT_NAME];
}

+ (NSDictionary *)initSettings {
    
    NSDictionary *sortOptions = [NSDictionary dictionaryWithObjects:[self sortValues]
                                                            forKeys:[self sortKeys]];
    
    NSDictionary *filterOptions = @{};
    
    NSDictionary *settings = @{SORT_OPTIONS: sortOptions,
                               FILTER_OPTIONS: filterOptions
                               };

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:settings
                     forKey:@"settings"];
    [userDefaults synchronize];
    
    return settings;
    
}


@end
