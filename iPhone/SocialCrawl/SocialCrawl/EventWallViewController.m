//
//  EventWallViewController.m
//  CampusCrawler
//
//  Created by Dan  Kaufman on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventWallViewController.h"
#import "WallPost.h"
#import "EventCommentsViewController.h"

@implementation EventWallViewController

@synthesize myTableView, spinner, loadingLabel, eventID;
@synthesize wallPostCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom Initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Wall";
    
    retrievedResults = NO;
    wallPosts = [[NSMutableArray alloc] init];
    
    SocialCrawlAppDelegate *appDelegate = (SocialCrawlAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [spinner startAnimating];
    
    [NSThread detachNewThreadSelector:@selector(loadWall) toTarget:self withObject:nil];
    
//    eventID = @"201994573163915"; //Blackhawks Bar Crawl
//    eventID = @"177706622280268"; //Test Bar Crawl
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   eventID, @"read_stream",
                                   nil];
    
    NSString *feedString = [NSString stringWithFormat:@"%@/feed", eventID];
    
}

- (void)viewDidUnload
{
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == POST_TO_WALL)
        return 1;
    else
        return [wallPosts count];
}

- (CGFloat)getMessageHeight:(NSString *) text {
    return [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:CGSizeMake(270,300) lineBreakMode:UILineBreakModeWordWrap].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath.section == POST_TO_WALL) {
        return 40;
    }
        
    else {
        WallPost *cellWallPost = [wallPosts objectAtIndex:indexPath.row];
        NSString *message = cellWallPost.message;
        
        CGFloat height = [self getMessageHeight:message];
        
        if (cellWallPost.numComments != 0)
            return height+80;
        else
            return height+45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == POST_TO_WALL) {
        ; //needed to compile without error
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.textLabel.text = @"Write Post";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        return cell;
    }
    
    else { //indexPath.section == WALL_POSTS
        if (!retrievedResults) {
            NSLog(@"Populating Table Before Retrieving Results!");
            static NSString *CellIdentifier = @"WallPostCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {            
                [[NSBundle mainBundle] loadNibNamed:@"WallPostCell" owner:self options:nil];
                cell = wallPostCell;
                self.wallPostCell = nil;
            }
            
            return cell;
        }
        
        else {
            static NSString *CellIdentifier = @"WallPostCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {            
                [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = wallPostCell;
                self.wallPostCell = nil;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row < [wallPosts count]) {
                WallPost *cellWallPost = [wallPosts objectAtIndex:indexPath.row];
                UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];        
                nameLabel.text = cellWallPost.name;
                
                UILabel *messageLabel = (UILabel*)[cell viewWithTag:2];
                messageLabel.text = cellWallPost.message;
                
                CGFloat height = [self getMessageHeight:cellWallPost.message];
                messageLabel.frame = CGRectMake(20, 25, 270, height);
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"eee, MMM dd 'at' hh:mm a"];
                UILabel *dateLabel = (UILabel*)[cell viewWithTag:3];
                dateLabel.text = [df stringFromDate:cellWallPost.date];
                dateLabel.frame = CGRectMake(20, 20+height, 270, 30);
                
                if (cellWallPost.numComments != 0) {
                    UIButton *commentsButton = (UIButton*)[cell viewWithTag:4];
                    
                    if (cellWallPost.numComments == 1) {
                        [commentsButton setTitle:[NSString stringWithFormat:@" %d comment", cellWallPost.numComments] forState:UIControlStateNormal];
                    }
                    else {
                        //should be cellWallPost.numComments, but due to not receiving all comments, temporarily are the number of comments we have
                        [commentsButton setTitle:[NSString stringWithFormat:@" %d comments", cellWallPost.numComments] forState:UIControlStateNormal];
                    }
                    commentsButton.frame = CGRectMake(20, 45+height, 123, 26);
                    
                    [commentsButton addTarget:self action:@selector(commentsButtonClick:) forControlEvents: UIControlEventTouchUpInside];
                    
                }
                
                else {
                    UIButton *commentsButton = (UIButton*)[cell viewWithTag:4];
                    commentsButton.hidden = YES;
                }
            }
            
            return cell;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == POST_TO_WALL) {
        SocialCrawlAppDelegate *appDelegate = (SocialCrawlAppDelegate*)[[UIApplication sharedApplication] delegate];
        
//        int EventID = 177706622280268
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       eventID, @"to",
                                       nil];
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Facebook Request Calls

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    NSLog(@"Result: %@", result);
    
    for (NSDictionary *wallPostings in [result objectForKey:@"data"]) {
        id name = [[wallPostings objectForKey:@"from"] objectForKey:@"name"];
        id postId = [wallPostings objectForKey:@"id"];
        id message = [wallPostings objectForKey:@"message"];
        id dateStr = [wallPostings objectForKey:@"created_time"];
        
        //2011-02-05T23:05:26+0000
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ"];
        NSDate *date = [df dateFromString:dateStr];
        WallPost *curPost = [[WallPost alloc] init];
        curPost.name = name;
        curPost.message = message;
        curPost.date = date;
        curPost.postId = postId;
        
        id comments = [wallPostings objectForKey:@"comments"];
        if (comments != NULL) {
            id numComments = [comments objectForKey:@"count"];
            curPost.numComments = [numComments intValue];
//            NSMutableArray *commentsArray = [[NSMutableArray alloc] initWithCapacity:[numComments intValue]];
//            for (NSDictionary *curComments in [comments objectForKey:@"data"]) {
//                id commentName = [[curComments objectForKey:@"from"] objectForKey:@"name"];
//                id commentMessage = [curComments objectForKey:@"message"];
//                id commentDateStr = [curComments objectForKey:@"created_time"];
//                
//                NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
//                [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ"];
//                NSDate *commentDate = [df dateFromString:commentDateStr];
//                FeedPost *commentPost = [[FeedPost alloc] init];
//                commentPost.name = commentName;
//                commentPost.message = commentMessage;
//                commentPost.date = commentDate;
//                
//                [commentsArray addObject:commentPost];
//            }
//            
//            curPost.comments = commentsArray;
        }
        
        else
            curPost.numComments = 0;
        
        [wallPosts addObject:curPost];
        
    }
    
    retrievedResults = YES;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Request Failed");
}

#pragma mark - Instance Methods

- (void)loadWall {
    @autoreleasepool {    
    
        NSLog(@"Requesting from facebook");
        
        while (!retrievedResults) {
            //        NSLog(@"waiting...");
        }
        
        NSLog(@"Done Requesting from facebook");
        
        [myTableView reloadData];
        
        [spinner stopAnimating];
        spinner.hidden = YES;
        loadingLabel.hidden = YES;
    }
}

#pragma mark - Event Methods

- (IBAction)commentsButtonClick:(id)sender {
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [myTableView indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    
    WallPost *curPost = [wallPosts objectAtIndex:indexPath.row];
    
    EventCommentsViewController *eventCommentsViewController = [[EventCommentsViewController alloc] initWithNibName:@"EventCommentsViewController" bundle:nil];
    
    eventCommentsViewController.wallPost = curPost;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:eventCommentsViewController animated:YES];
}

@end
