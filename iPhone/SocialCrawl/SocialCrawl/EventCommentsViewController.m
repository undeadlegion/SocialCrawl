//
//  EventCommentsViewController.m
//  CampusCrawler
//
//  Created by Dan  Kaufman on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventCommentsViewController.h"


@implementation EventCommentsViewController

@synthesize wallPostCell, wallPost, myTableView, spinner, loadingLabel;

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
    
    self.title = @"Comments";
    
    retrievedResults = NO;
    
      
    [spinner startAnimating];
    
    [NSThread detachNewThreadSelector:@selector(loadComments) toTarget:self withObject:nil];
    
    NSString *feedString = [NSString stringWithFormat:@"%@/comments", wallPost.postId];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setSpinner:nil];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!retrievedResults)
        return 1;
    else
        return [wallPost.comments count] + 1;
}

- (CGFloat)getMessageHeight:(NSString *) text {
    return [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:CGSizeMake(270,300) lineBreakMode:UILineBreakModeWordWrap].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath.row == 0) {
        NSString *message = wallPost.message;
        
        CGFloat height = [self getMessageHeight:message];
        
        return height+45;
    }
    
    else {
        FeedPost *commentPost = [wallPost.comments objectAtIndex:(indexPath.row-1)];
        NSString *message = commentPost.message;
        
        CGFloat height = [self getMessageHeight:message];
        
        return height+45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WallPostCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {            
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = wallPostCell;
        self.wallPostCell = nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *commentsButton = (UIButton*)[cell viewWithTag:4];
    commentsButton.hidden = YES;
    
    if (indexPath.row == 0) {
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];        
        nameLabel.text = wallPost.name;
        
        UILabel *messageLabel = (UILabel*)[cell viewWithTag:2];
        messageLabel.text = wallPost.message;
        
        CGFloat height = [self getMessageHeight:wallPost.message];
        messageLabel.frame = CGRectMake(20, 25, 270, height);
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"eee, MMM dd 'at' hh:mm a"];
        UILabel *dateLabel = (UILabel*)[cell viewWithTag:3];
        dateLabel.text = [df stringFromDate:wallPost.date];
        dateLabel.frame = CGRectMake(20, 20+height, 270, 30);
    }
    
    else if (indexPath.row < ([wallPost.comments count]+1)) {
        FeedPost *commentPost = [wallPost.comments objectAtIndex:(indexPath.row-1)];
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];        
        nameLabel.text = commentPost.name;
        
        UILabel *messageLabel = (UILabel*)[cell viewWithTag:2];
        messageLabel.text = commentPost.message;
        
        CGFloat height = [self getMessageHeight:commentPost.message];
        messageLabel.frame = CGRectMake(20, 25, 270, height);
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"eee, MMM dd 'at' hh:mm a"];
        UILabel *dateLabel = (UILabel*)[cell viewWithTag:3];
        dateLabel.text = [df stringFromDate:commentPost.date];
        dateLabel.frame = CGRectMake(20, 20+height, 270, 30);
    }
    return cell;
}

#pragma mark - Facebook Request Calls

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
    NSLog(@"Result: %@", result);
    
    NSMutableArray *commentsArray = [[NSMutableArray alloc] initWithCapacity:wallPost.numComments];
    for (NSDictionary *curComments in [result objectForKey:@"data"]) {
        id commentName = [[curComments objectForKey:@"from"] objectForKey:@"name"];
        id commentMessage = [curComments objectForKey:@"message"];
        id commentDateStr = [curComments objectForKey:@"created_time"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ"];
        NSDate *commentDate = [df dateFromString:commentDateStr];
        FeedPost *commentPost = [[FeedPost alloc] init];
        commentPost.name = commentName;
        commentPost.message = commentMessage;
        commentPost.date = commentDate;
        
        [commentsArray addObject:commentPost];
    }
    
    wallPost.comments = nil;
    
    wallPost.comments = [commentsArray copy];
    
    retrievedResults = YES;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Request Failed");
}

#pragma mark - Instance Methods

- (void)loadComments {
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

@end
