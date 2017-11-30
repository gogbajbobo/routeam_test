//
//  Participant+CoreDataProperties.h
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//
//

#import "Participant+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Participant (CoreDataProperties)

+ (NSFetchRequest<Participant *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *completion;
@property (nullable, nonatomic, copy) NSNumber *participantId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *plan;
@property (nullable, nonatomic, retain) Event *event;

@end

NS_ASSUME_NONNULL_END
