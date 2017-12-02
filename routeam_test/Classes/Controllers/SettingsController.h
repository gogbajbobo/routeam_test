//
//  SettingsController.h
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SORT_ORDER_CHANGED_NOTIFICATION @"sortOrderChanged"

#define SORT_OPTIONS @"sortOptions"
#define FILTER_OPTIONS @"filterOptions"

#define SORT_TYPE @"Type"
#define SORT_NAME @"Name"
#define SORT_STARTDATE @"Start date"
#define SORT_FINISHDATE @"Finish date"
#define SORT_COMPLETION @"Completion"
#define CURRENT_SORT @"Current"

#define SORT_ACS @"acs"
#define SORT_DESC @"desc"


@interface SettingsController : NSObject

+ (NSDictionary *)currentSettings;
+ (NSArray *)sortKeys;

+ (void)setNewSettingValue:(NSDictionary *)settingDic;


@end
