//
//  ContactsViewController.m
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "ContactsViewController.h"
#import <Parse/Parse.h>

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Contacts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.ContractsTableView registerNib:[UINib nibWithNibName:@"ContactsCellView" bundle:nil] forCellReuseIdentifier:@"ContactsCellView"];
    
    self.ContractsTableView.delegate = self;
    self.ContractsTableView.dataSource = self;

    
}

//--------------------table view------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PFQuery *testQuery = [PFQuery queryWithClassName:@"User"];
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCellView"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friend"];
    
    [friendQuery whereKey:@"User_id" equalTo:[PFUser currentUser]];
    
    NSLog(@"hello, this is contact");
    
    
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //show friends if any
            if([objects count]){
                for(PFObject *friendRecord in objects){//interate thru Friend table
                    
                    PFObject *friend = friendRecord[@"Friend_id"]; //get the User obj
                    
                    //query the user table for more info
                    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
                    PFObject *userRecord = [userQuery getObjectWithId:friend.objectId];
                    NSLog(@"%@, %@", userRecord[@"username"],userRecord[@"email"]);
                    
                    //TODO doubt: why can't use friend[@“username”]?
       
                }
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retrieve failure" message:@"Unable to load" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    NSLog(@"-------------------");
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
