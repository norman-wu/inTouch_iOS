//
//  NearbyCellView.m
//  inTouch
//
//  Created by Luo Wu on 4/19/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "NearbyCellView.h"


@implementation NearbyCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.addButton = [[UIButton alloc] init];
        
        
    }
    return self;
}

- (void) setUpViewComponents
{
    UIImage* button_img = [UIImage imageNamed:@"add.png"];
    
    [self.addButton setBackgroundImage:button_img forState:UIControlStateNormal];
}

- (void)awakeFromNib
{
    // Initialization code
    //[self setUpViewComponents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// add to Contacts
- (IBAction)addToContacts:(UIButton *)sender {
    
    UIImage *addImage = [UIImage imageNamed:@"addbutton.png"];
    // can only add strangers as friend
    if(self.buttonImage == addImage){
        // save a new friend
        PFObject *newFriend = [PFObject objectWithClassName:@"Friend"];
        newFriend[@"User_id"] = self.me;
        newFriend[@"Friend_id"] = self.friend;
        
        [newFriend saveInBackground];
        
        // change image of the button after a 2 seconds
        [UIView animateWithDuration:2.0 animations:^{
            self.buttonImage = [UIImage imageNamed:@"friend.png"];
            [self.addButton setBackgroundImage:self.buttonImage forState:UIControlStateNormal];
        }];
    }
}
@end
