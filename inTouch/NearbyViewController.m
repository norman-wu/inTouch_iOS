//
//  NearbyViewController.m
//  inTouch
//
//  Created by yigu on 4/2/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//


#import "AppDelegate.h"
#import "NearbyViewController.h"
#import "inTouchLogInViewController.h"
#import "inTouchSignUpViewController.h"
#import "NearbyCellView.h"

#import <Parse/Parse.h>

@interface NearbyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *NearbyTableView;
@property (strong, nonatomic) NSArray *PeopleNearby;
@property (strong, nonatomic) NSMutableArray *myFriends;

@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"NearBy";
        [self.tabBarItem setImage:[UIImage imageNamed:@"nearBy.png"]];
        
        self.PeopleNearby = [[NSArray alloc] init];
        self.myFriends = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)setUpGPS
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    if([PFUser currentUser]){
        //start positioning
        [self setUpGPS];
        [self.locationManager startUpdatingLocation];
        
        [self findMyFriends];
        [self.NearbyTableView reloadData];
    }
}

- (void)loadTableView
{
    [self.NearbyTableView registerNib:[UINib nibWithNibName:@"NearbyCellView" bundle:nil] forCellReuseIdentifier:@"NearbyCellView"];
    
    self.NearbyTableView.delegate = self;
    self.NearbyTableView.dataSource = self;
}


//--------------------Check Sign in------------------
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

//--------------table view-------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.PeopleNearby count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyCellView"];
    
    if(indexPath.row < [self.PeopleNearby count]){
        PFUser *user = [self.PeopleNearby objectAtIndex:indexPath.row];
        
        cell.buttonImage = [UIImage imageNamed:@"addbutton.png"];
        // check if someone is already user's friend
        for(int i = 0; i < [self.myFriends count]; i++){
            PFObject *friendPointer = [self.myFriends objectAtIndex:i];
            if([[user objectId] isEqual:friendPointer.objectId]){
                cell.buttonImage = [UIImage imageNamed:@"friend.png"];
            }
        }
        
        if([user.objectId isEqual:[PFUser currentUser].objectId]){
            cell.buttonImage = [UIImage imageNamed:@"me.png"];
        }
        
        // pass the value to cell
        cell.me = [PFUser currentUser];
        cell.friend = user;
        
        [cell.addButton setBackgroundImage:cell.buttonImage forState:UIControlStateNormal];
        cell.CellName.text = user[@"username"];
        cell.cellEducation.text = user[@"education"];
        cell.CellImage.image = [self downloadImage:user];   
    }
    return cell;
}

// if user logged in, dissmiss the login View and start the gps
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //start positioning
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currLocation = [locations lastObject];
    
    [self postLocation:currLocation];
    [self findNearByPeople];
}

//--------------------Backend Parse Functions------------------
- (UIImage *)downloadImage: (PFUser *)user
{
    UIImage *cellimage = nil;
    
    PFQuery *storyQuery = [PFQuery queryWithClassName:@"Story"];
    
    [storyQuery whereKey:@"Author" equalTo:user];
    
    NSArray *storyObjects = [storyQuery findObjects];
    
    if([storyObjects count] != 0){
        
        PFObject *story = [storyObjects objectAtIndex:[storyObjects count] - 1];           // Store results
        PFFile *profileImage = story[@"media"];
        NSData *imageData = [profileImage getData];
        cellimage = [UIImage imageWithData:imageData];
    }
    
    return cellimage;
}


- (void) postLocation:(CLLocation *) currLocation
{
    PFUser *user = [PFUser currentUser];
    
    PFGeoPoint *currGeo = [PFGeoPoint geoPointWithLatitude:currLocation.coordinate.latitude longitude:currLocation.coordinate.longitude];
    
    user[@"Location"] = currGeo;
    
    [user refresh];
}

- (void)findNearByPeople
{
    PFUser *user = [PFUser currentUser];
    
    // User's location
    PFGeoPoint *userGeoPoint = user[@"Location"];
    
    // Create a query for places
    PFQuery *query = [PFUser query];
    
    // Interested in locations near user.
    [query whereKey:@"Location" nearGeoPoint:userGeoPoint];
    
    // Limit what could be a lot of points.
    query.limit = 10;
    
    // Final list of objects
    self.PeopleNearby = [query findObjects];
    
    [self.NearbyTableView reloadData];
}

- (void)findMyFriends
{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friend"];
    [friendQuery whereKey:@"User_id" equalTo:user];
    
    for(int i = 0; i < [[friendQuery findObjects] count]; i++){
        [self.myFriends addObject:[[friendQuery findObjects] objectAtIndex:i][@"Friend_id"]];
    }
}


@end
