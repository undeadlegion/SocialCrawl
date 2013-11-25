//
//  DrinkLoggerViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 3/8/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "DrinkLoggerViewController.h"
#import "AddDrinkViewController.h"

@interface DrinkLoggerViewController ()

@end

@implementation DrinkLoggerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}
- (NSMutableArray *)beerList
{
    if (!_beerList) {
        _beerList = [[NSMutableArray alloc] init];
    }
    return _beerList;
}
- (NSMutableArray *)wineList
{
    if (!_wineList) {
        _wineList = [[NSMutableArray alloc] init];
    }
    return _wineList;
}
- (NSMutableArray *)shotList
{
    if (!_shotList) {
        _shotList = [[NSMutableArray alloc] init];
    }
    return _shotList;
}

#pragma mark - Segue
- (IBAction)unwindToDrinkLogger:(UIStoryboardSegue *)segue
{
    AddDrinkViewController *viewController = segue.sourceViewController;
    if ([viewController isKindOfClass:[AddDrinkViewController class]]) {
        NSUInteger selectedButtonNumber = viewController.selectedButtonNumber;
        if (selectedButtonNumber == kBeerSection) {
            [self.beerList addObject:@{@"kind":@"Beer"}];
        }
        if (selectedButtonNumber == kWineSection) {
            [self.wineList addObject:@{@"kind":@"Wine"}];
        }
        if (selectedButtonNumber == kShotSection) {
            [self.shotList addObject:@{@"kind": @"Shot"}];
        }
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return (![self.beerList count]?0:1) + (![self.wineList count]?0:1) + (![self.shotList count]?0:1);
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kBeerSection) {
        return [self.beerList count];
    }
    if (section == kWineSection) {
        return [self.wineList count];
    }
    if (section == kShotSection) {
        return [self.shotList count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == kBeerSection) {
        return @"Beer";
    }
    if (section == kWineSection) {
        return @"Wine";
    }
    if (section == kShotSection) {
        return @"Shots";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DrinkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.detailTextLabel.text = @"x1";

    if (indexPath.section == kBeerSection) {
        cell.textLabel.text = self.beerList[indexPath.row][@"kind"];
    }
    if (indexPath.section == kWineSection) {
        cell.textLabel.text = self.wineList[indexPath.row][@"kind"];
    }
    if (indexPath.section == kShotSection) {
        cell.textLabel.text = self.shotList[indexPath.row][@"kind"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == kBeerSection) {
            [self.beerList removeObjectAtIndex:indexPath.row];
        }
        if (indexPath.section == kWineSection) {
            [self.wineList removeObjectAtIndex:indexPath.row];
        }
        if (indexPath.section == kShotSection) {
            [self.shotList removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView setEditing:NO animated:YES];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
