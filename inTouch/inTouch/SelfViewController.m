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
        self.title = @"Me";
        [self.tabBarItem setImage:[UIImage imageNamed:@"meTab.png"]];
        
    }
    return self;
}

//--------------------Navigation and Sign In/Up------------------//
- (void)setUpNavi
{
    // set up title, left and right top buttons of the navigation
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavi];
    
    self.profileImage.layer.cornerRadius = 90;
    self.profileImage.clipsToBounds = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    if([PFUser currentUser]){
        [self retrieveProfileInfo];
    }
}

//--------------------Backend Parse Functions------------------//

- (void)retrieveProfileInfo
{
    PFUser *user = [PFUser currentUser];
    
    // to update info
    [user refresh];
    
    self.profileName.text = user.username;
    self.profileEmail.text = user.email;
    self.profileEducation.text = user[@"education"];
    
    self.profileImage.image = [self downloadImage:user];
}

- (UIImage *)downloadImage: (PFUser *)user
{
    UIImage *cellimage = nil;
    
    PFFile *profileImage = user[@"Photo"];
    NSData *imageData = [profileImage getData];
    cellimage = [UIImage imageWithData:imageData];
    
    return cellimage;
}


// if user logged in, dissmiss the login View
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
