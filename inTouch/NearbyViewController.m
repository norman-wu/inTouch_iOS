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
    [logInCtr setFields:PFLogInFieldsUsernameAndPassword
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
