//
//  NearbyCellView.h
//  inTouch
//
//  Created by Luo Wu on 4/19/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyCellView : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UILabel *CellName;
@property (strong, nonatomic) IBOutlet UIImageView *CellImage;

- (IBAction)addToContacts:(UIButton *)sender;


@end
