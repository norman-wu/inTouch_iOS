//
//  ContactsCellDetail.h
//  inTouch
//
//  Created by yigu on 4/24/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContactsCellDetail : UIViewController

@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) IBOutlet UIImageView *contactImage;
@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UILabel *contactEmail;
@property (strong, nonatomic) IBOutlet UILabel *contactEducation;

@end
