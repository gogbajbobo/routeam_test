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

@property (nonatomic) double completion;
@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) double plan;
@property (nullable, nonatomic, retain) Event *event;

@end

NS_ASSUME_NONNULL_END
