//
//  NearByTableView.h
//  inTouch
//
//  Created by yigu on 5/25/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <Parse/Parse.h>

@interface NearByTableView : PFQueryTableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;


@end
