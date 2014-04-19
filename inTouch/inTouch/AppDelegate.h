//
//  AppDelegate.h
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import <UIKit/UIKit.h>


//For GPS
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) UIWindow *window;

//GPS location manager
@property(nonatomic, strong) CLLocationManager *locationManager;


@property (strong, nonatomic) UITabBarController *tabBarController;

@end
