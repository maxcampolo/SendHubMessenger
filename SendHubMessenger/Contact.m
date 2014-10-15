//
//  Contact.m
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (id)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        _ID = [[dict objectForKey:@"id"] stringValue];
        _name = [dict objectForKey:@"name"];
        _number = [dict objectForKey:@"number"];
    }
    return self;
}

// Return a Contact object from a dictionary
+(Contact*)contactWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

// Return an array of Contact objects from an array of dictionaries
+(NSArray*)contactsWithArray:(NSArray*)array {
    NSMutableArray *contacts = [NSMutableArray array];
    for(NSDictionary *dc in array){
        Contact *contact = [Contact contactWithDict:dc];
        [contacts addObject:contact];
    }
    return [NSArray arrayWithArray:contacts];
}

#pragma mark - NSCoding protocol

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.ID forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.number forKey:@"number"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.ID = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.number = [decoder decodeObjectForKey:@"number"];
    }
    return self;
}


@end
