//
//  SelfViewController.m
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "SelfViewController.h"
#import "SelfDetailViewController.h"

@interface SelfViewController ()

@end

@implementation SelfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self setUpNavi];
        
    }
    return self;
}

- (void)setUpNavi
{
    // set up title, left and right top buttons of the navigation
    self.title = @"Profile";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(signOutApp)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editProfile)];
}

- (void)signOutApp
{
    [PFUser logOut];
    
    // Instantiate our custom log in view controller
    inTouchLogInViewController *logInCtr = [self setUpLogIn];
    
    // Instantiate our custom sign up view controller
    inTouchSignUpViewController *signUpCtr = [self setUpSignUp];
    
    // Link the sign up view controller
    [logInCtr setSignUpController:signUpCtr];
    
    // Present log in view controller
    [self presentViewController:logInCtr animated:YES completion:nil];
}

- (void)editProfile
{
    // go to detail view
    SelfDetailViewController *detail = [[SelfDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self retrieveProfileInfo];
}

- (void)retrieveProfileInfo
{
    self.profileName.text = [[PFUser currentUser] username];
    self.profileEmail.text = [[PFUser currentUser] email];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
