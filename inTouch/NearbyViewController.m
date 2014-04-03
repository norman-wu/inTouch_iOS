//
//  NearbyViewController.m
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "NearbyViewController.h"
#import "inTouchLogInViewController.h"
#import "inTouchSignUpViewController.h"

#import <Parse/Parse.h>

@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"NearBy";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// check if user has logged in
- (void)viewDidAppear:(BOOL)animated
{
    if(![PFUser currentUser]){
        // Instantiate our custom log in view controller
        inTouchLogInViewController *logInCtr = [self setUpLogIn];
        
        // Instantiate our custom sign up view controller
        inTouchSignUpViewController *signUpCtr = [self setUpSignUp];
        
        // Link the sign up view controller
        [logInCtr setSignUpController:signUpCtr];
        
        // Present log in view controller
        [self presentViewController:logInCtr animated:YES completion:nil];
    }
}

- (inTouchLogInViewController *) setUpLogIn
{
    inTouchLogInViewController *logInCtr = [[inTouchLogInViewController alloc] init];
    [logInCtr setDelegate:self];
    [logInCtr setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
    [logInCtr setFields: PFLogInFieldsDefault
     | PFLogInFieldsTwitter
     | PFLogInFieldsFacebook
     | PFLogInFieldsSignUpButton
     | PFLogInFieldsDismissButton];
    
    return logInCtr;
}

- (inTouchSignUpViewController *) setUpSignUp
{
    inTouchSignUpViewController *signUpCtr = [[inTouchSignUpViewController alloc] init];
    [signUpCtr setDelegate:self];
    [signUpCtr setFields: PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
    
    return signUpCtr;
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
