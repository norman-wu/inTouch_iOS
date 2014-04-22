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
//All querry in this method is now blocking.
//(the logic is sequential, don't know how to use asynchronous method)

//TODO suppress run time warnings

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //creat a querry and count results
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friend"];
    
    [friendQuery whereKey:@"User_id" equalTo:[PFUser currentUser]];

    NSInteger numberOfRowsReturned = [friendQuery countObjects];
    return numberOfRowsReturned ? numberOfRowsReturned : 1;  //1 row if no friend
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the cell from the nib
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCellView"];
    
    //instantiate new cell if nil
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ContactsCellView"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    //query database
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friend"];
    [friendQuery whereKey:@"User_id" equalTo:[PFUser currentUser]];
    NSArray *friendQueryRecords = [friendQuery findObjects];
    
    
    //show friends if any
    if ([friendQueryRecords count]) {
        
        NSInteger rowNumber = indexPath.row;
        
        
        //first get the friend table record, then get the friend
        PFObject *friend = friendQueryRecords[rowNumber][@"Friend_id"]; //get a user obj
        
        
        //query the user table for more info
        PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
        PFObject *userRecord = [userQuery getObjectWithId:friend.objectId]; //get the user obj
        
        
        //fill the cell
        cell.textLabel.text = userRecord[@"username"];
        cell.detailTextLabel.text = userRecord[@"email"];
        
        
    } else{
        //no friend view
        cell.textLabel.text = @"Poor you! You have no friends yet. ";
        cell.detailTextLabel.text = @" It's ok. Keep inTouch and I could be your friend.";
       
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    //query database non blocking sample code for future reference @Weishi
//    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friend"];
//    
//    [friendQuery whereKey:@"User_id" equalTo:[PFUser currentUser]];
//
//    
//    
//    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            //show friends if any
//            if([objects count]){
//                for(PFObject *friendRecord in objects){//interate thru Friend table
//                    
//                    PFObject *friend = friendRecord[@"Friend_id"]; //get the User obj
//                    
//                    //query the user table for more info
//                    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
//                    PFObject *userRecord = [userQuery getObjectWithId:friend.objectId];
//                    NSLog(@"%@, %@", userRecord[@"username"],userRecord[@"email"]);
//                    
//                    //TODO doubt: why can't use friend[@“username”]?
//       
//                }
//            }
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retrieve failure" message:@"Unable to load" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//    }];
    
    NSLog(@"Hello, this is contact");
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
