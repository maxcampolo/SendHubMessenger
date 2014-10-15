//
//  ContactsTableViewController.m
//  SendHubMessenger
//
//  Created by Max Campolo on 10/8/14.
//  Copyright (c) 2014 Maxim Campolo. All rights reserved.
//

// View Controller
#import "ContactsTableViewController.h"
#import "ContactDetailsTableViewController.h"
// Networking
#import "SendHubAPIClient.h"
// Model
#import "Contact.h"
// Framework
#import <SVProgressHUD/SVProgressHUD.h>

@interface ContactsTableViewController ()

@property (nonatomic, strong) NSMutableArray *contactsArray;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Preferences for progress HUD
    [SVProgressHUD setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:255.0/255.0 green:108.0/255.0 blue:10.0/255.0 alpha:1]];
    
    // Get the users contacts
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[[defaults dictionaryRepresentation] allKeys] containsObject:@"savedContacts"]) {
        // If user does not have previously saved contacts
        [self getUserContacts];
    } else {
        // If user has saved contacts
        [self getSavedUserContacts];
    }
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
    return self.contactsArray.count;
}

#pragma mark - Helper

// Get the user contacts from SendHub
- (void)getUserContacts {
    [SVProgressHUD showWithStatus:@"Getting contacts..."];
    // Get contacts from SendHub API
    [[SendHubAPIClient sharedClient] fetchContactsForUserOnSuccess:^(NSArray *contacts) {
        // Clear the contacts array and update the table data source
        [_contactsArray removeAllObjects];
        [self updateDataSource:contacts];
        [self storeUserContacts:contacts];
        [SVProgressHUD dismiss];
    } onFailure:^{
        // Failure code
        [SVProgressHUD showErrorWithStatus:@"Could not get contacts"];
    }];
}

// Update the data source for the table view
- (void)updateDataSource:(NSArray*)objects {
    if(!_contactsArray)
        _contactsArray = [NSMutableArray arrayWithCapacity:objects.count];
    [_contactsArray addObjectsFromArray:objects];
    [self.tableView reloadData];
}

// Get user contacts that have previously been saved
- (void)getSavedUserContacts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"savedContacts"];
    NSArray *savedContactsArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(!_contactsArray)
        _contactsArray = [[NSMutableArray alloc] init];
    [_contactsArray removeAllObjects];
    [_contactsArray addObjectsFromArray:savedContactsArray];
}

// Store user contacts after retreiving them
- (void)storeUserContacts:(NSArray*)objects {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:objects] forKey:@"savedContacts"];
    [defaults synchronize];

}

#pragma mark - UITableViewCell Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get a new table view cell - just going to use generic table view cells here
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%li", (long)indexPath.row];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the contact name as the text label of the cell
    Contact *contact = [self.contactsArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:contact.name];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ContactDetailsSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - Action

// Action for refreshing contact list
- (IBAction)onRefresh:(id)sender {
    [self getUserContacts];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ContactDetailsSegue"]) {
        ContactDetailsTableViewController *vc = [segue destinationViewController];
        UITableViewCell *cell = sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        Contact *current = [self.contactsArray objectAtIndex:indexPath.row];
        [vc setContact:current];
    }
    
}


@end
