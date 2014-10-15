//
//  NewMessageTableViewController.m
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

// View Controller
#import "NewMessageTableViewController.h"
// Networking
#import "SendHubAPIClient.h"
// Framework
#import <SVProgressHUD/SVProgressHUD.h>

@interface NewMessageTableViewController () <UITextViewDelegate>

@end

@implementation NewMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up view
    [self.nameLabel setText:self.contact.name];
    
    // Set self as delegate for text view
    [self.messageTextView setDelegate:self];
    
    // Initially set send button as not enabled - we won't allow blank messages
    [self.sendButton setEnabled:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    // Set messageTextView as first responder for keyboard
    [self.messageTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

// Send message action
- (IBAction)sendMessage:(id)sender {
    [SVProgressHUD setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:255.0/255.0 green:108.0/255.0 blue:10.0/255.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Sending..."];
    // Send the message with SendHub API
    [[SendHubAPIClient sharedClient] sendMessageToContactWithId:self.contact.ID withText:self.messageTextView.text onSuccess:^{
        // Success
        [SVProgressHUD showSuccessWithStatus:@"Sent!"];
        [self performSegueWithIdentifier:@"UnwindToContactDetailsFromSend" sender:self];
    } onFailure:^{
        // Failure
        [SVProgressHUD showErrorWithStatus:@"Message not sent"];
        [self performSegueWithIdentifier:@"UnwindToContactDetailsFromSend" sender:self];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}


#pragma mark - Text View Delegate

- (void)textViewDidChange:(UITextView *)textView {
    // Check the number of characters
    long numChars = (long)[self.messageTextView.text length];
    // If user has entered text enable the send button
    if (numChars > 0) {
        [self.sendButton setEnabled:YES];
    } else {
        [self.sendButton setEnabled:NO];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Resign the first responder
    [self.messageTextView resignFirstResponder];
}


@end
