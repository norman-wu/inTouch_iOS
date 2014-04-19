//
//  AppDelegate.m
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

#import "NearbyViewController.h"
#import "ContactsViewController.h"
#import "SelfViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // add Parse
    [Parse setApplicationId:@"gdx6O89iizP2Jg0ibFBfW9Df27o4lA9WCXuQDf2c"
                  clientKey:@"djP9wbuJnul2UIcnwyQU5t69JN4CmleqYLZfWOG5"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // initialize view controller with tabBar
    [self initializeViewController];
    
    self.window.rootViewController = self.tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initializeViewController
{
    //init LocationManager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    
    
    //start positioning
    [_locationManager startUpdatingLocation];

    
    // initialize nearby view
    UIViewController *nearByController = [[NearbyViewController alloc] init];
    UINavigationController *nearByNav = [[UINavigationController alloc] initWithRootViewController:nearByController];
    
    // initialize contacts view
    UIViewController *contactsController = [[ContactsViewController alloc] init];
    UINavigationController *contactsNav = [[UINavigationController alloc] initWithRootViewController:contactsController];
    
    // initialize self view
    UIViewController *selfController = [[SelfViewController alloc] init];
    UINavigationController *selfNav = [[UINavigationController alloc] initWithRootViewController:selfController];
    
    // set up tabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: nearByNav, contactsNav, selfNav, nil];
    
}

#pragma mark Core Location UPDATE LOCATION

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    CLLocation * currLocation = [locations lastObject];
    
    
    NSLog([NSString stringWithFormat:@"%3.20f", currLocation.coordinate.latitude]);
    NSLog([NSString stringWithFormat:@"%3.20f", currLocation.coordinate.longitude]);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    //stop positioning
    [_locationManager pausesLocationUpdatesAutomatically];

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
