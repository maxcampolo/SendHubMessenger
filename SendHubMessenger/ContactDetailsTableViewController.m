//
//  ContactDetailsTableViewController.m
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

// View Controller
#import "ContactDetailsTableViewController.h"
#import "NewMessageTableViewController.h"

@interface ContactDetailsTableViewController ()

@end

@implementation ContactDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up navigation bar
    [self.navigationItem setTitle:@"Details"];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:255.0/255.0 green:108.0/255.0 blue:10.0/255.0 alpha:1]];
    
    // Set name and number from Contact object
    [self.nameLabel setText:self.contact.name];
    [self.numberLabel setText:self.contact.number];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"NewMessageSegue" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NewMessageTableViewController *vc = (NewMessageTableViewController*)[[segue destinationViewController] topViewController];
    [vc setContact:self.contact];
}

// Unwind segue to this controller
- (IBAction)unwindToContactDetails:(UIStoryboardSegue*)sender {
    // Unwind the segue
    NSLog(@"Unwound to contact details");
}


@end
