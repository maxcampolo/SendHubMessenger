//
//  NewMessageTableViewController.h
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface NewMessageTableViewController : UITableViewController

// Outlets
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *sendButton;

// Class properties
@property (nonatomic, strong) Contact *contact;

@end
