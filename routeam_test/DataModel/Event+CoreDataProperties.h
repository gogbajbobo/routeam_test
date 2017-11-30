//
//  Event+CoreDataProperties.h
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//
//

#import "Event+CoreDataClass.h"

typedef NS_ENUM(NSUInteger, EventType) {
    EventTypeUnits,
    EventTypeSum,
    EventTypeNames
};

NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest;

@property (nonatomic) double completion;
@property (nullable, nonatomic, copy) NSDate *finishDate;
@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSString *info;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nonatomic) int16_t type;
@property (nullable, nonatomic, retain) NSSet<Participant *> *participants;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addParticipantsObject:(Participant *)value;
- (void)removeParticipantsObject:(Participant *)value;
- (void)addParticipants:(NSSet<Participant *> *)values;
- (void)removeParticipants:(NSSet<Participant *> *)values;

@end

NS_ASSUME_NONNULL_END
