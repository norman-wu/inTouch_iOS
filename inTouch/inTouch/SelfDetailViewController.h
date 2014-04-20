//
//  SelfDetailViewController.h
//  inTouch
//
//  Created by yigu on 4/19/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfDetailViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameSet;
@property (strong, nonatomic) IBOutlet UITextField *emailSet;
@property (strong, nonatomic) IBOutlet UITextField *educationSet;

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@property (strong, nonatomic) IBOutlet UIButton *uploadImageButton;
- (IBAction)uploadImage:(UIButton *)sender;


@end
