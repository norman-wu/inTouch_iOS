//
//  ContactsViewCell.m
//  inTouch
//
//  Created by yigu on 4/24/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "ContactsViewCell.h"

@implementation ContactsViewCell

- (void)awakeFromNib
{
    // set the image to round
    self.contactImage.layer.cornerRadius = 22.5;
    self.contactImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
