//
//  InviteContactFriendsViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 8/26/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "InviteContactFriendsViewController.h"
#import "SelectBarsViewController.h"
#import <AddressBook/ABAddressBook.h>


@interface InviteContactFriendsViewController ()
@property (nonatomic, assign) ABAddressBookRef addressBook;
@end

@implementation InviteContactFriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create address book
    CFErrorRef error = NULL;
    self.addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (error) {
        NSLog(@"%@", error);
    }
    [self requestAddressBookAccess];
 }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)contactFriends
{
    if (!_contactFriends) {
        _contactFriends = [[NSMutableArray alloc] init];
    }
    return _contactFriends;
}

- (NSMutableArray *)selectedFriends
{
    if (!_selectedFriends) {
        _selectedFriends = [[NSMutableArray alloc] init];
    }
    return _selectedFriends;
}
- (void)dealloc
{
    if (_addressBook) {
        CFRelease(_addressBook);
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contactFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ABRecordRef person = (__bridge ABRecordRef)([self.contactFriends objectAtIndex:indexPath.row]);
    NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    cell.textLabel.text = [firstName stringByAppendingString:lastName];
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *seletedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (seletedCell.accessoryType == UITableViewCellAccessoryNone) {
        seletedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedFriends addObject:self.contactFriends[indexPath.row]];
    } else {
        seletedCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedFriends removeObject:self.contactFriends[indexPath.row]];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectBarsViewController *viewController = [segue destinationViewController];
    viewController.createdEvent = self.createdEvent;
}

#pragma mark -
#pragma mark Address Book Access
// Check the authorization status of our application for Address Book
-(void)checkAddressBookAccess
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            // Update our UI if the user has granted access to their Contacts
        case  kABAuthorizationStatusAuthorized:
            [self accessGrantedForAddressBook];
            break;
            // Prompt the user for access to Contacts if there is no definitive answer
        case  kABAuthorizationStatusNotDetermined :
            [self requestAddressBookAccess];
            break;
            // Display a message if the user has denied or restricted access to Contacts
        case  kABAuthorizationStatusDenied:
        case  kABAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
                                                            message:@"Permission was not granted for Contacts."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}
// Prompt the user for access to their Address Book data
-(void)requestAddressBookAccess
{
    InviteContactFriendsViewController * __weak weakSelf = self;
    
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 if (granted)
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [weakSelf accessGrantedForAddressBook];
                                                         
                                                     });
                                                 }
                                             });
}

// This method is called when the user has granted access to their address book data.
-(void)accessGrantedForAddressBook
{

    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people
                                                               );
    
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering()
                      );
    CFRelease(people);
    self.contactFriends = (NSMutableArray *)CFBridgingRelease(peopleMutable);
    [self.tableView reloadData];
}

@end
