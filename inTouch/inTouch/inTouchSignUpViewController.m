//
//  inTouchSignUpViewController.m
//  inTouch
//
//  Created by yigu on 4/3/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "inTouchSignUpViewController.h"

@interface inTouchSignUpViewController ()




@property (strong, nonatomic) IBOutlet UIButton *buttonPickFriends;

//-(IBAction)pickFriendsClick:(UIButton *)sender;

-(void)pickFriendsClick: (id)sender;


@end


@implementation inTouchSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        flag = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SignInUp2.JPG"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"App_Logo.png"]]];
    
    
    
    //   [self.buttonPickFriends = [UIButton alloc] init];
    
    
    // self.buttonPickFriends.frame = CGRectOffset(self.buttonPickFriends.frame, 10, 10);
    
    CGRect frame = CGRectMake(40.0f, 500.0f, 100.0f, 30.0f);
    self.buttonPickFriends = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    self.buttonPickFriends.frame= frame;
    
    
    [self.buttonPickFriends setTitle:@"Pick friend" forState:UIControlStateNormal];
    
    self.buttonPickFriends.backgroundColor = [UIColor blueColor];
    
    
    
    [self.buttonPickFriends addTarget:self action:@selector(pickFriendsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:self.buttonPickFriends];
    
    
    FBLoginView *loginview = [[FBLoginView alloc] initWithReadPermissions:
                              @[@"basic_info", @"email", @"user_likes", @"user_education_history", @"user_location"]];
    

    
    loginview.frame = CGRectMake(40.0f, 435.0f, 10.0f, 8.0f);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, 5, 25);
    }
#endif
#endif
#endif
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];
    
    self.buttonPickFriends = nil ;
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    
    
    self.buttonPickFriends.enabled = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    //self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    //self.profilePic.profileID = user.id;
    //self.loggedInUser = user;
    
    
    
    
    NSLog(user.first_name);
    NSLog(user.last_name);
    
    NSLog([user objectForKey:@"email"]);
    
    //NSLog([user objectForKey:@"user_birthday"]);
    
    NSLog([user objectForKey:@"user_education_history"]);
    
     NSLog([user objectForKey:@"user_location"]);
    
    NSString *fbuid = user.id;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?", fbuid]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    
    //--------------create a new user-----------------
    if (!flag) {
        
    PFUser *new_user =  [PFUser user];
    new_user.username = [NSString stringWithFormat:@"%@%@", user.first_name, user.last_name];
    new_user.email = [user objectForKey:@"email"];
    new_user[@"education"] = @"CMU";
    new_user.password = @"123";
    
    [new_user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }else{
        }
    }];

    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"Story"];
            [userPhoto setObject:imageFile forKey:@"media"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:new_user];
            
            [userPhoto setObject:new_user forKey:@"Author"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
        flag++;
        
    }

    
    //[NearbyViewController.self dismissViewControllerAnimated:YES completion:nil];
    
    //start positioning
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
