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
    [self setUpViewComponents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addToContacts:(UIButton *)sender {
}
@end
