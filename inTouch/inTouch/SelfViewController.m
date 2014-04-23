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
}

- (void)viewWillAppear:(BOOL)animated
{
    if([PFUser currentUser]){
        [self retrieveProfileInfo];
    }
}


- (void)retrieveProfileInfo
{
    PFUser *user = [PFUser currentUser];
    
    // to update info
    [user refresh];
    
    self.profileName.text = user.username;
    self.profileEmail.text = user.email;
    self.profileEducation.text = user[@"education"];
    
    [self downloadProfileImage];
}

- (void)downloadProfileImage
{
    PFQuery *storyQuery = [PFQuery queryWithClassName:@"Story"];
    
    [storyQuery whereKey:@"Author" equalTo:[PFUser currentUser]];
    
    [storyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] != 0) {
            PFObject *story = [objects objectAtIndex:[objects count] - 1];           // Store results
            PFFile *profileImage = story[@"media"];
            NSData *imageData = [profileImage getData];
            self.profileImage.image = [UIImage imageWithData:imageData];
        }else if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retrieve failure" message:@"Unable to load or profile image does not exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];

}

// if user logged in, dissmiss the login View
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
