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
    
    NSData *settingsData = [userDefaults dataForKey:@"settings"];
    if (!settingsData) return [self initSettings];
    
    NSDictionary *settings = [NSKeyedUnarchiver unarchiveObjectWithData:settingsData];
    
    return settings;
    
}

+ (NSArray *)mainKeys {
    return @[SORT_OPTIONS, FILTER_OPTIONS];
}

+ (NSArray *)sortKeys {
    return @[SORT_TYPE, SORT_NAME, SORT_STARTDATE, SORT_FINISHDATE, SORT_COMPLETION, CURRENT_SORT];
}

+ (NSArray *)defaultSortValues {
    return @[SORT_ACS, SORT_DESC, SORT_ACS, SORT_ACS, SORT_ACS, SORT_NAME];
}

+ (NSArray *)filterKeys {
    return @[FILTER_TYPE, FILTER_NAME, FILTER_STARTDATE, FILTER_FINISHDATE, FILTER_COMPLETION_MIN, FILTER_COMPLETION_MAX];
}

+ (NSArray *)defaultFilterValues {
    
    NSMutableArray *filterStates = @[].mutableCopy;
    
    [[self filterKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [filterStates addObject:@{FILTER_STATE: @(FILTER_OFF)}.mutableCopy];
    }];
    
    return filterStates;
    
}

+ (NSDictionary *)initSettings {
    
    NSMutableDictionary *sortOptions = [NSMutableDictionary dictionaryWithObjects:[self defaultSortValues]
                                                                          forKeys:[self sortKeys]];
    
    NSMutableDictionary *filterOptions = [NSMutableDictionary dictionaryWithObjects:[self defaultFilterValues]
                                                                            forKeys:[self filterKeys]];
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithObjects:@[sortOptions, filterOptions]
                                                                       forKeys:[self mainKeys]];
    [self saveSettings:settings];
    
    return settings;
    
}

+ (void)saveSettings:(NSDictionary *)settings {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:settings]
                     forKey:@"settings"];
    [userDefaults synchronize];

}

+ (void)setNewSettingValue:(NSDictionary *)settingDic {
    
    NSString *option = settingDic[@"option"];
    if (![[self mainKeys] containsObject:option]) return;
    
    NSString *setting = settingDic[@"setting"];
    if (![[self sortKeys] containsObject:setting] &&
        ![[self filterKeys] containsObject:setting]) return;

    id value = settingDic[@"value"];
    if (!value) return;
    
    NSMutableDictionary *currentSettings = [self currentSettings].mutableCopy;
    
    currentSettings[option][setting] = value;
    
    [self saveSettings:currentSettings];
    
}


@end
