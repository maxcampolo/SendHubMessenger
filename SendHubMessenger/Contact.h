//
//  Contact.h
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

// Contact model properties
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;

// Methods for returning contact models
+(Contact*)contactWithDict:(NSDictionary *)dict;
+(NSArray*)contactsWithArray:(NSArray*)array;

@end
