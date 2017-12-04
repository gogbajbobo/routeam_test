//
//  DataController.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "DataController.h"

#import <CoreData/CoreData.h>
#import "DataModel.h"


@interface DataController()

@property (nonatomic, strong) UIManagedDocument *document;


@end;


@implementation DataController


#pragma mark - singleton

+ (instancetype)sharedController {

    static dispatch_once_t pred = 0;
    __strong static id _sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;

}

+ (UIManagedDocument *)document {
    return [DataController sharedController].document;
}


#pragma mark - instance methods

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self prepareDocument];
    }
    return self;
    
}

- (void)prepareDocument {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSURL *documentDirectoryUrl = [fileManager URLsForDirectory:NSDocumentDirectory
                                                      inDomains:NSUserDomainMask].lastObject;
    NSURL *documentUrl = [documentDirectoryUrl URLByAppendingPathComponent:@"db_document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:documentUrl];
    
    if (![fileManager fileExistsAtPath:document.fileURL.path]) {
        
        [self createDocument:document];
        
    } else if (document.documentState == UIDocumentStateClosed) {
        
        [self openDocument:document];
        
    } else if (document.documentState == UIDocumentStateNormal) {
        
        [self documentReady:document];
        
    }
    
}

- (void)createDocument:(UIManagedDocument *)document {
    
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        [self handleHandlerForDocument:document
                               success:success];
        
    }];
    
}

- (void)openDocument:(UIManagedDocument *)document {
    
    [document openWithCompletionHandler:^(BOOL success) {
        
        [self handleHandlerForDocument:document
                               success:success];
        
    }];
    
}

- (void)handleHandlerForDocument:(UIManagedDocument *)document success:(BOOL)success {
    
    (success) ? [self documentReady:document] : [self documentNotReady:document];
    
}

- (void)documentReady:(UIManagedDocument *)document {
    
    self.document = document;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DOCUMENT_READY_NOTIFICATION
                                                        object:self.document];

}

- (void)documentNotReady:(UIManagedDocument *)document {
    
}


#pragma mark - class methods

+ (NSManagedObjectContext *)context {
    return [DataController sharedController].document.managedObjectContext;
}

+ (void)getEventsDataWithCompletionHandler:(void (^)(BOOL success, NSArray <NSDictionary *> *data))completionHandler {
    
    NSArray <NSDictionary *> *returnData = [self eventsData];
    [self handleEventsData:returnData];
    
    BOOL success = YES;
    if (completionHandler) completionHandler(success, returnData);
    
}

+ (void)getDetailDataForEventId:(NSNumber *)eventId withCompletionHandler:(void (^)(BOOL success, NSDictionary *data))completionHandler {
    
    NSDictionary *event = [self eventWithId:eventId.integerValue];
    [self handleEvent:event];
    
    NSArray <NSDictionary *> *participants = [self participantsWithEventId:eventId.integerValue];
    [participants enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull participant, NSUInteger idx, BOOL * _Nonnull stop) {
        [self handleParticipant:participant withEventId:eventId];
    }];
    
//    NSLog(@"%@ participants for event #%@", @(participants.count), eventId);
    
    NSMutableDictionary *returnData = @{@"event": event,
                                        @"participants": participants
                                        }.mutableCopy;

    BOOL success = YES;
    if (completionHandler) completionHandler(success, returnData);

}


#pragma mark - events

+ (NSArray <NSDictionary *> *)eventsData {
    
    NSMutableArray <NSDictionary *> *result = @[].mutableCopy;
    
    for (NSUInteger i = 0; i < 10; i++) {
        [result addObject:[self eventWithId:i]];
    }
    
    return result;
    
}

