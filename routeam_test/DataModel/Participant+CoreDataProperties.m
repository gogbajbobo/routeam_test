//
//  Participant+CoreDataProperties.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//
//

#import "Participant+CoreDataProperties.h"

@implementation Participant (CoreDataProperties)

+ (NSFetchRequest<Participant *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Participant"];
}

@dynamic completion;
@dynamic id;
@dynamic name;
@dynamic plan;
@dynamic event;

@end
