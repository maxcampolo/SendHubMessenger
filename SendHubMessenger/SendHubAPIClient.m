//
//  SendHubAPIClient.m
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "SendHubAPIClient.h"
// Framework
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
// Model
#import "Contact.h"

// Define constants
#define BASE_URL @"https://api.sendhub.com/v1/"
#define SERVER_ERROR 500
#define API_KEY @"INSERT API KEY"
#define USERNAME @"INSERT PHONE NUMBER"

@interface SendHubAPIClient (){
    AFHTTPRequestOperationManager *manager;
}

-(void)handleErrors:(AFHTTPRequestOperation*)operation;
-(void)configureAPIClient;
-(void)configureRequestOperationManager;
-(void)configureReachability;
@end

static SendHubAPIClient *instance;

@implementation SendHubAPIClient

+(SendHubAPIClient *)sharedClient {
    if (!instance) {
        instance = [[SendHubAPIClient alloc] init];
        [instance configureAPIClient];
    }
    return instance;
}

# pragma mark - Configuration

-(void)configureAPIClient{
    [self configureRequestOperationManager];
    [self configureReachability];
}

-(void)configureReachability{
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
}

-(void)configureRequestOperationManager{
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
}

#pragma mark - Request Methods

// Request a user's contacts
- (void)fetchContactsForUserOnSuccess:(void (^)(NSArray *contacts))success onFailure:(void (^)(void))failure {
    // Compose url for requesting contacts
    NSString *url= [NSString stringWithFormat:@"contacts/?username=%@&api_key=%@&limit=400", USERNAME, API_KEY];
    
    // Perform GET request to contacts URL
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Make array of contact models from returned responseObject
        NSArray *contacts = [[NSArray alloc] init];
        contacts = [Contact contactsWithArray:[responseObject objectForKey:@"objects"]];
        
        success(contacts);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleErrors:operation];
        failure();
    }];
}

// Send a message to a contact
- (void)sendMessageToContactWithId:(NSString*)contactID withText:(NSString*)text onSuccess:(void (^)(void))success onFailure:(void (^)(void))failure {
    
    // Compose url for sending message
    NSString *url = [NSString stringWithFormat:@"messages/?username=%@&api_key=%@", USERNAME, API_KEY];
    
    // Define post data as parameters
    NSArray *contactsArray = [NSArray arrayWithObject:contactID];
    NSDictionary *params = @{@"contacts": contactsArray, @"text": text};
    
    // Set request serializer as JSON so we can send JSON formatted data
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Perform post request to Messages resource
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}

#pragma mark - Handler Methods

-(void)handleErrors:(AFHTTPRequestOperation*)operation{
    
    NSString *errorMsg;
    if(operation.response == nil)
        errorMsg = @"We had a problem trying to fetch the data";
    else if(operation.response.statusCode == SERVER_ERROR)
        errorMsg = @"Server Error";
    
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
}

@end
