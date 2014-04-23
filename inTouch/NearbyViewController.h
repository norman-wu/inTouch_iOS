//
//  NearbyViewController.h
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"


@interface NearbyViewController : UIViewController <PFLogInViewControllerDelegate,    PFSignUpViewControllerDelegate, UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;

@end
