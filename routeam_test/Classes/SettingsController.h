//
//  SettingsController.h
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SORT_OPTIONS @"sortOptions"
#define FILTER_OPTIONS @"filterOptions"

#define SORT_TYPE @"type"
#define SORT_NAME @"name"
#define SORT_STARTDATE @"startDate"
#define SORT_FINISHDATE @"finishDate"
#define SORT_COMPLETION @"completion"
#define CURRENT_SORT @"current"

#define SORT_ACS @"acs"
#define SORT_DESC @"desc"


@interface SettingsController : NSObject

+ (NSDictionary *)currentSettings;

+ (NSArray *)sortKeys;


@end
