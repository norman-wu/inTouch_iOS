//
//  ContactsViewController.h
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *myFriends;
@property (weak, nonatomic) IBOutlet UITableView *ContractsTableView;

//test push for Weishi 4.20

@end
