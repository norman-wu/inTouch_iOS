//
//  NearByCellDetail.h
//  inTouch
//
//  Created by yigu on 4/22/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NearByCellDetail : UIViewController

@property (strong, nonatomic) NSString *cellId;
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;

@property (strong, nonatomic) IBOutlet UILabel *cellName;
@property (strong, nonatomic) IBOutlet UILabel *cellEmail;
@property (strong, nonatomic) IBOutlet UILabel *cellEducation;

@end
