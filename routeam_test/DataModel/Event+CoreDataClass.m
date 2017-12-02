//
//  Event+CoreDataClass.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//
//

#import "Event+CoreDataClass.h"

@implementation Event

- (NSString *)completionText {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;

    return [numberFormatter stringFromNumber:self.completion];
    
}

- (NSString *)startDateString {
    return [[self dateFormatter] stringFromDate:self.startDate];
}

- (NSString *)finishDateString {
    return [[self dateFormatter] stringFromDate:self.finishDate];
}

- (NSDateFormatter *)dateFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return dateFormatter;
    
}

- (NSString *)typeImageName {
    
    NSString *typeImageName = nil;
    
    EventType type = self.type.integerValue;
    
    switch (type) {
        case EventTypeUnits:
            typeImageName = @"icons8-expensive_filled";
            break;
        case EventTypeSum:
            typeImageName = @"icons8-sigma_filled";
            break;
        case EventTypeNames:
            typeImageName = @"icons8-table_of_content_filled";
            break;
            
        default:
            break;
    }
    
    return typeImageName;

}


@end
