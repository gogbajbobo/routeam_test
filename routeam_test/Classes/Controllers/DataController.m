//
//  DataController.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "DataController.h"

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
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
    
    [DataController checkEventsData];
    
}

- (void)documentNotReady:(UIManagedDocument *)document {
    
}


#pragma mark - class methods

+ (NSManagedObjectContext *)context {
    return [DataController sharedController].document.managedObjectContext;
}

+ (void)checkEventsData {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Event class])];
    NSError *error = nil;
    
    NSUInteger eventsCount = [[self context] countForFetchRequest:request
                                                            error:&error];
    
    if (!eventsCount) {
        [self requestEventsData];
    } else {
        NSLog(@"eventsCount %@", @(eventsCount));
    }
    
}

+ (void)requestEventsData {
    
    [self getEventsDataWithCompletionHandler:^(BOOL success, NSArray <NSDictionary *> *data) {
        
        if (!success) return;
        [self handleEventsData:data];
        
    }];
    
}

+ (void)getEventsDataWithCompletionHandler:(void (^)(BOOL success, NSArray <NSDictionary *> *data))completionHandler {
    
    NSArray <NSDictionary *> *returnData = [self eventsData];
    BOOL success = YES;
    
    completionHandler(success, returnData);
    
}

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

+ (NSArray *)participantsWithEventId:(NSUInteger)eventId {
    return nil;
}

+ (NSDictionary *)participantWithId:(NSUInteger)participantId {
    return nil;
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
    
//    NSLog(@"eventObject %@", eventObject);
    
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


@end
