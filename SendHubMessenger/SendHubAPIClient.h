//
//  SendHubAPIClient.h
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendHubAPIClient : NSObject

// Singleton
+(SendHubAPIClient *)sharedClient;

// API methods
- (void)fetchContactsForUserOnSuccess:(void (^)(NSArray *contacts))success onFailure:(void (^)(void))failure;
- (void)sendMessageToContactWithId:(NSString*)contactID withText:(NSString*)text onSuccess:(void (^)(void))success onFailure:(void (^)(void))failure;

@end
