//
//  inTouchLogInViewController.h
//  inTouch
//
//  Created by yigu on 4/3/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface inTouchLogInViewController : PFLogInViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

-(void)pickFriendsClick: (id)sender;

@end
