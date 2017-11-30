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
#import "DataModel/DataModel.h"


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
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-(eventId * 24 * 3600)];
    NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:-(eventId * 12 * 3600)];
    NSNumber *completion = @(10 * eventId);
    EventType type = 3 % (eventId + 1);

    NSDictionary *event = @{@"id": @(eventId),
                            @"name": [@"Event " stringByAppendingString:idString],
                            @"startDate": startDate,
                            @"finishDate": finishDate,
                            @"info": [NSString stringWithFormat:@"Event %@ info", idString],
                            @"completion": completion,
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

    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Event class])
                                              inManagedObjectContext:[self context]];
    
    NSArray *attributes = entity.attributesByName.allKeys;

    for (NSString *attribute in attributes) {
        
        if (!event[attribute]) continue;
        
        NSAttributeDescription *attributeDescription = entity.attributesByName[attribute];
        NSString *attributeClass = attributeDescription.attributeValueClassName;
        
        NSLog(@"attributeClass %@", attributeClass);
        NSLog(@"event[attribute] %@", event[attribute]);
        
        
    }
    
}


@end
