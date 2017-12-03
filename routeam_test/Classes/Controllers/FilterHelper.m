//
//  FilterHelper.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 02/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "FilterHelper.h"

#import "SettingsController.h"


@implementation FilterHelper

+ (NSPredicate *)eventsPredicate {
    
    NSDictionary *filterSettings = [SettingsController currentSettings][FILTER_OPTIONS];
    NSArray *filterKeys = [SettingsController filterKeys];
    NSMutableArray *predicates = @[].mutableCopy;
    
    for (NSString *filterKey in filterKeys) {
        
        NSNumber *filterState = filterSettings[filterKey][FILTER_STATE];
        if (filterState.boolValue) {
            [predicates addObject:[self predicateForFilterKey:filterKey]];
        }
        
    }
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
}

+ (NSPredicate *)predicateForFilterKey:(NSString *)filterKey {

    NSDictionary *filterSettings = [SettingsController currentSettings][FILTER_OPTIONS];
    id filterValue = filterSettings[filterKey][FILTER_VALUE];
    
    if ([filterKey isEqualToString:FILTER_TYPE]) {
        return [NSPredicate predicateWithFormat:@"type == %@", filterValue];
    } else if ([filterKey isEqualToString:FILTER_NAME] && ![filterValue isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"name contains[cd] %@", filterValue];
    } else if ([filterKey isEqualToString:FILTER_STARTDATE]) {
//        return [NSPredicate predicateWithFormat:@"startDate >= %@", filterValue];
    } else if ([filterKey isEqualToString:FILTER_FINISHDATE]) {
//        return [NSPredicate predicateWithFormat:@"finishDate <= %@", filterValue];
    } else if ([filterKey isEqualToString:FILTER_COMPLETION_MIN]) {
        return [NSPredicate predicateWithFormat:@"completion >= %@", filterValue];
    } else if ([filterKey isEqualToString:FILTER_COMPLETION_MAX]) {
        return [NSPredicate predicateWithFormat:@"completion <= %@", filterValue];
    }

    return [NSPredicate predicateWithFormat:@"1 == 1"];

}


@end
