//
//  SelfViewController.h
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "inTouchLogInViewController.h"
#import "inTouchSignUpViewController.h"

@interface SelfViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UILabel *profileEmail;
@property (strong, nonatomic) IBOutlet UILabel *profileEducation;

@end
