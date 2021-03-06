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

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set up tab name
        self.title = @"Contacts";
        [self.tabBarItem setImage:[UIImage imageNamed:@"contacts.png"]];
        
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
    
    // download friends from cloud
    [PFCloud callFunctionInBackground:@"findFriends"
                       withParameters:@{}
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        // results are array of jsons
                                        [self.myFriends addObjectsFromArray:results];
                                    }
                                }];
    NSLog(@"MyFriends%d", [self.myFriends count]);
    

    
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
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MyFriends%d", [self.myFriends count]);
    //get the cell from the nib
    ContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsViewCell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //show friends if any
    
    if ([self.myFriends count] != 0) {
        PFObject *friendPointer = [self.myFriends objectAtIndex:indexPath.row];
        
        PFUser *friend = [PFQuery getUserObjectWithId:friendPointer.objectId];
        
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
- (UIImage *)downloadImage: (PFUser *)user
{
    UIImage *cellimage = nil;
    
    PFFile *profileImage = user[@"Photo"];
    NSData *imageData = [profileImage getData];
    cellimage = [UIImage imageWithData:imageData];
    
    return cellimage;
}





@end
