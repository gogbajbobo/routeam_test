//
//  DataController.h
//  routeam_test
//
//  Created by Maxim Grigoriev on 30/11/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


#define DOCUMENT_READY_NOTIFICATION @"documentReady"


@interface DataController : NSObject

+ (instancetype)sharedController;

+ (UIManagedDocument *)document;

+ (void)getEventsDataWithCompletionHandler:(void (^)(BOOL success, NSArray <NSDictionary *> *data))completionHandler;


@end
