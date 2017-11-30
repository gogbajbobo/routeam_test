//
//  Event+CoreDataProperties.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

@dynamic completion;
@dynamic finishDate;
@dynamic eventId;
@dynamic info;
@dynamic name;
@dynamic startDate;
@dynamic type;
@dynamic participants;

@end
