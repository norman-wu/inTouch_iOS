//
//  AppDelegate.h
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>


//For GPS
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "NearByTableView.h"
#import "ContactsViewController.h"
#import "SelfViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

//GPS location manager

@property (strong, nonatomic) NearByTableView *nearByController;
@property (strong, nonatomic) ContactsViewController *contactsController;
@property (strong, nonatomic) SelfViewController *selfController;


@property (strong, nonatomic) UITabBarController *tabBarController;

@end
