//
//  AppDelegate.m
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>



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
   
    // initialize nearby view
    self.nearByController = [[NearbyViewController alloc] init];
    UINavigationController *nearByNav = [[UINavigationController alloc] initWithRootViewController:self.nearByController];
    
    // initialize contacts view
    self.contactsController = [[ContactsViewController alloc] init];
    UINavigationController *contactsNav = [[UINavigationController alloc] initWithRootViewController:self.contactsController];
    
    // initialize self view
    self.selfController = [[SelfViewController alloc] init];
    UINavigationController *selfNav = [[UINavigationController alloc] initWithRootViewController:self.selfController];
    
    // set up tabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: nearByNav, contactsNav, selfNav, nil];
    
}

#pragma mark Core Location UPDATE LOCATION



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
    [self.nearByController.locationManager pausesLocationUpdatesAutomatically];
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
