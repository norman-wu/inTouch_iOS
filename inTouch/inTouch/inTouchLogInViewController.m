//
//  inTouchLogInViewController.m
//  inTouch
//
//  Created by yigu on 4/3/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "inTouchLogInViewController.h"
#import "AppDelegate.h"
#import "NearbyCellView.h"
#import <Parse/Parse.h>

@interface inTouchLogInViewController () <FBLoginViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *buttonPickFriends;

//-(IBAction)pickFriendsClick:(UIButton *)sender;

-(void)pickFriendsClick: (id)sender;

@end



@implementation inTouchLogInViewController

// Pick Friends button handler
//- (IBAction)pickFriendsClick:(UIButton *)sender {
-(void)pickFriendsClick: (id)sender{
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }
         
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SignInUp2.JPG"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"App_Logo.png"]]];
    
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    CGRect frame = CGRectMake(100.0f, 100.0f, 100.0f, 30.0f);
    self.buttonPickFriends = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    self.buttonPickFriends.frame= frame;
    
    
    [self.buttonPickFriends setTitle:@"Pick friend" forState:UIControlStateNormal];
    
    self.buttonPickFriends.backgroundColor = [UIColor blueColor];
    
    
    
    [self.buttonPickFriends addTarget:self action:@selector(pickFriendsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:self.buttonPickFriends];
    
    
    
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
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
    
    //[self.view addSubview:loginview];
    
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
