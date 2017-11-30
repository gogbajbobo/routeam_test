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
    [DataController requestEventsData];
    
}

- (void)documentNotReady:(UIManagedDocument *)document {
    
}


#pragma mark - class methods

+ (void)requestEventsData {
    
    [self getDataWithCompletionHandler:^(BOOL success, NSDictionary *data) {
        
        if (!success) return;
        [self handleEventsData:data];
        
    }];
    
}

+ (void)getDataWithCompletionHandler:(void (^)(BOOL success, NSDictionary *data))completionHandler {
    
    NSDictionary *returnData = [self eventsData];
    BOOL success = YES;
    
    completionHandler(success, returnData);
    
}

+ (NSDictionary *)eventsData {
    
    return @{};
    
}

+ (void)handleEventsData:(NSDictionary *)eventsData {
    
}


@end
