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
@property (strong, nonatomic) IBOutlet UIButton *about;


//-(IBAction)pickFriendsClick:(UIButton *)sender;

-(void)pickFriendsClick: (id)sender;

-(void)aboutClick: (id) sender;

@end


@implementation inTouchSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        flag = 0;
        about_flag = 0;
    }
    return self;
}

- (IBAction) aboutClick: (id) sender{
    if (flag == 0) {
         [self.about setTitle:@"Yi Gu, Qiulu Gong, Luo Wu, Weishi Zeng" forState:UIControlStateNormal];
        flag = 1;
    }else{
        [self.about setTitle:@"" forState:UIControlStateNormal];
        flag = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SignInUp2.JPG"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"App_Logo.png"]]];
    
    
    
    //   [self.buttonPickFriends = [UIButton alloc] init];
    
    
    // self.buttonPickFriends.frame = CGRectOffset(self.buttonPickFriends.frame, 10, 10);
    
    //pick friend button, for test
    CGRect frame = CGRectMake(40.0f, 500.0f, 100.0f, 30.0f);
    self.buttonPickFriends = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buttonPickFriends.frame= frame;
    [self.buttonPickFriends setTitle:@"Pick friend" forState:UIControlStateNormal];
    self.buttonPickFriends.backgroundColor = [UIColor blueColor];
    [self.buttonPickFriends addTarget:self action:@selector(pickFriendsClick:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:self.buttonPickFriends];
    
    //---------------about button, shows authors information------------------------
    
    self.about = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.about.frame= frame;
    [self.about setTitle:@"" forState:UIControlStateNormal];
    //self.about.backgroundColor = [UIColor blueColor];
    [self.about addTarget:self action:@selector(aboutClick:) forControlEvents:UIControlEventTouchUpInside];
    self.about.frame = CGRectMake(0.0f, 110.0f, 350.0f, 50.0f);
    
    
    [self.view addSubview:self.about];
    FBLoginView *loginview = [[FBLoginView alloc] initWithReadPermissions:
                              @[@"basic_info", @"email", @"user_likes", @"user_education_history", @"user_location"]];
    
    
    
    loginview.frame = CGRectMake(40.0f, 365.0f, 10.0f, 8.0f);
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
    
    
    NSString *fbuid = user.id;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", fbuid]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    
    //--------------create a new user-----------------
    if (!flag) {
        
        PFUser *new_user =  [PFUser user];
        
        new_user.username = [NSString stringWithFormat:@"%@", user.name];
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
        
        
        
        // Save PFFile
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Create a PFObject around a PFFile and associate it with the current user
                [new_user setObject:imageFile forKey:@"Photo"];
                [new_user save];
            }
            else{
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        flag++;
        
    }
    
    
    //------------------------
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:@"inTouch"
                                                       caption:nil
                                                   description:@"I am using inTouch, please join and use it"
                                                       picture:nil
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               NSLog(@"Error: %@", error.description);
                                                           } else {
                                                               NSLog(@"Success!");
                                                           }
                                                       }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:nil
                                                                                    image:nil
                                                                                      url:urlToShare
                                                                                  handler:nil];
        
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
        performPublishAction:^{
            NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", user.first_name, [NSDate date]];
            
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            
            connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
            | FBRequestConnectionErrorBehaviorAlertUser
            | FBRequestConnectionErrorBehaviorRetry;
            
            [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                 completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                 }];
            [connection start];
            
        };
        }
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
