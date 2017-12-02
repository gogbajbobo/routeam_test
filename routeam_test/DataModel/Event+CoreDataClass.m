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


@end
