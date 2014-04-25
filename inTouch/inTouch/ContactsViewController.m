//
//  ContactsViewController.m
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsCellDetail.h"
#import "ContactsViewCell.h"
#import <Parse/Parse.h>

@interface ContactsViewController ()

@property (strong, nonatomic) NSMutableArray *myFriends;

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set up tab name
        self.title = @"Contacts";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.myFriends = [[NSMutableArray alloc] init];
    [self findMyFriends];
    
    [self.ContractsTableView reloadData];
}

- (void)loadTableView
{
    [self.ContractsTableView registerNib:[UINib nibWithNibName:@"ContactsViewCell" bundle:nil] forCellReuseIdentifier:@"ContactsViewCell"];
    
    self.ContractsTableView.delegate = self;
    self.ContractsTableView.dataSource = self;
}

//--------------------table view------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myFriends count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the cell from the nib
    ContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsViewCell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //show friends if any
    if ([self.myFriends count] != 0) {
        PFObject *friendPointer = [self.myFriends objectAtIndex:indexPath.row];
        
        PFUser *friend = [PFQuery getUserObjectWithId:friendPointer.objectId];
        
        NSLog(@"\n\n%@\n\n", friend[@"username"]);
        
        cell.contactName.text = friend[@"username"];
        cell.contactImage.image = [self downloadImage:friend];
        
        
    } else{
        //no friend view
        cell.contactName.text = @"Poor you! You have no friends yet. ";
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactsCellDetail *detail = [[ContactsCellDetail alloc] init];
    
    PFUser *user = [self.myFriends objectAtIndex:indexPath.row];
    
    detail.contactId = [user objectId];
    
    [self.navigationController pushViewController:detail animated:YES];
}

//--------------------Backend Parse Functions------------------
- (void)findMyFriends
{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friend"];
    [friendQuery whereKey:@"User_id" equalTo:user];
    
    for(int i = 0; i < [[friendQuery findObjects] count]; i++){
        [self.myFriends addObject:[[friendQuery findObjects] objectAtIndex:i][@"Friend_id"]];
    }
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"Friend"];
    
    [userQuery whereKey:@"Friend_id" equalTo:user];
    
    for(int i = 0; i < [[userQuery findObjects] count]; i++){
        [self.myFriends addObject:[[userQuery findObjects] objectAtIndex:i][@"User_id"]];
    }
}

- (UIImage *)downloadImage: (PFUser *)user
{
    UIImage *cellimage = nil;
    
    PFQuery *storyQuery = [PFQuery queryWithClassName:@"Story"];
    
    [storyQuery whereKey:@"Author" equalTo:user];
    
    NSArray *storyObjects = [storyQuery findObjects];
    
    if([storyObjects count] != 0){
        
        PFObject *story = [storyObjects objectAtIndex:[storyObjects count] - 1];           // Store results
        PFFile *profileImage = story[@"media"];
        NSData *imageData = [profileImage getData];
        cellimage = [UIImage imageWithData:imageData];
    }
    
    return cellimage;
}





@end
