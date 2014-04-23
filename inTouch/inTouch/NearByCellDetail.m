//
//  NearByCellDetail.m
//  inTouch
//
//  Created by yigu on 4/22/14.
//  Copyright (c) 2014 yigu. All rights reserved.
//

#import "NearByCellDetail.h"

@interface NearByCellDetail ()

@end

@implementation NearByCellDetail

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
    self.title = @"Detail";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNavi];
}

- (void)retrieveProfileInfo
{
    
}

- (void)downloadProfileImage
{
    PFQuery *storyQuery = [PFQuery queryWithClassName:@"Story"];
    
    
    
    [storyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] != 0) {
            PFObject *story = [objects objectAtIndex:[objects count] - 1];           // Store results
            PFFile *profileImage = story[@"media"];
            NSData *imageData = [profileImage getData];
            self.cellImage.image = [UIImage imageWithData:imageData];
        }else if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Retrieve failure" message:@"Unable to load or profile image does not exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];

}


@end
