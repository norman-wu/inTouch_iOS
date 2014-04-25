//
//  NearbyCellView.h
//  inTouch
//
//  Created by Luo Wu on 4/19/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NearbyCellView : UITableViewCell

@property (strong, nonatomic) UIImage *buttonImage;

@property (strong, nonatomic) PFUser *me;
@property (strong, nonatomic) PFUser *friend;

@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UILabel *CellName;
@property (strong, nonatomic) IBOutlet UIImageView *CellImage;
@property (strong, nonatomic) IBOutlet UILabel *cellEducation;

- (IBAction)addToContacts:(UIButton *)sender;


@end