+ (NSDictionary *)eventWithId:(NSUInteger)eventId {
    
    NSString *idString = @(eventId).stringValue;
    double secInHour = 3600;
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-(eventId * 24 * secInHour)];
    NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:(eventId * 24 + 12) * secInHour];
    double completion = 1.0 - eventId / 10.0;
    EventType type = eventId % 3;

    NSDictionary *event = @{@"eventId": @(eventId),
                            @"name": [@"Event #" stringByAppendingString:idString],
                            @"startDate": startDate,
                            @"finishDate": finishDate,
                            @"info": [NSString stringWithFormat:@"Event info #%@", idString],
                            @"completion": @(completion),
                            @"type": @(type)
                            };
    
    return event;
    
}

+ (void)handleEventsData:(NSArray <NSDictionary *> *)eventsData {
    
    [eventsData enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
        [self handleEvent:event];
    }];
    
}

+ (void)handleEvent:(NSDictionary *)event {

    NSNumber *eventId = event[@"eventId"];
    
    if (!eventId) return;
    
    Event *eventObject = [self eventObjectWithId:eventId];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Event class])
                                              inManagedObjectContext:[self context]];

    NSArray *attributes = entity.attributesByName.allKeys;

    for (NSString *attribute in attributes) {
        
        if (!event[attribute]) continue;
        
        [eventObject setValue:event[attribute]
                       forKey:attribute];
        
    }
    
}

+ (Event *)eventObjectWithId:(NSNumber *)eventId {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Event class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId == %@", eventId];
    request.predicate = predicate;
    
    NSError *error = nil;

    Event *eventObject = [[self context] executeFetchRequest:request
                                                       error:&error].lastObject;
    
    if (!eventObject) eventObject = [self newEventObjectWithId:eventId];
    
    return eventObject;
    
}

+ (Event *)newEventObjectWithId:(NSNumber *)eventId {
    
    Event *eventObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Event class])
                                                       inManagedObjectContext:[self context]];
    eventObject.eventId = eventId;
    
    return eventObject;
    
}


#pragma mark - participants

+ (NSArray <NSDictionary *> *)participantsWithEventId:(NSUInteger)eventId {
    
    NSMutableArray <NSDictionary *> *result = @[].mutableCopy;
    
    for (NSUInteger i = 0; i < (eventId % 4) + 1; i++) {
        [result addObject:[self participantWithId:i]];
    }
    
    return result;
    
}

+ (NSDictionary *)participantWithId:(NSUInteger)participantId {
    
    NSString *idString = @(participantId).stringValue;
    double completion = 1.0 - participantId / 20.0;
    double plan = 0.05 * participantId;
    
    NSDictionary *participant = @{@"participantId": @(participantId),
                                  @"name": [@"Participant #" stringByAppendingString:idString],
                                  @"plan": @(plan),
                                  @"completion": @(completion)
                                  };
    
    return participant;
    
}

+ (void)handleParticipant:(NSDictionary *)participant withEventId:(NSNumber *)eventId {
    
    NSNumber *participantId = participant[@"participantId"];
    
    if (!participantId) return;
    
    Participant *participantObject = [self participantObjectWithId:participantId];
    participantObject.event = [self eventObjectWithId:eventId];

    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Participant class])
                                              inManagedObjectContext:[self context]];

    NSArray *attributes = entity.attributesByName.allKeys;

    for (NSString *attribute in attributes) {

        if (!participant[attribute]) continue;

        [participantObject setValue:participant[attribute]
                             forKey:attribute];

    }
    
}

+ (Participant *)participantObjectWithId:(NSNumber *)participantId {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Participant class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"participantId == %@", participantId];
    request.predicate = predicate;
    
    NSError *error = nil;
    
    Participant *participantObject = [[self context] executeFetchRequest:request
                                                                   error:&error].lastObject;
    
    if (!participantObject) participantObject = [self newParticipantObjectWithId:participantId];
    
    return participantObject;
    
}

+ (Participant *)newParticipantObjectWithId:(NSNumber *)participantId {
    
    Participant *participantObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Participant class])
                                                                   inManagedObjectContext:[self context]];
    participantObject.participantId = participantId;
    
    return participantObject;

}


@end
