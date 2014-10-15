//
//  ContactDetailsTableViewController.h
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactDetailsTableViewController : UITableViewController

// Outlets
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;
// Properties
@property (nonatomic, strong) Contact *contact;


@end
